//
//  DataManager+User_Cards.h
//  Louis
//
//  Created by François Juteau on 14/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//
#import "DataManager+User.h"


@interface DataManager (User_Cards)

#pragma mark - AJOUTS

+(void)addCreditCard:(STPToken *)token withCompletionBlock:(dataPostCompletion)completionBlock;
+(void)deleteCard:(STPCard *)card withCompletionBlock:(dataPostCompletion)compblock;

#pragma mark - GETTERS

+(NSArray *)userCreditCards;

@end
