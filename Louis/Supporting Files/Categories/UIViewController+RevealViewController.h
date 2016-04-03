//
//  UIViewController+RevealViewController.h
//  Louis
//
//  Created by Thibault Le Cornec on 14/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface UIViewController (RevealViewController)

- (void)configureSWRevealViewControllerForViewController:(UIViewController *)viewController
                                          withMenuButton:(UIBarButtonItem *)menuButton;

@end
