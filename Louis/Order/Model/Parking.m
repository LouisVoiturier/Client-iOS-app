//
//  Parking.m
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Parking.h"

@implementation Parking

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithId:dictionary[@"_id"]
                    andName:dictionary[@"name"]
                andLocation:dictionary[@"location"]
               andSchedules:dictionary[@"schedules"]
                andServices:dictionary[@"services"]
                   andPrice:dictionary[@"pricePerHour"]];
}


- (instancetype)initWithId:(NSString *)parkingId
                   andName:(NSString *)name
               andLocation:(NSArray *)location
              andSchedules:(NSDictionary *)schedules
               andServices:(NSArray *)services
                  andPrice:(Price *)pricePerHour
{
    self = [super init];
    if (self)
    {
        __id = parkingId;
        _name = name;
        _location = [[Coords alloc] initWithArrayofCoordinates:location];
        _schedules = schedules;
        _services = services;
        _pricePerHour = pricePerHour;
    }
    return self;
}


-(NSDictionary *)dictionary
{
    return @{ @"_id":self._id,
              @"name":self.name,
              @"location":self.location,
              @"schedules":self.schedules,
              @"services":self.services,
              @"pricePerHour":self.pricePerHour};
}

#pragma mark - Description surcharge

-(NSString *)description
{
    return [NSString stringWithFormat:@"*** PARKING = id : %@\n name : %@\n location : %@\n schedules : %@\n services : %@\n pricePerHour : %@", self._id, self.name, self.location, self.schedules, self.services, self.pricePerHour];
}

@end
