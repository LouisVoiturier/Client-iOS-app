//
//  STPCard+Helper.h
//  Louis
//
//  Created by François Juteau on 12/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Stripe/Stripe.h>

@interface STPCard (Helper)

- (instancetype)initWithAttributeDictionary:(NSDictionary *)dictionary;
- (NSString *)infosResume;
- (NSDictionary *)toDictionary;
- (NSString *)customer;

@end
