//
//  User.m
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import "User.h"
#import "Vehicle.h"
#import "STPCard+Helper.h"

@interface User()

@end

@implementation User

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithEmail:dictionary[@"username"]
                       andName:dictionary[@"name"]
                  andCellPhone:dictionary[@"cellphone"]
                    andPicture:dictionary[@"picture"]
                   andVehicles:dictionary[@"vehicle"]
                andCreditCards:dictionary[@"creditCard"]];
}


-(instancetype)initWithEmail:(NSString *)email
                     andName:(NSDictionary *)name
                andCellPhone:(NSString *)cellPhone
               andPicture:(NSString *)picture
                 andVehicles:(NSArray *)vehicles
              andCreditCards:(NSArray *)creditCards
{
    self = [super initWithEmail:email
                        andName:name
                   andCellPhone:cellPhone
                     andPicture:picture];
    
    if (self)
    {
        NSMutableArray *mutableVehicles = [[NSMutableArray alloc] init];
        for (NSDictionary *item in vehicles)
        {
            Vehicle *vehicle = [[Vehicle alloc] initWithDictionary:item];
            [mutableVehicles addObject:vehicle];
        }
        _vehicles = [mutableVehicles copy];
        
        
        NSMutableArray *mutableCreditCards = [[NSMutableArray alloc] init];
        NSLog(@"CARDS : %@", creditCards);
        for (NSDictionary *item in creditCards)
        {
            STPCard *card = [[STPCard alloc] initWithAttributeDictionary:item];
            [mutableCreditCards addObject:card];
        }
        _creditCards = [mutableCreditCards copy];
    }
    return self;
}

-(NSDictionary *)dictionary
{
    return @{ @"email":self.email,
              @"password":self.password,
              @"firstName":self.firstName,
              @"lastName":self.lastName,
              @"cellPhone":self.cellPhone,
              @"picture":self.picture,
              @"vehicles":self.vehicles,
              @"creditCards":self.creditCards};
}


#pragma mark - Description surcharge

-(NSString *)description
{
    return [NSString stringWithFormat:@"Username : %@\n password : %@\n Cellphone : %@\n Firstname : %@\n LastName : %@", self.email, self.password, self.cellPhone, self.firstName, self.lastName];
}

@end
