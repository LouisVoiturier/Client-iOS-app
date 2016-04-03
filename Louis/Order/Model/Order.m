//
//  Order.m
//  Louis
//
//  Created by Thibault Le Cornec on 20/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Order.h"
#import "OrderState.h"

@implementation Order

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithId:dictionary[@"_id"]
                  andClient:dictionary[@"client"]
                 andVehicle:dictionary[@"vehicle"]
                   andState:dictionary[@"state"]
                 andCheckIn:dictionary[@"checkIn"]
                andCheckOut:dictionary[@"checkOut"]
                 andParking:dictionary[@"parking"]
                andServices:dictionary[@"services"]
                   andPrice:dictionary[@"price"]
                    andCard:dictionary[@"card"]];
}

- (instancetype)initWithId:(NSString *)orderId
                 andClient:(NSDictionary *)client
                andVehicle:(NSDictionary *)vehicle
                  andState:(NSString *)state
                andCheckIn:(NSDictionary *)checkIn
               andCheckOut:(NSDictionary *)checkOut
                andParking:(NSDictionary *)parking
               andServices:(NSArray *)services
                  andPrice:(NSDictionary *)price
                   andCard:(NSDictionary *)card
{
    self = [super init];
    if (self)
    {
        __id = orderId;
        _client = [[User alloc] initWithDictionary:client];
        _vehicle = [[Vehicle alloc] initWithDictionary:vehicle];;
        _state = [OrderState setAndGetCurrentStateFromString:state];
        _checkIn = [[Checkin alloc] initWithDictionary:checkIn];
        _checkOut = [[Checkin alloc] initWithDictionary:checkOut];
        _parking = [[Parking alloc] initWithDictionary:parking];
        _services = services;
        _price = [[Price alloc] initWithDictionary:price];
        _card = [[STPCard alloc] initWithAttributeDictionary:card];
    }
    return self;
}

-(NSDictionary *)dictionary
{
    NSDictionary *dictionary = @{   @"_id":     self._id,
                                    @"client":  self.client,
                                    @"vehicle": self.vehicle,
                                    @"state":   [[OrderState sharedInstance].states objectAtIndex:self.state],
                                    @"checkIn": self.checkIn,
                                    @"checkOut":self.checkOut,
                                    @"parking": self.parking,
                                    @"services":self.services,
                                    @"price":   self.price,
                                    @"card":    self.card
                                };
    return dictionary;
}


#pragma mark - Description surcharge

-(NSString *)description
{
    return [NSString stringWithFormat:@"*** ORDER = id : %@\n client : %@\n vehicle : %@\n state : %ld\n checkin : %@\n checkOut : %@\n parking : %@\n services : %@\n price : %@\n card : %@", self._id, self.client, self.vehicle, (long)self.state, self.checkIn, self.checkOut, self.parking, self.services, self.price, self.card.number];
}

@end
