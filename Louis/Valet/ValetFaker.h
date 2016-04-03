//
//  ValetFaker.h
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "Person.h"
#import "Coords.h"

@interface ValetFaker : Person

@property (nonatomic) NSUInteger rating;
@property (nonatomic) CGFloat ETA;

/** Array of faker positions */
@property (nonatomic, strong) NSArray <Coords *> *positions;

// DEBUG : utiliser pour parcourir le tabealu de position faker
@property (nonatomic) NSUInteger positionIndex;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(Coords *)getFakerCurrentLocation;

@end
