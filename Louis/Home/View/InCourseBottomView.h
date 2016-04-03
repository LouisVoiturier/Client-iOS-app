//
//  InCourseBottomView.h
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseTimeLeftView.h"

@interface InCourseBottomView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) CourseTimeLeftView *courseTimeLeftView;

@property (nonatomic, strong) UIButton *callButton;

@property (nonatomic, strong) UIButton *smsButton;


#pragma mark - Setters

-(void)setNameLabelText:(NSString *)name;

-(void)showTime;

-(void)hideTime;

-(void)changeToToParkingState;


@end
