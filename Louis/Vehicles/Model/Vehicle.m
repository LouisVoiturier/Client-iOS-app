//
//  Vehicle.m
//  Louis
//
//  Created by Thibault Le Cornec on 25/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Vehicle.h"


@implementation Vehicle


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        _vehicleID = [[dictionary valueForKey:@"vehicleId"] copy];
        _brand = [[dictionary valueForKey:@"brand"] copy];
        _model = [[dictionary valueForKey:@"model"] copy];
        _numberPlate = [[dictionary valueForKey:@"numberplate"] copy];
        _color = [[dictionary valueForKey:@"color"] copy];
    }
    
    return self;
}



- (NSDictionary *)dictionary
{
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    
    if ([self vehicleID] != nil)
    {
        [mDict setValue:[self vehicleID] forKey:@"vehicleId"];
    }
    
    [mDict setValue:[self brand] forKey:@"brand"];
    [mDict setValue:[self model] forKey:@"model"];
    [mDict setValue:[self color] forKey:@"color"];
    
    if ([self numberPlate] != nil)
    {
        [mDict setValue:[self numberPlate] forKey:@"numberplate"];
    }
    
    return [mDict copy];
}



- (instancetype)initWithBrand:(NSString *)brand
                        model:(NSString *)model
                        color:(NSString *)color
               andNumberPlate:(NSString *)numberPlate
{
    self = [super init];
    
    if (self)
    {
        _vehicleID = nil;
        _brand = [brand copy];
        _model = [model copy];
        _color = [color copy];
        _numberPlate = [numberPlate copy];
    }
    
    return self;
}



-(NSString *)infosResume
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.brand, self.model, self.color];
}



@end
