//
//  FooterButtonView.m
//  Louis
//
//  Created by François Juteau on 29/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "BigButtonView.h"

@interface BigButtonView ()
{
    int paddingInt;
}
@end


@implementation BigButtonView


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        paddingInt = 30; // Padding between table view and button.
    }
    
    return self;
}



+ (instancetype)bigButtonViewTypeMainWithTitle:(NSString *)title
{
    BigButtonView *bigButtonView = [[BigButtonView alloc] init];
    
    if (bigButtonView)
    {
        bigButtonView->_button = [BigButton bigButtonTypeMainWithTitle:title];
        [bigButtonView setupBigButtonView];
    }
    
    return bigButtonView;
}



+ (instancetype)bigButtonViewTypeAltWithTitle:(NSString *)title andImage:(UIImage *)image
{
    BigButtonView *bigButtonView = [[BigButtonView alloc] init];
    
    if (bigButtonView)
    {
        // ----- Button ----- //
        bigButtonView->_button = [BigButton bigButtonTypeAltWithTitle:title andImage:image];
        [bigButtonView setupBigButtonView];
    }
    
    return bigButtonView;
}



- (void)setupBigButtonView
{
    [self addSubview:self.button];
    
    // ----- Constraints ----- //
    NSNumber *footerWidth = [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width];
    NSNumber *padding = [NSNumber numberWithInt:paddingInt];
    NSNumber *buttonWidth = [NSNumber numberWithFloat:[footerWidth floatValue] * self.button.widthRate];
    NSNumber *buttonHeight = [NSNumber numberWithFloat:self.button.heightPoints];

    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_button);
    NSDictionary *metricsDict = NSDictionaryOfVariableBindings(padding, buttonWidth, buttonHeight);

    [self setFrame:CGRectMake(0, 0, [footerWidth floatValue], ([padding intValue]+[buttonHeight intValue]+[padding intValue]))];

    [self addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[_button(==buttonHeight)]-(>=padding)-|"
                                                                  options:0
                                                                  metrics:metricsDict
                                                                    views:viewsDict]];
    [self addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_button(==buttonWidth)]"
                                                                  options:0
                                                                  metrics:metricsDict
                                                                    views:viewsDict]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self->_button
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
}
@end
