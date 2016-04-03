//
//  DataManager+User.h
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import "DataManager.h"
#import <Stripe/Stripe.h>


@interface DataManager (User)

+(void)signInWithUsername:(NSString *)username
              andPassword:(NSString *)password
               completion:(dataPostCompletion)completionBlock;

// Sign Up
+(void)signUpWithUsername:(NSString *)username
              andPassword:(NSString *)password
             andFirstname:(NSString *)firstname
              andLastname:(NSString *)lastname
           andPhoneNumber:(NSString *)phoneNumber
               andPicture:(NSString *)picture
               completion:(dataPostCompletion)completionBlock;


+(void)modifyProfileWithUsername:(NSString *)oldEmail
                     andPassword:(NSString *)password
                     andNewEmail:(NSString *)newEmail
                    andFirstname:(NSString *)firstname
                     andLastname:(NSString *)lastname
                  andPhoneNumber:(NSString *)phonenumber
                      andPicture:(NSString *)picture
                      completion:(dataPostCompletion)completionBlock;

- (NSDictionary *)userCredentials;


+ (void) downloadUserProfileImage:(dataPostCompletion)completionBlock;


#pragma mark - GETTERS

+(User *)user;


@end
