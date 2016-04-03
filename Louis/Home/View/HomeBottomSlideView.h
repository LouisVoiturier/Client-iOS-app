//
//  HomeBottomSlideView.h
//  Louis
//
//  Created by François Juteau on 15/09/2015.
//  Copyright (c) 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DescriptionBottomView.h"
#import "BookInfoTableViewController.h"


@protocol HomeBottomSlideDelegate <NSObject>

-(void)displayReservationInfo;

-(void)confirmBooking;

-(void)askForReturn;

@end



@interface HomeBottomSlideView : UIView

@property (strong, nonatomic) IBOutlet UIButton *bookButton;

@property (nonatomic, strong) UILabel *offHourLabel;

@property (nonatomic, strong) DescriptionBottomView *descriptionBottomView;
@property (nonatomic, strong) BookInfoTableViewController *bookInfoTableViewController;
@property (nonatomic, strong) UITableView *bookInfoTableView;

@property (nonatomic, strong) id<HomeBottomSlideDelegate> delegate;


#pragma mark - Action handlers

-(BOOL)handleBookValet;

-(void)exitBookValet;


#pragma mark - Layout changing methods

-(void)layoutChangeToOffHourWithMessage:(NSString *)message;

-(void)layoutChangeToBookInfoClose;

-(void)layoutChangeToBookInfoOpen;


#pragma mark - Change global state methods

-(void)changeToExceptionOffZone;

-(void)changeToExceptionOffHours;

-(void)changeToNoException;


#pragma mark - Change button state methods

-(void)changeBookButtonStateToBook;

-(void)changeBookButtonStateToConfirm;

-(void)changeBookButtonStateToAskForReturn;


#pragma mark - Change texts methods

-(void)changeDescriptionTextsToBook;

-(void)changeDescriptionTextsToParked;


@end
