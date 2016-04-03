//
//  ProfilePictureView.h
//  Louis
//
//  Created by François Juteau on 01/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePictureView : UIView

@property (nonatomic) UILabel *firstnameLabel;
@property (nonatomic) UILabel *lastnameLabel;

@property (nonatomic) UILabel *addCardTitleLabel;
@property (nonatomic) UILabel *addCardMsgLabel;
@property (nonatomic) UILabel *wellcomeMsgLabel;

@property (nonatomic) UIImageView *imageView;

- (instancetype)initWithFrameAndLabelsOnTheLeftAndBottom:(CGRect)frame;

@end
