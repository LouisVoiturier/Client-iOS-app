//
//  HomeViewController.m
//  Louis
//
//  Created by François Juteau on 14/09/2015.
//  Copyright (c) 2015 Louis. All rights reserved.
//

#import "HomeViewController.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "Common.h"
#import "HomeBottomSlideView.h"
#import "SearchView.h"
#import "AutocompletionTableViewController.h"
#import "LocationPinView.h"
#import "DataManager+ServiceHours.h"
#import "DataManager+User.h"
#import "ResearchPopupView.h"
#import "ValetAnnotation.h"
#import "RDVPinAnnotation.h"
#import "ValetFakerManager.h"
#import "ImageManager.h"
#import "InCourseBottomView.h"
#import "SecurityCodeView.h"
#import "RDVPinAnnotationView.h"
#import "HomeViewController+FeedBack.h"
#import "DataManager+Order.h"
#import "AddPaymentTableViewController.h"
#import "Socket_IO_Client_Swift-Swift.h"

/*************************/
/***** DEBUG DEFINES *****/
/*************************/
// Soit l'un soit l'autre
/** Utiliser l'application sans liaison avec socket.io, remplacé par des timer */
#define DEBUG_WITH_TIMER

/** Utiliser l'application avec socket.io et l'application voiturier */
//#define DEBUG_WITH_SOCKET

typedef NS_ENUM(NSUInteger, HourExceptionState)
{
    HourExceptionStateNone,
    HourExceptionStateOff,
    HourExceptionStateUndefined
};


typedef NS_ENUM(NSUInteger, ReservationState)
{
    /** Aucune reservation n'a commencé */
    ReservationStateNone,
    /** Temps de chargement de recherche d'un voiturier pour venir chercher la voiture */
    ReservationStateLoadingForPickup,
    /** Attente d'un voiturier pour venir chercher la voiture */
    ReservationStateWaitingForPickup,
    /** Le voiturier est en train de garer la voiture */
    ReservationStateToParking,
    /** La voiture est garée, attente que l'utilisateur demande sa voiture*/
    ReservationStateParked,
    /** Temps de chargement de recherche d'un voiturier pour récupérer la voiture */
    ReservationStateLoadingForGiveBack,
    /** Attente d'un voiturier pour récupérer la voiture */
    ReservationStateWaitingForGiveBack,
    /** La réservation est terminé on doit afficher la popup de rating */
    ReservationStateDisplayRatings,
    /** On peut retourner à l'état initial */
    ReservationStateDone
};


@interface HomeViewController () <CLLocationManagerDelegate, UIActionSheetDelegate, SearchViewDelegate, MKMapViewDelegate, HomeBottomSlideDelegate, LocationPinViewDelegate, SecurityCodeViewDelegate, AddPaymentTableViewControllerDelegate>

/**************************/
/***** CUSTOM OBJECTS *****/
/**************************/

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) HomeBottomSlideView *homeBottomView;
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) LocationPinView *locationPinView;
@property (nonatomic, strong) MKPolygonRenderer *polygonView;
@property (nonatomic, strong) SecurityCodeView *securityCodeView;
@property (nonatomic, strong) InCourseBottomView *inCourseBottomView;
@property (nonatomic, strong) RDVPinAnnotation *rdvAnnotation;
@property (nonatomic, strong) ValetFaker *currentValet;


/*********************/
/***** SOCKET.IO *****/
/*********************/

@property (nonatomic, strong) SocketIOClient *socket;


/******************************/
/***** FOUNDATION OBJECTS *****/
/******************************/

/** Etats de la reservation  */
@property (nonatomic) NSInteger reservationState;
// YES si la dernière location du pin était dans la zone
@property (nonatomic) BOOL isLastLocationInZone;
@property (nonatomic) NSInteger hourExceptionState;
/** Emplacement actuel du pin en coordonnée */
@property (nonatomic, strong) CLLocation *currentPickUpLocation;
/** Emplacement actuel des valets */
@property (nonatomic, strong) NSArray *valetsArray;
/** Centre de la zone couverte par le service */
@property  (nonatomic) CLLocation *zoneCenter;

@end



@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ===== Menu Configuration ===== //
    [self configureSWRevealViewControllerForViewController:self
                                            withMenuButton:[self menuButton]];
    [self revealViewController].comonHomeViewController = self;
    
    /********************/
    /***** MAP VIEW *****/
    /********************/
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self localizeUser];
    
    
    /***************************/
    /***** HOMEBOTTOM VIEW *****/
    /***************************/
    CGFloat homeBottomHeight = 44;
    CGFloat homeBottomStartY = self.view.frame.size.height - homeBottomHeight;
    
    self.homeBottomView = [[HomeBottomSlideView alloc] initWithFrame:CGRectMake(0, homeBottomStartY, self.view.frame.size.width, homeBottomHeight)];
    [self.homeBottomView.bookButton addTarget:self action:@selector(handleBookValet:) forControlEvents:UIControlEventTouchUpInside];
    
    self.homeBottomView.delegate = self;
    [self.view addSubview:self.homeBottomView];
    
    // On commence off zone
    [self.homeBottomView changeToExceptionOffZone];
    self.isLastLocationInZone = NO;
    
    
    /***********************/
    /***** SEARCH VIEW *****/
    /***********************/
    self.searchView = [[SearchView alloc] initWithFrame:CGRectMake(15, 80, self.view.frame.size.width - 30, 60)];
    self.searchView.delegate = self;
    
    [self.view addSubview:self.searchView];
    
    
    /********************/
    /***** PIN VIEW *****/
    /********************/
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat selfWidth = self.view.frame.size.width;
    CGFloat selfHeight = self.view.frame.size.height - navHeight;
    CGFloat locationPointOffset = 10; // L'offest du point rouge qui geolocalise
    
    CGFloat pinWidth = selfWidth * 0.5;
    CGFloat pinHeight = selfHeight * 0.1;
    CGFloat pinX = (selfWidth * 0.5) - (pinWidth * 0.5);
    CGFloat pinY = (selfHeight * 0.5) - pinHeight + navHeight - locationPointOffset;
    
    self.locationPinView = [[LocationPinView alloc] initWithFrame:CGRectMake(pinX, pinY, pinWidth, pinHeight)];
    
    self.locationPinView.delegate = self;
    [self.view addSubview:self.locationPinView];
    
    
    /**************************/
    /***** RDV ANNOTATION *****/
    /**************************/
    self.rdvAnnotation = [[RDVPinAnnotation alloc] init];
    
    
    /***********************/
    /***** HEADER LOGO *****/
    /***********************/
    UIView *headerView = [[UIView alloc] init];
    [headerView setFrame:CGRectMake(0, 0, 33, 33)];
    UIImageView *headerLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoNavBar"]];
    [headerLogo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:headerLogo];
    [[self navigationItem] setTitleView:headerView];
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(headerLogo);
    
    [headerView addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerLogo]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDict]];

    [headerView addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerLogo]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDict]];

    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerLogo
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0]];

    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerLogo
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    /*****************/
    /***** HOURS *****/
    /*****************/
    [DataManager getNextOpenhourCompletion:^(NSString *message, NSHTTPURLResponse *httpResponse, NSError *error)
    {
        if (httpResponse.statusCode != 200)
        {
            [HTTPResponseHandler handleHTTPResponse:httpResponse
                                        withMessage:@""
                                      forController:self
                                     withCompletion:^
             {
                 nil;
             }];
        }
        else
        {
            if ([message isEqual:@""])
            {
                _hourExceptionState = HourExceptionStateNone;
            }
            else
            {
                _hourExceptionState = HourExceptionStateOff;
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    [_homeBottomView layoutChangeToOffHourWithMessage:message];
                });
            }
        }
    }];
    
    
    /**********************/
    /***** BOUNDARIES *****/
    /**********************/
    [self addBoundary];
    
    
    /*********************************/
    /***** IN COURSE BOTTOM VIEW *****/
    /*********************************/
    CGFloat ICBVWidth = self.view.frame.size.width;
    CGFloat ICBVHeight = 117.0f;
    CGFloat ICBVOriginX = 0.0f;
    CGFloat ICBVOriginY = self.view.frame.size.height - ICBVHeight;
    
    self.inCourseBottomView = [[InCourseBottomView alloc] initWithFrame:CGRectMake(ICBVOriginX, ICBVOriginY, ICBVWidth, ICBVHeight)];
    
    [self.inCourseBottomView.callButton addTarget:self action:@selector(handleCallButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.inCourseBottomView.smsButton addTarget:self action:@selector(handleSMSButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inCourseBottomView];
    
    
    /******************************/
    /***** SECURITY CODE VIEW *****/
    /******************************/
    CGFloat SCVVWidth = 68.f;
    CGFloat SCVHeight = 45.f;
    CGFloat SCVOriginX = self.view.frame.size.width - 68.f - 6.f;
    CGFloat SCVOriginY = self.view.frame.size.height - SCVHeight - ICBVHeight; // Le code de sécurité se place au dessus de la inCourseView
    
    _securityCodeView = [[SecurityCodeView alloc] initWithFrame:CGRectMake(SCVOriginX, SCVOriginY, SCVVWidth, SCVHeight)];
    
    self.securityCodeView.delegate = self;
    [self.view addSubview:_securityCodeView];
    
    
    /*********************/
    /***** SOCKET.IO *****/
    /*********************/
    self.socket = [[SocketIOClient alloc] initWithSocketURL:@"https://salty-citadel-4114.herokuapp.com:443" options:nil];
    [self.socket connect];
    
    
    /**************************/
    /***** STARTING SETUP *****/
    /**************************/
    [self changeToNoneState];
    self.reservationState = ReservationStateNone;
}


/**
 *  @author François  Juteau, 15-09-14 06:09:59
 *
 *  @brief  Start the user localization
 */
-(void)localizeUser
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
}


/**
 *  @author François  Juteau, 15-09-14 06:09:58
 *
 *  @brief  Localize a user from the adresse entered in the searchBar
 */
-(void)localizeUserByAdress
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    NSString *adressString = [NSString stringWithFormat:@"%@", self.searchView.textField.text];
    [geoCoder geocodeAddressString:adressString completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error : %@", error.localizedDescription);
         }
         else
         {
             if (placemarks.count > 0)
             {
                 CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                 self.currentPickUpLocation = placeMark.location;
                 [self changeLocalizeButtonColor];
                 
                 [self displayWithLocation:self.currentPickUpLocation];
             }
         }
     }];
}


/**
 *  @author François  Juteau, 15-09-14 06:09:42
 *
 *  @brief  Display the user with a given location
 *  @param location user location
 */
-(void)displayWithLocation:(CLLocation *)location
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
}


#pragma mark - Methods

-(void)changeLocalizationWithAdress:(NSString *)adress
{
    self.searchView.textField.text = adress;
    [self localizeUserByAdress];
}


-(void)changeMapStateFromLocation:(CLLocationCoordinate2D)coordinate
{
    bool isLocationInZone = [self setPinDescriptionFromLocation:coordinate];
    if (isLocationInZone != self.isLastLocationInZone) // Check si le Pin est toujours dans le même état pour ne pas répété les instructions
    {
        if (isLocationInZone)
        {
            [self.homeBottomView changeToNoException];
            self.isLastLocationInZone = YES;
        }
        else
        {
            [self.homeBottomView changeToExceptionOffZone];
            self.isLastLocationInZone = NO;
        }
    }
}


-(BOOL)setPinDescriptionFromLocation:(CLLocationCoordinate2D)coordinate
{
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    
    CGPoint polygonViewPoint = [self.polygonView pointForMapPoint:mapPoint];
    
    
    if ( CGPathContainsPoint(self.polygonView.path, NULL, polygonViewPoint, NO) ) // Si le marqueur est dans la zone
    {
        [self.locationPinView changeToInZoneContent];
        return YES;
    }
    else
    {
        [self.locationPinView changeToOffZoneContent];
        
        return NO;
    };
}


-(void)setAdressFromLocation:(CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    self.currentPickUpLocation = location;
    [self changeLocalizeButtonColor];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *adress;
             if (![placemark subThoroughfare] && ![placemark thoroughfare])
             {
                 adress = @"";
             }
             else
             {
                adress = [NSString stringWithFormat:@"%@ %@, %@", [placemark subThoroughfare], [placemark thoroughfare], [placemark postalCode]];
             }
             adress = [adress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];  // S'il y a une donnée null on ne l'affiche pas
             
             self.searchView.textField.text = adress;
         }
     }];
}

/***************************/
/***** ZONE DU SERVICE *****/
/***************************/
#pragma mark - Zone du service

-(void)addBoundary
{
    int nbCoordsPoints = 5;
    CLLocationCoordinate2D coords[5] = {
        CLLocationCoordinate2DMake(48.874613, 2.350091),
        CLLocationCoordinate2DMake(48.875051, 2.364504),
        CLLocationCoordinate2DMake(48.867561, 2.367671),
        CLLocationCoordinate2DMake(48.867561, 2.347524),
        CLLocationCoordinate2DMake(48.874613, 2.350091)
    };

    self.zoneCenter = [[CLLocation alloc] initWithLatitude:48.871113f longitude:2.358392f];
    
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coords
                                                     count:nbCoordsPoints];
    
    [polygon setTitle:@"OK"];
    [self.mapView addOverlay:polygon];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:MKPolygon.class])
    {
        self.polygonView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        self.polygonView.strokeColor = [UIColor louisMainColor];
        self.polygonView.lineWidth = 1;
        self.polygonView.fillColor = [[UIColor louisMainColor] colorWithAlphaComponent:0.085];
        
        return self.polygonView;
    }
    
    return nil;
}


/** Change la couleur du bouton de localisation si on est placer sur la position du user */
-(void)changeLocalizeButtonColor
{
    if ([self isFirstCoordinates:self.locationManager.location.coordinate equalishSecondCoordinates:self.currentPickUpLocation.coordinate])
    {
        [self.searchView changeLocalizeButtonToUserLocationColor];
    }
    else
    {
        [self.searchView changeLocalizeButtonToOtherLocationColor];
    }
    
}


/** Compare deux coordonnées pour savoir si elles sont approximativement éguale */
-(BOOL)isFirstCoordinates:(CLLocationCoordinate2D)firstCoords equalishSecondCoordinates:(CLLocationCoordinate2D)secondCoords
{
    CGFloat precision = 1500.f;
    CGFloat approxFirstLatitude = round(firstCoords.latitude * precision) / precision;
    CGFloat approxFirstLongitude = round(firstCoords.longitude * precision) / precision;
    CGFloat approxSecondLatitude = round(secondCoords.latitude * precision) / precision;
    CGFloat approxSecondLongitude = round(secondCoords.longitude * precision) / precision;
    
    return (approxFirstLatitude == approxSecondLatitude && approxFirstLongitude == approxSecondLongitude);
}


/*****************************/
/***** STATES MANAGEMENT *****/
/*****************************/
#pragma mark - States handlers


-(void)changeToNextState
{
    self.reservationState++;
    
    switch (self.reservationState)
    {
        case ReservationStateNone:  /** Aucune reservation n'a commencé */
            [self changeToNoneState];
            break;
            
        case ReservationStateLoadingForPickup:  /** Temps de chargement de recherche d'un voiturier pour venir chercher la voiture */
            [self changeToLoadingForPickupState];
            break;
            
        case ReservationStateWaitingForPickup:  /** Attente d'un voiturier pour venir chercher la voiture */
            [self changeToWaitingForPickupState];
            break;
            
        case ReservationStateToParking:  /** Le voiturier est en train de garer la voiture */
            [self changeToToParkingState];
            break;
            
        case ReservationStateParked:  /** La voiture est garée, attente que l'utilisateur demande sa voiture*/
            [self changeToParkedState];
            break;
            
        case ReservationStateLoadingForGiveBack:  /** Temps de chargement de recherche d'un voiturier pour récupérer la voiture */
            [self changeToLoadingForGiveBackState];
            break;
            
        case ReservationStateWaitingForGiveBack:  /** Attente d'un voiturier pour récupérer la voiture */
            [self changeToWaitingForGiveBackState];
            break;
            
        case ReservationStateDisplayRatings:  /** La réservation est terminé on doit afficher la popup de rating */
            [self changeToDisplayRatingsState];
            break;
            
        case ReservationStateDone:  /** On peut retourner à l'état initial */
            [self changeToDoneState];
            break;
            
        default:
            break;
    }
}

-(void)changeToNoneState
{
    self.reservationState = ReservationStateNone;
    
    [self.homeBottomView changeDescriptionTextsToBook];
    [self.homeBottomView changeBookButtonStateToBook];
    [self.homeBottomView layoutChangeToBookInfoClose];
    
    [self.view addSubview:self.homeBottomView];
    [self.view addSubview:self.locationPinView];
    [self.view addSubview:self.searchView];  // Au cas où on revienne du parkedState
    
    [self.inCourseBottomView removeFromSuperview];
    [self.securityCodeView removeFromSuperview];

    
    /*****************************/
    /***** ADD VALETS FAKERS *****/
    /*****************************/
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.valetsArray = [ValetFakerManager sharedInstance].valetFakers;
    
    for (ValetFaker *item in self.valetsArray)
    {
        ValetAnnotation *annotation = [[ValetAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([item getFakerCurrentLocation].lattitude, [item getFakerCurrentLocation].longitude);
        [self.mapView addAnnotation:annotation];
    }
    
    self.navigationItem.rightBarButtonItem = nil;
}


-(void)changeToLoadingForPickupState
{
    self.reservationState = ReservationStateLoadingForPickup;
    
    ResearchPopupView *RPV = [[ResearchPopupView alloc] init];
    [RPV changeToSearchingStateWithMessage:NSLocalizedString(@"ResearchPopup-BotText-Searching", @"")];
    
    
    [DataManager checkInWithLocation:[[Coords alloc] initWithCLLocation2D:self.currentPickUpLocation.coordinate]
                          completion:^(Order *order, NSHTTPURLResponse *httpResponse, NSError *error)
    {
        if (httpResponse.statusCode != 200)
        {
            [HTTPResponseHandler handleHTTPResponse:httpResponse
                                        withMessage:@""
                                      forController:self
                                     withCompletion:^
             {
                 nil;
             }];
        }
        else
        {
            NSLog(@"ORDER : %@, error : %@", order, error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [RPV changeToFoundState];
            });
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               [RPV dismiss];
                               [self changeToNextState];
                           });
        }
    }];
    
//    [ValetFakerManager requestAValetWithLocation:CLLocationCoordinate2DMake(0, 0) completion:^(BOOL isAvailable)
//     {
//         [RPV changeToFoundState];
//         dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//         dispatch_async(aQueue, ^
//                        {
//                            [NSThread sleepForTimeInterval:1.0f];
//                            dispatch_async(dispatch_get_main_queue(), ^
//                                           {
//                                               [RPV removeFromSuperview];
//                                               [self changeToNextState];
//                                           });
//                        });
//     }];
}


-(void)changeToWaitingForPickupState
{
    self.reservationState = ReservationStateWaitingForPickup;
    
    [self.view addSubview:self.inCourseBottomView];
    [self.view addSubview:self.securityCodeView];
    
    [self.homeBottomView removeFromSuperview];
    [self.locationPinView removeFromSuperview];
    
    NSString *checkinId = [DataManager order].checkIn._id;
    self.securityCodeView.codeLabel.text = [[checkinId substringFromIndex:checkinId.length - 4] uppercaseString];
    
    
    [ImageManager getImageFromUrlPath:[DataManager order].checkIn.valet.picture withCompletion:^(UIImage *image)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            self.inCourseBottomView.imageView.image = image;
                        });
     }];
    [self.inCourseBottomView setNameLabelText:[DataManager order].checkIn.valet.firstName];
    
    
    /***********************************/
    /***** ADD CURRENT VALET FAKER *****/
    /***********************************/
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    
//    ValetAnnotation *valetAnnotation = [[ValetAnnotation alloc] init];
//    valetAnnotation.coordinate = CLLocationCoordinate2DMake([self.currentValet getFakerCurrentLocation].lattitude, [self.currentValet getFakerCurrentLocation].longitude);
//    [self.mapView addAnnotation:valetAnnotation];
    
    
    /**************************************/
    /***** ADD CURRENT RDV ANNOTATION *****/
    /**************************************/
    self.rdvAnnotation = [[RDVPinAnnotation alloc] init];
    self.rdvAnnotation.coordinate = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    [self.mapView addAnnotation:self.rdvAnnotation];
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(handleCancelReservation:)];
    cancelItem.tintColor = [UIColor louisMainColor];
    
    self.navigationItem.rightBarButtonItem = cancelItem;
    
#ifdef DEBUG_WITH_TIMER
    // POUR LE TEST
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [self changeToNextState];
    });
#endif
    
    
#ifdef DEBUG_WITH_SOCKET
    // TEST DE SOCKET.IO
    NSDictionary *checkinDictionary = @{@"check":@"Checkin",
                                        @"clientEmail":[DataManager user].email,
                                        @"clientFirstName":[DataManager order].client.firstName,
                                        @"clientLastName":[DataManager order].client.lastName,
//                                        @"vehicleBrand":[DataManager order].vehicle.brand,
//                                        @"vehicleModel":[DataManager order].vehicle.model,
//                                        @"vehicleColor":[DataManager order].vehicle.color,
////                                        @"vehiclePlate":[DataManager order].vehicle.numberPlate,
                                        @"securityCode":self.securityCodeView.codeLabel.text,
                                        @"coordinates":@{@"latitude":[NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.latitude],
                                                         @"longitude":[NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.longitude]}};
    
    [self.socket emit:@"CheckinPickup"
            withItems:@[[DataManager order].checkIn.valet.lastName,
                        checkinDictionary]];
    
    
    [self.socket on:[NSString stringWithFormat:@"CheckinPickupDone%@", [DataManager user].email]
           callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nullable ack)
    {
        [self changeToNextState];
    }];
    
#endif
}


-(void)changeToToParkingState
{
    self.reservationState = ReservationStateToParking;
    
    [self.inCourseBottomView changeToToParkingState];
    [self.securityCodeView removeFromSuperview];
    [self.searchView removeFromSuperview];
    
    [self.mapView removeAnnotation:self.rdvAnnotation];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    
#ifdef DEBUG_WITH_TIMER
    // POUR LE TEST
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeToNextState];
    });
#endif
    
#ifdef DEBUG_WITH_SOCKET
    [self.socket on:[NSString stringWithFormat:@"CheckinParkedDone%@", [DataManager user].email]
           callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nullable ack)
     {
         [self changeToNextState];
     }];
#endif
}


-(void)changeToParkedState
{
    self.reservationState = ReservationStateParked;
    
    [self.inCourseBottomView removeFromSuperview];
    
    [self.view addSubview:self.homeBottomView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.locationPinView];
    
    [self.homeBottomView changeToNoException];
    [self.homeBottomView changeDescriptionTextsToParked];
    [self.homeBottomView changeBookButtonStateToAskForReturn];
    [self.homeBottomView layoutChangeToBookInfoClose];
}


-(void)changeToLoadingForGiveBackState
{
    self.reservationState = ReservationStateLoadingForGiveBack;
    ResearchPopupView *RPV = [[ResearchPopupView alloc] init];
    [RPV changeToSearchingStateWithMessage:NSLocalizedString(@"ResearchPopup-BotText-Searching", @"")];
    
    
    [DataManager checkOutWithLocation:[[Coords alloc] initWithCLLocation2D:self.currentPickUpLocation.coordinate]
                           completion:^(Order *order, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         if (httpResponse.statusCode != 200)
         {
             [HTTPResponseHandler handleHTTPResponse:httpResponse
                                         withMessage:@""
                                       forController:self
                                      withCompletion:^
              {
                  nil;
              }];
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [RPV changeToFoundState];
                            });
             
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                            {
                                [RPV dismiss];
                                [self changeToNextState];
                            });
         }
     }];
}


-(void)changeToWaitingForGiveBackState
{
    self.reservationState = ReservationStateWaitingForGiveBack;
    
    [self.view addSubview:self.inCourseBottomView];
    [self.view addSubview:self.securityCodeView];
    
    [self.homeBottomView removeFromSuperview];
    [self.locationPinView removeFromSuperview];
    
    
    NSString *checkinId = [DataManager order].checkOut._id;
    self.securityCodeView.codeLabel.text = [[checkinId substringFromIndex:checkinId.length - 4] uppercaseString];
    
    
    [ImageManager getImageFromUrlPath:[DataManager order].checkOut.valet.picture withCompletion:^(UIImage *image)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            self.inCourseBottomView.imageView.image = image;
                        });
     }];
    [self.inCourseBottomView setNameLabelText:[DataManager order].checkOut.valet.firstName];
    
    
    /**************************************/
    /***** ADD CURRENT RDV ANNOTATION *****/
    /**************************************/
    self.rdvAnnotation = [[RDVPinAnnotation alloc] init];
    self.rdvAnnotation.coordinate = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    [self.mapView addAnnotation:self.rdvAnnotation];
    
    
#ifdef DEBUG_WITH_TIMER
    // POUR LE TEST
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                   {
                       [self changeToNextState];
                   });
#endif
    
#ifdef DEBUG_WITH_SOCKET
    NSDictionary *checkinDictionary = @{@"check":@"Checkout",
                                        @"clientEmail":[DataManager user].email,
                                        @"clientFirstName":[DataManager order].client.firstName,
                                        @"clientLastName":[DataManager order].client.lastName,
                                        //                                        @"vehicleBrand":[DataManager order].vehicle.brand,
                                        //                                        @"vehicleModel":[DataManager order].vehicle.model,
                                        //                                        @"vehicleColor":[DataManager order].vehicle.color,
                                        ////                                        @"vehiclePlate":[DataManager order].vehicle.numberPlate,
                                        @"securityCode":self.securityCodeView.codeLabel.text,
                                        @"coordinates":@{@"latitude":[NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.latitude],
                                                         @"longitude":[NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.longitude]}};
    [self.socket emit:@"CheckoutPickup"
            withItems:@[[DataManager order].checkOut.valet.lastName,
                        checkinDictionary]];
    
    [self.socket on:[NSString stringWithFormat:@"CheckoutDone%@", [DataManager user].email]
           callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nullable ack)
     {
         [self changeToNextState];
     }];
#endif
}


-(void)changeToDisplayRatingsState
{
    self.reservationState = ReservationStateDisplayRatings;
    [self showFeedBackView];
}


-(void)changeToDoneState
{
    self.reservationState = ReservationStateDone;
    self.reservationState = -1;
    [self changeToNextState];
}


#pragma mark - Action handlers

/**
 *  @author François  Juteau, 15-09-14 06:09:22
 *
 *  @brief  Handle the localize button press
 *  @param sender localize button
 */
- (IBAction)handleLocalizeButton:(UIButton *)sender
{
    [self localizeUser];
}


- (IBAction)handleBookValet:(id)sender
{
    [self.homeBottomView handleBookValet];
    
//    [UIView animateWithDuration:0.5
//                     animations:^
//    {
//        [self.view layoutIfNeeded];
//    }];
}


-(IBAction)handleCallButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", [self getCurrentValetPhoneNumber]]]];
}


-(IBAction)handleSMSButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", [self getCurrentValetPhoneNumber]]]];
}


-(NSString *)getCurrentValetPhoneNumber
{
    if (self.reservationState == ReservationStateWaitingForPickup ||
        self.reservationState == ReservationStateToParking)  // Si on affiche le numéro du valet du checkin
    {
        return [DataManager order].checkIn.valet.cellPhone;
    }
    else if (self.reservationState == ReservationStateWaitingForGiveBack)
    {
        return [DataManager order].checkOut.valet.cellPhone;
    }
    return nil;
}


-(IBAction)handleCancelReservation:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Êtes vous sur de vouloir annuler votre réservation ?" message:@"Aucun frais ne vous sera prélevé" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dontCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-NO", nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
    
    UIAlertAction *confirmCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-ConfirmCancel", nil)
                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [DataManager deleteCurrentOrderWithcompletion:^(Order *order, NSHTTPURLResponse *httpResponse, NSError *error)
                             {
                                 if (httpResponse.statusCode != 200)
                                 {
                                     [HTTPResponseHandler handleHTTPResponse:httpResponse
                                                                 withMessage:@""
                                                               forController:self
                                                              withCompletion:^
                                      {
                                          nil;
                                      }];
                                 }
                             }];
                             [self changeToNoneState];
                         }];
    
    [alertController addAction:dontCancel];
    [alertController addAction:confirmCancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        [GAI sendScreenViewWithName:@"Ride - Cancel Checkin"];
    }];
}


-(IBAction)handleCancelInfo:(id)sender
{
    [self.homeBottomView exitBookValet];
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark - Update valet methods

-(void)changeValetLocation
{
    // Init de la request
    MKDirectionsRequest *dirRequest = [[MKDirectionsRequest alloc] init];
    dirRequest.transportType = MKDirectionsTransportTypeWalking;
    
    // Source
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:self.currentPickUpLocation.coordinate addressDictionary:nil];
    [dirRequest setSource:[[MKMapItem alloc] initWithPlacemark:sourcePlacemark]];
    
    
    // Pour toute les coordonnées des valets
    for (ValetFaker *item in self.valetsArray)
    {
        // Destination
        MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:[item getFakerCurrentLocation].location addressDictionary:nil];
        [dirRequest setDestination:[[MKMapItem alloc] initWithPlacemark:destinationPlacemark]];
        
        // Init de la directions avec la request du valet courant
        MKDirections *mkDirections = [[MKDirections alloc] initWithRequest:dirRequest];
        
        // Calcul du ETA
        [mkDirections calculateETAWithCompletionHandler:^(MKETAResponse * _Nullable response, NSError * _Nullable error)
         {
             CGFloat newETA = response.expectedTravelTime;
             
             if (self.valetsArray.firstObject == item || self.currentValet.ETA > newETA)
             {
                 self.currentValet = item;
                 self.currentValet.ETA = newETA;
             }
             if (self.valetsArray.lastObject == item)  // Quand on arrive à la fin du tableau
             {
                 
                 NSInteger etaInMinutes = self.currentValet.ETA / 60 / 2;
                 if (etaInMinutes < 1)  // Si l'ETA est inférieur à 1 minutes on affiche 1 minutes quand même
                 {
                     self.locationPinView.timeLabel.text = @"1";
                 }
                 else if (etaInMinutes > 30)  // Si on a plus de 30 minutes d'attente on affiche 30 minutes
                 {
                     self.locationPinView.timeLabel.text = @"30";
                 }
                 else
                 {
                     self.locationPinView.timeLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.currentValet.ETA / 60 / 2]];
                 }
             }
         }];
    }
}


#pragma mark - CLLocationManager Delegate methods

/**
 *  @author François  Juteau, 15-09-14 06:09:09
 *
 *  @brief  Display the user location when the localization is done
 *  @param manager   current location manager
 *  @param locations given locations
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * lastKownLocation = [locations lastObject];
    [manager stopUpdatingLocation];
    self.currentPickUpLocation = lastKownLocation;
    [self changeLocalizeButtonColor];
    
    [self displayWithLocation:lastKownLocation];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"ERROR LOC : %@", error.description);
}


#pragma mark - MKMapView delegate methods

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ((self.reservationState == ReservationStateNone || self.reservationState == ReservationStateParked) && !animated)
    {
        [self setAdressFromLocation:self.mapView.centerCoordinate];
        [self changeMapStateFromLocation:self.mapView.centerCoordinate];
        [self changeValetLocation];
    }
}



-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RDVPinAnnotation class]])
    {
        RDVPinAnnotationView *RDVPin = [[RDVPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        
        RDVPin.highlighted = NO;
        RDVPin.centerOffset = CGPointMake(0, - (RDVPin.frame.size.height / 2));
        return RDVPin;
    }
    
    if ([annotation isKindOfClass:[ValetAnnotation class]])
    {
        MKAnnotationView *valetPin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        valetPin.highlighted = NO;
        valetPin.image = [UIImage imageNamed:@"valet"];
        valetPin.centerOffset = CGPointMake(0, - (valetPin.image.size.height / 2));
        return valetPin;
    }
    
    // On retourne nil si on est pas dans
    return nil;
}



#pragma mark - SearchView Delegate methods

-(void)searchViewdidTextFieldTouch
{
    if (self.reservationState == ReservationStateNone || self.reservationState == ReservationStateParked )
    {
        AutocompletionTableViewController *autocompleteTVC = [[AutocompletionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:autocompleteTVC animated:YES];
    }
}


-(void)searchViewdidLocalizeButtonTouch
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [self localizeUser];
    }
}



#pragma mark - Home Bottom Slide View Delegate methods

-(void)displayReservationInfo
{
    if ([DataManager user].creditCards.count == 0)  // Si il n'y a pas de carte de crédit
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Home-AlertView-Title-NoCards", @"") message:NSLocalizedString(@"Home-AlertView-Description-NoCards", @"") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *notNow = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-NotNow", nil)
                                                     style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * action)
        {
            [self changeToNoneState];
       }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
        {
            AddPaymentTableViewController *addPaymentViewController = [[AddPaymentTableViewController alloc] init];
            addPaymentViewController.delegate = self;
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addPaymentViewController];
            [self.navigationController presentViewController:navController animated:YES completion:nil];
         }];
        
        [alertController addAction:notNow];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(handleCancelInfo:)];
    cancelItem.tintColor = [UIColor louisMainColor];
    self.navigationItem.rightBarButtonItem = cancelItem;
}


-(void)confirmBooking
{
    [self changeToNextState];
}


-(void)askForReturn
{
    [self changeToNextState];
}


#pragma mark - Location Pin Delegate methods

-(void)replacepinToCenterZone
{
    [self.mapView setCenterCoordinate:self.zoneCenter.coordinate animated:YES];
    [self setAdressFromLocation:self.zoneCenter.coordinate];
    
    // Changements en zone
    [self.homeBottomView changeToNoException];
    self.isLastLocationInZone = YES;
    [self.locationPinView changeToInZoneContent];
    [self changeValetLocation];
}


#pragma mark - Security Code View Delegate methods

-(void)displaySecurityCodePopup
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Code de sécurité" message:@"Par mesure de sécurité, vous devez demander le code de sécurité au voiturier et vérifier qu'il correspond à celui ci avant de lui laisser votre véhicule." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                 style:UIAlertActionStyleCancel
                                               handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:
     ^{
        [GAI sendScreenViewWithName:@"Ride - Security Code"];
    }];
}


#pragma mark - Add Payment TVC Delegate methods

-(void)didCardAddedSuccefully
{
    [self.homeBottomView.bookInfoTableViewController reloadData];
}


-(void)didCancelAdding
{
    [self.homeBottomView exitBookValet];
}

@end
