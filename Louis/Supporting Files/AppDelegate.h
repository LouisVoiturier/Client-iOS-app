//
//  AppDelegate.h
//  Louis
//
//  Created by Thibault Le Cornec on 24/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

