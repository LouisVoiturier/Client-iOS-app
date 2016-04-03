//
//  OrderState.m
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "OrderState.h"

@implementation OrderState

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _states = @[@"Ordered",
                    @"Canceled",
                    @"CheckinInProgress",
                    @"ParkInProgress",
                    @"Parked",
                    @"CheckoutInProgress",
                    @"CheckedOut",
                    @"Payed"];
    }
    return self;
}

+(NSInteger)setAndGetCurrentStateFromString:(NSString *)stringState
{
    return [OrderState sharedInstance].currentState = [[OrderState sharedInstance].states indexOfObject:stringState];
}

+(NSString *)getStringValueOfCurrentState
{
    return [[OrderState sharedInstance].states objectAtIndex:[OrderState sharedInstance].currentState];
}


@end
