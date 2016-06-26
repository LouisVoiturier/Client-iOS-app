//
//  HomeViewController+FeedBackView.m
//  Louis
//
//  Created by Thibault Le Cornec on 21/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "HomeViewController+FeedBack.h"
#import "DataManager+Order.h"
#import "Valet.h"
#import "FeedBackView.h"
#import "CommentView.h"
#import "STPCard+Helper.h"


@implementation HomeViewController (FeedBack)

- (void)showFeedBackView
{
    // Get current Order and get each necessary information.
    Order *currentOrder = [DataManager order];
    
    // Date Management
    //
    NSDate *orderDate = [[currentOrder checkIn] date];
    NSString *orderDateString = [NSDateFormatter localizedStringFromDate:orderDate
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterMediumStyle];
//    Date should be format in same language as the one used by the app.
//    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatFromTemplate: options: locale:]
    
    
    // Price
    //
    NSString *priceString = [NSString stringWithFormat:@"%.2f", [[[currentOrder price] value] floatValue]];
    
    
    // Code promo
    // If a code promo was used to pay all or part of the order, information about value should be in order or in price.
    
    
    // Card Name
    //
    NSString *cardResume = [[currentOrder card] infosResume];
    NSString *cardName = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"FeedBackView-Price-SubTitle", nil), [[currentOrder card] name], cardResume];
    
    
    // Valets
    //
    Valet *checkinValet = [[currentOrder checkIn] valet];
    NSString *checkinValetEmail = [checkinValet email];
    Valet *checkoutValet = [[currentOrder checkOut] valet];
    NSString *checkoutValetEmail = [checkoutValet email];
    
    if ([checkinValetEmail isEqualToString:checkoutValetEmail])
    {
        [self setFeedBackView:[[FeedBackView alloc] initWithDate:orderDateString andPrice:priceString andCardName:cardName andCredit:nil andFirstValet:[checkinValet firstName] andSecondValet:nil andDelegate:self]];
    }
    else
    {
        [self setFeedBackView:[[FeedBackView alloc] initWithDate:orderDateString andPrice:priceString andCardName:cardName andCredit:nil andFirstValet:[checkinValet firstName] andSecondValet:[checkoutValet firstName] andDelegate:self]];
    }
    
    [[self feedBackView] show];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{

}


-(void)userValidatedFeedBack
{
    [self changeToNextState];
}


- (void)showCommentView
{
    CommentView *commentView = [[CommentView alloc] init];
    
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
    [commentView setFrame:CGRectMake(0, mainScreenFrame.size.height, mainScreenFrame.size.width, mainScreenFrame.size.height)];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:[self feedBackView]];
    [UIView animateWithDuration:0.5 animations:
     ^{
         [commentView setFrame:mainScreenFrame];
         [commentView setAlpha:1.0];
     }];
    
//    [commentView setTitle:[NSLocalizedString(@"FeedBackView-CommentView-Title", nil) uppercaseString]];

//    [[commentView navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Vehicle-Setup-View-RightBarButton-Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelComment)]];

//    [[commentView navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Vehicle-Setup-View-RightBarButton-Add", nil) style:UIBarButtonItemStylePlain target:self action:@selector(validateComment)]];
}


- (void)cancelComment
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}


- (void)validateComment
{
    
}


@end
