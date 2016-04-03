//
//  HomeViewController.h
//  Louis
//
//  Created by François Juteau on 14/09/2015.
//  Copyright (c) 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class FeedBackView;

@interface HomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property NSString *titre;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) FeedBackView *feedBackView;


-(void)changeLocalizationWithAdress:(NSString *)adress;
-(void)changeToNextState;

@end
