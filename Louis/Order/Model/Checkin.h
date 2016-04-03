//
//  Checkin.h
//  Louis
//
//  Created by Thibault Le Cornec on 20/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Valet.h"
#import "Coords.h"

@interface Checkin : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) Valet *valet;
@property (nonatomic, strong) Coords *meetingLocation;
@property (nonatomic, strong) NSDate *orderedTime;
@property (nonatomic, strong) NSDate *date;


/*******************/
/***** METHODS *****/
/*******************/

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)dictionary;

@end
