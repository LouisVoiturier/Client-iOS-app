//
//  Valet.m
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import "Valet.h"


@implementation Valet

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithEmail:dictionary[@"username"]
                       andName:dictionary[@"name"]
                  andCellPhone:dictionary[@"cellphone"]
                    andPicture:dictionary[@"picture"]];
}

@end
