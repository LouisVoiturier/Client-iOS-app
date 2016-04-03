//
//  LouisButton.m
//  Louis
//
//  Created by Thibault Le Cornec on 01/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "BigButton.h"
#import "UIColor+Louis.h"
#import "UIFont+Louis.h"


typedef NS_ENUM(NSUInteger, BigButtonType)
{
    BigButtonTypeMain,
    BigButtonTypeAlt,
};


@interface BigButton ()
{
    NSUInteger type;
}
@end


@implementation BigButton


- (void)setDefaultValues
{
    [[self layer] setCornerRadius:5];
    _widthRate = 0.84;
    _heightPoints = 45;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}



+ (instancetype)baseBigButtonWithType:(UIButtonType)buttonType
{
    BigButton *button = [BigButton buttonWithType:buttonType];
    
    if (button)
    {
        [button setDefaultValues];
    }
    
    return button;
}



+ (instancetype)bigButtonTypeMainWithTitle:(NSString *)title
{
    BigButton *button = [BigButton baseBigButtonWithType:UIButtonTypeSystem];
    button->type = BigButtonTypeMain;
    
    if (button)
    {
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor buttonMainEnabledBackgroundColor]];
        [button addTarget:button action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:button action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:button action:@selector(buttonDragOutSide:) forControlEvents:UIControlEventTouchDragOutside];
        [button setTintColor:[UIColor buttonMainTintColor]];
        [[button titleLabel] setFont:[UIFont buttonMainFont]];
    }
    
    return button;
}



+ (instancetype)bigButtonTypeAltWithTitle:(NSString *)title andImage:(UIImage *)image
{
    BigButton *button = [BigButton baseBigButtonWithType:UIButtonTypeSystem];
    button->type = BigButtonTypeAlt;
    
    if (button)
    {
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor buttonAltBackgroundColor]];
        [button setTintColor:[UIColor buttonAltTintColor]];

        
        [[button layer] setBorderWidth:1.f];
        [[button layer] setBorderColor:[[UIColor buttonAltBorderColor] CGColor]];
        [[button titleLabel] setFont:[UIFont buttonAltFont]];
        
        if (image)
        {
            [[button imageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            UIImageView *buttonImageView = [[UIImageView alloc] initWithImage:image];
            [buttonImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [button addSubview:buttonImageView];
            
            [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-11-[buttonImageView(==22)]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"buttonImageView":buttonImageView}]];
    
            [button addConstraint:[NSLayoutConstraint constraintWithItem:buttonImageView
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:button
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0]];
        }

    }
    
    return button;
}



- (void)setEnableAutoLayout:(BOOL)useAutoLayout
{
    [self setTranslatesAutoresizingMaskIntoConstraints:useAutoLayout];
}



// ===== Color Button Management ===== //
- (void)buttonTouchDown:(UIControlEvents *)event
{
    [self setBackgroundColor:[UIColor buttonMainSelectedBackgroundColor]];
}


- (void)buttonTouchUpInside:(UIControlEvents *)event
{
    [self setBackgroundColor:[UIColor buttonMainEnabledBackgroundColor]];
}


- (void)buttonDragOutSide:(UIControlEvents *)event
{
    [self setBackgroundColor:[UIColor buttonMainEnabledBackgroundColor]];
}


// Override super method to change background color for the main button when they're disable
- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    // Change color for main button when it is disabled
    if (enabled == NO && self->type == BigButtonTypeMain)
    {
        [self setBackgroundColor:[UIColor buttonMainDisabledBackgroundColor]];
    }
    else if (enabled == YES && self->type == BigButtonTypeMain)
    {
        [self setBackgroundColor:[UIColor buttonMainEnabledBackgroundColor]];
    }
}


@end
