//
//  OrderState.h
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderState : NSObject

@property (nonatomic, strong) NSArray *states;
@property (nonatomic) NSInteger currentState;


/*******************/
/***** METHODS *****/
/*******************/

+(instancetype)sharedInstance;
+(NSInteger)setAndGetCurrentStateFromString:(NSString *)stringState;
+(NSString *)getStringValueOfCurrentState;

@end
