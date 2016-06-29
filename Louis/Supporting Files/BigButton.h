//
//  LouisButton.h
//  Louis
//
//  Created by Thibault Le Cornec on 01/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigButton : UIButton

@property (readonly, nonatomic) CGFloat widthRate;
@property (readonly, nonatomic) CGFloat heightPoints;

/**
 *  @author Thibault Le Cornec
 *
 *  Create and return a big button.
 *
 *  @param title The button title.
 *
 *  @return The big button created.
 */
+ (instancetype)bigButtonTypeMainWithTitle:(NSString *)title;


/**
 *  @author Thibault Le Cornec
 *
 *  Create and return a big button.
 *
 *  @param title The button title.
 *  @param image Image to place in the button (on the left)
 *
 *  @return The big button created.
 */
+ (instancetype)bigButtonTypeAltWithTitle:(NSString *)title
                                 andImage:(UIImage *)image;


/**
 *  @author Thibault Le Cornec
 *
 *  Allow to define use of NSLayoutContraints to place button in its view.
 *  Affect the setTranslatesAutoresizingMaskIntoConstraints property.
 *
 *  @param useAutoLayout Boolean value to indicate if the button will be place in its view with NSLayoutConstraints.
 */
- (void)setEnableAutoLayout:(BOOL)useAutoLayout;

@end
