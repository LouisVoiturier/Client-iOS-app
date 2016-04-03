//
//  GAI+PostScreenView.h
//  Louis
//
//  Created by Thibault Le Cornec on 30/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>

@interface GAI (Helpers)

+ (void)sendScreenViewWithName:(NSString *)screenName;
+ (void)sendEvent:(GAIDictionaryBuilder *)event;

@end
