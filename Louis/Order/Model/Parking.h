//
//  Parking.h
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coords.h"
#import "Price.h"


@interface Parking : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Coords *location;
@property (nonatomic, strong) NSDictionary *schedules;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) Price *pricePerHour;


/*******************/
/***** METHODS *****/
/*******************/

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)dictionary;

@end
