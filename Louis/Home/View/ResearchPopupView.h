//
//  ResearchPopupView.h
//  Louis
//
//  Created by François Juteau on 15/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResearchPopupView : UIView

/**********************/
/***** PROPERTIES *****/
/**********************/

@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) UIImageView *activityIndicator;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *topTextLabel;
@property (nonatomic, strong) UILabel *botTextLabel;


/*******************/
/***** METHODS *****/
/*******************/

#pragma mark - State changing methods

- (void)changeToSearchingStateWithMessage:(NSString *)message;
- (void)changeToFoundState;
- (void)changeToNotFoundState;
- (void)dismiss;

@end
