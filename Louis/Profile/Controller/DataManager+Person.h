//
//  DataManager+Person.h
//  Louis-Voituriers
//
//  Created by Giang Christian on 10/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager.h"

@interface DataManager (Person)

+(void)signUpWithUsername:(NSString *)username
              andPassword:(NSString *)password
             andFirstname:(NSString *)firstname
              andLastname:(NSString *)lastname
           andPhoneNumber:(NSString *)PhoneNumber
            andPictureUrl:(NSURL *)pictureUrl
               completion:(dataPostCompletion)compbloc;


@end


