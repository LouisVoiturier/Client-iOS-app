//
//  DataManager+User_Cards.m
//  Louis
//
//  Created by François Juteau on 14/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager+User_Cards.h"
#import "STPCard+Helper.h"

@implementation DataManager (User_Cards)

#pragma mark - AJOUTS

+(void)addCreditCard:(STPToken *)token withCompletionBlock:(dataPostCompletion)completionBlock
{
    NSError *error;
    NSDictionary *tokenDic = @{@"stripeToken":token.tokenId};
    NSData *cardData = [NSJSONSerialization dataWithJSONObject:tokenDic options:-1 error:&error];
    
    [DataManager postData:cardData toCurrentUserForKey:@"creditcard" withCompletionBlock:completionBlock];
}


+(void)deleteCard:(STPCard *)card withCompletionBlock:(dataPostCompletion)compblock
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[card toDictionary]  options:-1 error:&error];
    
    [DataManager deleteData:data toCurrentUserForKey:@"creditcard" withCompletionBlock:compblock];
}


#pragma mark - GETTERS

+(NSArray *)userCreditCards
{
    return [DataManager sharedInstance].user.creditCards;
}

@end

