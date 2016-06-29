//
//  GAI+PostScreenView.m
//  Louis
//
//  Created by Thibault Le Cornec on 30/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "GAI+Helpers.h"

@implementation GAI (Helpers)

+(void)sendScreenViewWithName:(NSString *)screenName
{
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}


+ (void)sendEvent:(GAIDictionaryBuilder *)event
{
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[event build]];
#endif
}

@end
