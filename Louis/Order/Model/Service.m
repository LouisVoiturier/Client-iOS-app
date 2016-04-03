//
//  Service.m
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Service.h"

@implementation Service

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithId:dictionary[@"_id"]
                    andName:dictionary[@"name"]
             andDescription:dictionary[@"description"]
                   andPrice:dictionary[@"price"]];
}

- (instancetype)initWithId:(NSString *)serviceID
                   andName:(NSString *)name
            andDescription:(NSString *)description
                  andPrice:(Price *)price
{
    self = [super init];
    if (self)
    {
        __id = serviceID;
        _name = name;
        _desc = description;
        _price = price;
    }
    return self;
}

-(NSDictionary *)dictionary
{
    return @{ @"_id":self._id,
              @"name":self.name,
              @"description":self.desc,
              @"price":self.price};
}

#pragma mark - Description surcharge

-(NSString *)description
{
    return [NSString stringWithFormat:@"*** SERVICE = id : %@\n name : %@\n desc : %@\n price : %@", self._id, self.name, self.desc, self.price];
}

@end
