//
//  ProfilePictureViewWithButton.h
//  Louis
//
//  Created by Giang Christian on 09/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePictureViewWithButton : UIView

@property (nonatomic) UIButton *firstButton;
//@property (nonatomic) UIButton *secondButton;
@property (nonatomic) UIImageView *imageView;

- (instancetype)initWithFrameAndBottomButton:(CGRect)frame;

@end
