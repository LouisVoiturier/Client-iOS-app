//
//  Coords.m
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Coords.h"

@implementation Coords

- (instancetype)initWithCLLocation2D:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
        _lattitude = location.latitude;
        _longitude = location.longitude;
    }
    return self;
}

- (instancetype)initWithArrayofCoordinates:(NSArray *)location
{
    self = [super init];
    if (self)
    {
        _lattitude = [(NSNumber *)location.firstObject integerValue];
        _longitude = [(NSNumber *)location.lastObject integerValue];
    }
    return self;
}

-(CLLocationCoordinate2D)location
{
    return CLLocationCoordinate2DMake(self.lattitude, self.longitude);
}

-(NSArray *)getArrayValue
{
    return @[@(self.lattitude), @(self.longitude)];
}

-(NSDictionary *)dictionary
{
    return @{@"location":self.getArrayValue};
}

@end
