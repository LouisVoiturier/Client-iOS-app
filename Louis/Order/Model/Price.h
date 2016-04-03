//
//  Price.h
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Price : NSObject

@property (nonatomic) NSNumber *value;
@property (nonatomic, strong) NSString *currency;


/*******************/
/***** METHODS *****/
/*******************/

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)dictionary;

@end
