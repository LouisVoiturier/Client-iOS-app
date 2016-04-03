//
//  Valet.h
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import "Person.h"

@interface Valet : Person

@property (nonatomic) NSUInteger rating;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
