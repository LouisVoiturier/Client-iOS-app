//
//  Price.m
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Price.h"

@implementation Price

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithValue:dictionary[@"value"]
                   forCurrency:dictionary[@"currency"]];
}


- (instancetype)initWithValue:(NSNumber *)value forCurrency:(NSString *)currency
{
    self = [super init];
    if (self)
    {
        _value = value;
        _currency = currency;
    }
    return self;
}


-(NSDictionary *)dictionary
{
    return @{@"value":self.value, @"currency":self.currency};
}

#pragma mark - Description surcharge

-(NSString *)description
{
    return [NSString stringWithFormat:@"*** PRICE = value : %.2f\n currency : %@", self.value.floatValue, self.currency];
}

@end
