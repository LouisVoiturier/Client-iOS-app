//
//  FooterButtonView.h
//  Louis
//
//  Created by François Juteau on 29/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BigButton.h"

@interface BigButtonView : UIView

@property (nonatomic, strong, readonly) BigButton *button;

/**
 *  @author Thibault Le Cornec
 *
 *  Create and return a BigButtonView with a BigButton of type Main inside.
 *
 *  @param title The button title.
 *
 *  @return The BigButtonView created.
 */
+ (instancetype)bigButtonViewTypeMainWithTitle:(NSString *)title;


/**
 *  @author Thibault Le Cornec
 *
 *  Create and return a BigButtonView with a BigButton of type Alt inside.
 *
 *  @param title The button title.
 *  @param image The image for the BigButton. Image is on the left of the BigButton's title.
 *
 *  @return The BigButtonView created.
 */
+ (instancetype)bigButtonViewTypeAltWithTitle:(NSString *)title
                                     andImage:(UIImage *)image;

@end
