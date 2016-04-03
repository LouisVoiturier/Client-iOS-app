//
//  HomeBottomSlideView.m
//  Louis
//
//  Created by François Juteau on 15/09/2015.
//  Copyright (c) 2015 Louis. All rights reserved.
//

#import "HomeBottomSlideView.h"
#import "Common.h"

typedef NS_ENUM(NSUInteger, BookButtonState)
{
    BookButtonStateBook,
    BookButtonStateConfirm,
    BookButtonStateSubmitPicker,
    BookButtonStateAskForReturn
};

@interface HomeBottomSlideView ()


@property (nonatomic) UIView *buttonBGView;

/***********************/
/***** CONSTRAINTS *****/
/***********************/
@property (nonatomic) NSArray *constraintsBookInfoOpen;
@property (nonatomic) NSArray *constraintsBookInfoClose;
@property (nonatomic) NSArray *constraintsOffHour;

/******************/
/***** FRAMES *****/
/******************/
@property (nonatomic) CGRect frameBookInfoOpen;
@property (nonatomic) CGRect frameBookInfoClose;
@property (nonatomic) CGRect frameOffHour;


@property (nonatomic) NSInteger currentBookButtonState;

@end

@implementation HomeBottomSlideView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        /**************************/
        /***** BUTTON BG VIEW *****/
        /**************************/
        _buttonBGView = [[UIView alloc] init];
        _buttonBGView.backgroundColor = [UIColor louisMainColor];
        
        [_buttonBGView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_buttonBGView];
        
        
        /***********************/
        /***** BOOK BUTTON *****/
        /***********************/
        _bookButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _bookButton.tintColor = [UIColor whiteColor];
        _bookButton.titleLabel.font = [UIFont buttonMainFont];
        [self changeBookButtonStateToBook];
        
        [_bookButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_buttonBGView addSubview:_bookButton];
        
        
        /**************************/
        /***** OFF HOUR LABEL *****/
        /**************************/
        _offHourLabel = [[UILabel alloc] init];
        _offHourLabel.font = [UIFont louisLabelFont];
        _offHourLabel.textColor = [UIColor louisLabelColor];
        _offHourLabel.textAlignment = NSTextAlignmentCenter;
        
        [_offHourLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_buttonBGView addSubview:_offHourLabel];
        
        
        /**********************************/
        /***** DESCRIPTIONBUTTON VIEW *****/
        /**********************************/
        _descriptionBottomView = [[DescriptionBottomView alloc] init];
        _descriptionBottomView.backgroundColor = [UIColor whiteColor];
        
        [_descriptionBottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_descriptionBottomView];
        
        
        /************************/
        /***** BOOKINFO TVC *****/
        /************************/
        _bookInfoTableViewController = [[BookInfoTableViewController alloc] init];
        _bookInfoTableView = _bookInfoTableViewController.tableView;
        _bookInfoTableView.alpha = 0;
        
        [_bookInfoTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_bookInfoTableView];
        
        
        /*******************************************/
        /***** CONSTRAINTS AND FRAMES SETTINGS *****/
        /*******************************************/
        [self setAllUIStuff];
        
        
        // Par défault, on commence en Close
        self.frame = _frameBookInfoClose;
        [self addConstraints:_constraintsBookInfoClose];
        
        
        /*******************************/
        /***** NOTIFICATION CENTER *****/
        /*******************************/
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeBookButtonStateToSubmit)
                                                     name:@"BookButtonStateChange"
                                                   object:nil];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.descriptionBottomView addInitialConstraints];
}


#pragma mark - Layout changing methods

-(void)layoutChangeToOffHourWithMessage:(NSString *)message
{
    [self removeConstraints:self.constraints];
    self.offHourLabel.text = message;
    
    self.buttonBGView.backgroundColor = [UIColor whiteColor];
    
    self.frame = _frameOffHour;
    [self addConstraints:_constraintsOffHour];
}

-(void)layoutChangeToBookInfoClose
{
    [self removeConstraints:self.constraints];
    self.bookInfoTableView.alpha = 0;
    
    self.frame = _frameBookInfoClose;
    [self addConstraints:_constraintsBookInfoClose];
}

-(void)layoutChangeToBookInfoOpen
{
    [self removeConstraints:self.constraints];
    self.bookInfoTableView.alpha = 1;
    
    self.frame = _frameBookInfoOpen;
    [self addConstraints:_constraintsBookInfoOpen];
}


#pragma mark - Action handlers

-(BOOL)handleBookValet
{
    BOOL isBookingConfirmed = NO;
    
    switch (self.currentBookButtonState)
    {
        case BookButtonStateBook:
            [self layoutChangeToBookInfoOpen];
            [self changeBookButtonStateToConfirm];
            [self.delegate displayReservationInfo];
            [self layoutIfNeeded];
            break;
            
        case BookButtonStateConfirm:
            [self.delegate confirmBooking];
            [self changeBookButtonStateToBook];
            break;
            
        case BookButtonStateSubmitPicker:
            self.bookInfoTableViewController.pickerView.hidden = YES;
            [self.bookInfoTableViewController changeCurrentSelectedRowValueToPickerValue];
            [self changeBookButtonStateToConfirm];
            break;
            
        case BookButtonStateAskForReturn:
            [self.delegate askForReturn];
            break;
        default:
            break;
    }
    return isBookingConfirmed;
}

-(void)exitBookValet
{
    self.bookInfoTableViewController.pickerView.hidden = YES;
    [self changeDescriptionTextsToBook];
    [self changeBookButtonStateToBook];
    [self layoutChangeToBookInfoClose];
}


#pragma mark - Change global state methods

-(void)changeToExceptionOffZone
{
    [self changeBookButtonStateToBook];
    [self.descriptionBottomView changeHiddenStateForExceptionView:NO];
    self.bookButton.enabled = NO;
}

-(void)changeToExceptionOffHours
{
    
}

-(void)changeToNoException
{
    [self changeBookButtonStateToBook];
    [self.descriptionBottomView changeHiddenStateForExceptionView:YES];
    self.bookButton.enabled = YES;
}


#pragma mark - Change button state methods

-(void)changeBookButtonStateToBook
{
    [_bookButton setTitle:NSLocalizedString(@"Home-BookButton-Book", nil) forState:UIControlStateNormal];
    self.currentBookButtonState = BookButtonStateBook;
}

-(void)changeBookButtonStateToConfirm
{
    [_bookButton setTitle:NSLocalizedString(@"Home-BookButton-Confirm", nil) forState:UIControlStateNormal];
    self.currentBookButtonState = BookButtonStateConfirm;
}

-(void)changeBookButtonStateToAskForReturn
{
    [_bookButton setTitle:NSLocalizedString(@"Home-BookButton-AskForReturn", nil) forState:UIControlStateNormal];
    self.currentBookButtonState = BookButtonStateAskForReturn;
}


#pragma mark - Change texts methods

-(void)changeDescriptionTextsToBook
{
    [self.descriptionBottomView changeToBookTextState];
}

-(void)changeDescriptionTextsToParked
{
    [self.descriptionBottomView changeToParkedTextState];
}


#pragma mark - Notification center methods

-(void)changeBookButtonStateToSubmit
{
    [_bookButton setTitle:NSLocalizedString(@"Home-BookButton-SubmitPicker", nil) forState:UIControlStateNormal];
    self.currentBookButtonState = BookButtonStateSubmitPicker;
}


#pragma mark - UI methods


-(void)setAllUIStuff
{
    /***************************/
    /***** COMON VARIABLES *****/
    /***************************/
    CGFloat superviewWidth = self.frame.size.width;
    CGFloat superviewHeight = self.frame.size.height;
    
    CGFloat originY = self.frame.origin.y;
    
    CGFloat buttonViewHeightF = 44;
    CGFloat descriptionHeightF = 44;
    
    CGFloat bookInfoTVCCloseHeightF = 44;
    CGFloat bookInfoSectionHeightF = 24;
    CGFloat bookInfoTVCOpenHeightF = (bookInfoTVCCloseHeightF * 3) + bookInfoSectionHeightF;
    
    /**************************/
    /***** FRAME OFF HOUR *****/
    /**************************/
    CGFloat startOffHourY = originY;
    
    _frameOffHour = CGRectMake(0, startOffHourY, superviewWidth, buttonViewHeightF);
    
    /***********************/
    /***** FRAME CLOSE *****/
    /***********************/
    CGFloat bookInfoCloseViewHeight = buttonViewHeightF + descriptionHeightF;
    CGFloat startBookInfoCloseY = originY - descriptionHeightF;
    
    _frameBookInfoClose = CGRectMake(0, startBookInfoCloseY, superviewWidth, bookInfoCloseViewHeight);
    
    /***********************/
    /***** FRAME OPEN ******/
    /***********************/
    CGFloat bookInfoOpenViewHeight = buttonViewHeightF + bookInfoTVCOpenHeightF;
    CGFloat startBookInfoOpenY = originY - bookInfoTVCOpenHeightF;
    
    _frameBookInfoOpen = CGRectMake(0, startBookInfoOpenY, superviewWidth, bookInfoOpenViewHeight);
    
    
    /***********************/
    /***** CONSTRAINTS *****/
    /***********************/
    
    NSNumber *viewWidth = [NSNumber numberWithFloat:superviewWidth];
    NSNumber *viewHeight = [NSNumber numberWithFloat:superviewHeight];
    
    NSNumber *buttonViewHeight = [NSNumber numberWithInteger:buttonViewHeightF];
    NSNumber *offHourXSpacing = [NSNumber numberWithInteger:superviewWidth * 0.1];
    NSNumber *offHourYSpacing = [NSNumber numberWithInteger:superviewHeight * 0.1];
    
    NSNumber *descriptionHeight = [NSNumber numberWithInteger:descriptionHeightF];
    NSNumber *bookInfoCloseHeight = [NSNumber numberWithInteger:bookInfoTVCCloseHeightF];
    NSNumber *bookInfoOpenHeight = [NSNumber numberWithInteger:bookInfoTVCOpenHeightF];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_buttonBGView, _bookButton, _offHourLabel, _descriptionBottomView, _bookInfoTableView);
    NSDictionary *metrics = NSDictionaryOfVariableBindings(viewWidth, viewHeight, buttonViewHeight, offHourXSpacing, offHourYSpacing, descriptionHeight, bookInfoCloseHeight, bookInfoOpenHeight);
    
    
    /******************************/
    /***** COMMON CONSTRAINTS *****/
    /******************************/

    // Horizontale de buttonView
    NSArray *hButtonBGViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonBGView]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views];
    
    // Horizontale de bookButton
    NSArray *hBookButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bookButton]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views];
    
    // Horizontale de description
    NSArray *hDescriptionBottomViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionBottomView]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views];
    
    // Horizontale de la tableview
    NSArray *hBookInfoTableViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bookInfoTableView]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views];
    
    // Verticale de bookButton
    NSArray *vBookButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bookButton]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views];
    
    // Verticale de description et buttonView
    NSArray *vDescriptionAndButtonBGViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_descriptionBottomView(descriptionHeight)][_buttonBGView(buttonViewHeight)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views];
    
    
    /********************************/
    /***** OFF HOUR CONSTRAINTS *****/
    /********************************/
    
    // Horizontale de offHourLabel
    NSArray *hOffHourLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offHourXSpacing)-[_offHourLabel]-(offHourXSpacing)-|"
                                                                                options:0
                                                                                metrics:metrics
                                                                                  views:views];
    
    // Verticale de offHourLabel
    NSArray *vOffHourLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offHourYSpacing)-[_offHourLabel]-(offHourYSpacing)-|"
                                                                                options:0
                                                                                metrics:metrics
                                                                                  views:views];
    
    // Verticale de offHourLabel
    NSArray *vButtonBGViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonBGView]|"
                                                                                options:0
                                                                                metrics:metrics
                                                                                  views:views];
    
    
    /***********************************************/
    /***** BOOK INFON CLOSE & OPEN CONSTRAINTS *****/
    /***********************************************/

    
    // Verticale de bookButton fermé
    NSArray *vBookInfoCloseConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bookInfoTableView(bookInfoCloseHeight)][_buttonBGView]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views];
    
    // Verticale de bookButton ouvert
    NSArray *vBookInfoOpenConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bookInfoTableView(bookInfoOpenHeight)][_buttonBGView]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views];
    
    
    /*********************************************/
    /***** GLOBAL CONSTRAINTS BOOK INFO OPEN *****/
    /*********************************************/
    
    NSMutableArray *mutableConstraintBookInfoOpen = [NSMutableArray arrayWithArray:hButtonBGViewConstraints];  // Horizontales
    [mutableConstraintBookInfoOpen addObjectsFromArray:hBookButtonConstraints];
    [mutableConstraintBookInfoOpen addObjectsFromArray:hDescriptionBottomViewConstraints];
    [mutableConstraintBookInfoOpen addObjectsFromArray:hBookInfoTableViewConstraints];
    
    [mutableConstraintBookInfoOpen addObjectsFromArray:vBookButtonConstraints];  // Verticales
    [mutableConstraintBookInfoOpen addObjectsFromArray:vDescriptionAndButtonBGViewConstraints];
    
    [mutableConstraintBookInfoOpen addObjectsFromArray:vBookInfoOpenConstraints];  // Unique pour l'open
    
    
    _constraintsBookInfoOpen = [mutableConstraintBookInfoOpen copy];
    
    
    /**********************************************/
    /***** GLOBAL CONSTRAINTS BOOK INFO CLOSE *****/
    /**********************************************/
    
    NSMutableArray *mutableConstraintBookInfoClose = [NSMutableArray arrayWithArray:hButtonBGViewConstraints];  // Horizontales
    [mutableConstraintBookInfoClose addObjectsFromArray:hBookButtonConstraints];
    [mutableConstraintBookInfoClose addObjectsFromArray:hDescriptionBottomViewConstraints];
    [mutableConstraintBookInfoClose addObjectsFromArray:hBookInfoTableViewConstraints];
    
    [mutableConstraintBookInfoClose addObjectsFromArray:vBookButtonConstraints];  // Verticales
    [mutableConstraintBookInfoClose addObjectsFromArray:vDescriptionAndButtonBGViewConstraints];
    
    [mutableConstraintBookInfoClose addObjectsFromArray:vBookInfoCloseConstraints];  // Unique pour le close
    
    
    _constraintsBookInfoClose = [mutableConstraintBookInfoClose copy];
    
    
    /***************************************/
    /***** GLOBAL CONSTRAINTS OFF HOUR *****/
    /***************************************/
    
    NSMutableArray *mutableConstraintOffHour = [NSMutableArray arrayWithArray:hButtonBGViewConstraints];  // Horizontales
    [mutableConstraintOffHour addObjectsFromArray:hOffHourLabelConstraints];
    
    [mutableConstraintOffHour addObjectsFromArray:vOffHourLabelConstraints];  // Verticales
    [mutableConstraintOffHour addObjectsFromArray:vButtonBGViewConstraints];
    
    
    _constraintsOffHour = [mutableConstraintOffHour copy];
    
}



@end
