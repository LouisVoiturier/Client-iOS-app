//
//  UIViewController+RevealViewController.m
//  Louis
//
//  Created by Thibault Le Cornec on 14/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "UIViewController+RevealViewController.h"

@implementation UIViewController (RevealViewController)

- (void)configureSWRevealViewControllerForViewController:(UIViewController *)viewController
                                          withMenuButton:(UIBarButtonItem *)menuButton
{
    [[viewController view] addGestureRecognizer:[[viewController revealViewController] panGestureRecognizer]];
    [[viewController revealViewController] setSpringDampingRatio:0.8];
    [[viewController revealViewController] setToggleAnimationDuration:0.3];
    [[viewController revealViewController] setToggleAnimationType:SWRevealToggleAnimationTypeEaseOut];
    
    [menuButton setTarget:[viewController revealViewController]];
    [menuButton setTintColor:[UIColor blackColor]];
    [menuButton setAction:@selector(revealToggle:)];
}

@end
