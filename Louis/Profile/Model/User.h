//
//  User.h
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface User : Person

@property (nonatomic, strong) NSArray *vehicles;
@property (nonatomic, strong) NSArray *creditCards;
@property (nonatomic) NSUInteger *price;

/** ID utilisé par stripe pour reconnaitre l'utilisateur */
@property (nonatomic, strong) NSString *customerStripId;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)dictionary;

-(instancetype)initWithEmail:(NSString *)email
                     andName:(NSDictionary *)name
                andCellPhone:(NSString *)cellPhone
                  andPicture:(NSString *)picture
                 andVehicles:(NSArray *)vehicles
              andCreditCards:(NSArray *)creditCards;

@end
