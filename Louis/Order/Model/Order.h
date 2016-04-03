//
//  Order.h
//  Louis
//
//  Created by Thibault Le Cornec on 20/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Vehicle.h"
#import "Checkin.h"
#import "Parking.h"
#import "Price.h"
#import "STPCard+Helper.h"


@interface Order : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, strong) User *client;
@property (nonatomic, strong) Vehicle *vehicle;
@property (nonatomic) NSInteger state;
@property (nonatomic, strong) Checkin *checkIn;
@property (nonatomic, strong) Checkin *checkOut;
@property (nonatomic, strong) Parking *parking;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) Price *price;
@property (nonatomic, strong) STPCard *card;


/*******************/
/***** METHODS *****/
/*******************/

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)dictionary;

@end
