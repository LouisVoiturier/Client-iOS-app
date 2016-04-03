//
//  ValetFaker.m
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ValetFaker.h"

@implementation ValetFaker

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithEmail:dictionary[@"username"]
                       andName:dictionary[@"name"]
                  andCellPhone:dictionary[@"cellphone"]
                    andPicture:dictionary[@"picture"]
                  andPositions:dictionary[@"positions"]
            ];
}

-(instancetype)initWithEmail:(NSString *)email
                     andName:(NSDictionary *)name
                andCellPhone:(NSString *)cellPhone
                  andPicture:(NSString *)picture
                andPositions:(NSArray *)positions
{
    self = [super initWithEmail:email
                        andName:name
                   andCellPhone:cellPhone
                     andPicture:picture];
    
    if (self)
    {
        _positions = positions;
        _positionIndex = 0;
    }
    return self;
}


-(Coords *)getFakerCurrentLocation
{
    return (Coords *)[self.positions objectAtIndex:self.positionIndex];
}

@end
