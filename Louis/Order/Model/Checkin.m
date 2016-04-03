//
//  Checkin.m
//  Louis
//
//  Created by Thibault Le Cornec on 20/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Checkin.h"

@implementation Checkin

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithId:dictionary[@"_id"]
                   andValet:dictionary[@"valet"]
                andLocation:dictionary[@"meetingLocation"]
             andOrderedTime:dictionary[@"orderedTime"]
                    andDate:dictionary[@"date"]];
}

-(instancetype)initWithId:(NSString *)checkId
                 andValet:(NSDictionary *)valet
              andLocation:(NSArray *)location
           andOrderedTime:(NSDate *)orderedTime
                  andDate:(NSDate *)date
{
    self = [super init];
    
    if (self)
    {
        __id = checkId;
        _valet = [[Valet alloc] initWithDictionary:valet];
        _orderedTime = orderedTime;
        _date = date;
        _meetingLocation = [[Coords alloc] initWithArrayofCoordinates:location];
        
    }
    return self;
}


-(NSDictionary *)dictionary
{
    return @{ @"_id":self._id,
              @"valet":self.valet,
              @"meetingLocation":self.meetingLocation,
              @"orderedTime":self.orderedTime,
              @"date":self.date};
}


#pragma mark - Description surcharge

-(NSString *)description
{
    return [NSString stringWithFormat:@"*** Check IN = id : %@\n valet : %@\n mettingLocation : %@\n orderedTime : %@\n Date : %@", self._id, self.valet, self.meetingLocation, self.orderedTime, self.date];
}

@end
