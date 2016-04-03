//
//  STPCard+Helper.m
//  Louis
//
//  Created by François Juteau on 12/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "STPCard+Helper.h"
#import "DataManager+User.h"

@implementation STPCard (Helper)

- (instancetype)initWithAttributeDictionary:(NSDictionary *)dictionary
{
    return self;
}


-(NSString *)infosResume
{
    if (self.name == nil)
    {
        return [NSString stringWithFormat:@"**** %@", self.last4];
    }
    return [NSString stringWithFormat:@"%@ **** %@", self.name, self.last4];
}


-(NSDictionary *)toDictionary
{
//    NSString *customer = [self customer];
    NSDictionary *dictionary = @{ @"card":@{@"id":self.cardId, @"customer":[self customer]} };
    
    return dictionary;
}


-(NSString *)customer
{
//    User *user = [DataManager user];
    return [DataManager user].customerStripId;
}

@end
