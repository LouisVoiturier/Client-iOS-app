//
//  Service.h
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Price.h"

@interface Service : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) Price *price;


/*******************/
/***** METHODS *****/
/*******************/

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)dictionary;

@end
