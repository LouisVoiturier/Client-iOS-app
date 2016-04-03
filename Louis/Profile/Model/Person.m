//
//  Person.m
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import "Person.h"
#import "DataManager+User.h"

@interface Person()

@end

@implementation Person

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithEmail:dictionary[@"email"]
                       andName:dictionary[@"name"]
                  andCellPhone:dictionary[@"cellphone"]
                    andPicture:dictionary[@"picture"]];
    
}

//-(instancetype)initWithDictionary:(NSDictionary *)dictionary
//{
//    return [self initWithEmail:dictionary[@"email"]
//                   andPassword:dictionary[@"password"]
//                       andName:dictionary[@"name"]
//                  andCellPhone:dictionary[@"cellphone"]];
//
//}

//
//-(instancetype)initWithEmail:(NSString *)email
//                 andPassword:(NSString *)password
//                     andName:(NSDictionary *)name
//                andCellPhone:(NSString *)cellPhone


-(instancetype)initWithEmail:(NSString *)email
                     andName:(NSDictionary *)name
                andCellPhone:(NSString *)cellPhone
                  andPicture:(NSString *)picture

{
    self = [super init];
    
    if (self)
    {
        _email = email;
        _password = [[[DataManager sharedInstance] userCredentials] valueForKey:@"password"];
        _firstName = [name objectForKey:@"first"];
        _lastName = [name objectForKey:@"last"];
        _cellPhone = cellPhone;
        _picture = picture;
        
    }
    return self;
}


-(NSDictionary *)dictionary
{
    NSDictionary *dictionary = @{   @"email":self.email,
                                    @"password":self.password,
                                    @"firstName":self.firstName,
                                    @"lastName":self.lastName,
                                    @"cellPhone":self.cellPhone};
    
    return dictionary;
}

#pragma mark - Description surcharge

-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Username : %@\n password : %@\n Cellphone : %@\n Firstname : %@\n LastName : %@\n picture : %@", self.email, self.password, self.cellPhone, self.firstName, self.lastName, self.picture];

//    NSString *desc = [NSString stringWithFormat:@"Username : %@\n password : %@\n Cellphone : %@\n Firstname : %@\n LastName : %@\n ", self.email, self.password, self.cellPhone, self.firstName, self.lastName];
    
    return desc;
}

@end
