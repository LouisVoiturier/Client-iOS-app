//
//  DataManager+User.m
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import "DataManager+User.h"
#import "KeychainWrapper.h"
#import "HTTPResponseHandler.h"

@implementation DataManager (User)

+(void)signInWithUsername:(NSString *)username
              andPassword:(NSString *)password
               completion:(dataPostCompletion)completionBlock
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    [[NetworkManager sharedInstance] postRequestWithData:nil
                                                  forKey:@"login"
                                             forUsername:username
                                             andPassword:password
                                   withCompletionHandler:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
                                    {
                                        if (!error)
                                        {
                                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                            
                                            dataManager.user = [[User alloc] initWithDictionary:dic];
                                //            NSLog(@"USER : %@", dataManager.user.description);
                                            
                                            NSLog(@"USER DIC : %@", dic);
                                            // On affecte le customer Id de la première carte au User pour pouvoir la delete
                                            dataManager.user.customerStripId = [[[dic objectForKey:@"creditCard"] firstObject] objectForKey:@"customer"];
                                        }
                                        completionBlock(dataManager.user, httpResponse, error);
                                    }];
}


// Sign Up

+(void)signUpWithUsername:(NSString *)username
              andPassword:(NSString *)password
             andFirstname:(NSString *)firstname
              andLastname:(NSString *)lastname
            andPhoneNumber:(NSString *)phonenumber
               andPicture:(NSString *)picture
               completion:(dataPostCompletion)completionBlock
{
    DataManager *dataManager = [DataManager sharedInstance];
 
//    NSDictionary *dictionaryForUser = @{   @"username":username,
//                                           @"password":password,
//                                           @"name":@{ @"first":firstname,@"last":lastname},
//                                           @"lastname":lastname,
//                                           @"cellphone":phonenumber};
//    
//    // instantiation du user avec les données saisis par l'utilisateur
//    dataManager.user = [[User alloc] initWithDictionary:dictionaryForUser];
    
    NSDictionary *name = @{ @"first":firstname, @"last":lastname};
    
    dataManager.user = [[User alloc]initWithEmail:username
                                          andName:name
                                     andCellPhone:phonenumber
                                    andPicture:picture
                                      andVehicles:nil
                                   andCreditCards:nil];
    
    NSLog(@"dataManager.user.description %@",dataManager.user.description);
    
    // dictionnaire pour le WS sign Up
    NSDictionary *dictionaryForWSSignUp = @{   @"username":username,
                                               @"password":password,
                                               @"firstname":firstname,
                                               @"lastname":lastname,
                                               @"cellphone":phonenumber,
                                               @"picture":picture};

    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryForWSSignUp options:0 error:NULL];
    
    
    [[NetworkManager sharedInstance] postRequestWithData:data
                                                  forKey:@"signup"
                                             forUsername:username
                                             andPassword:password
                                   withCompletionHandler:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
                                     {
                                         if (!error)
                                         {
                                             NSLog(@"error : %@", error);
                                             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:-1 error:nil];
                                             NSLog(@"User NetworkManager WS Sign Up renvoie DIC : %@",dic);
                                             
                                             dataManager.user = [[User alloc] initWithDictionary:dic];
                                             
                                             // cas particulier du signUp car keychain pas encore renseigné
                                             // [dataManager.user setPassword:[[dataManager userCredentials] valueForKey:@"password"]];
                                             dataManager.user.password = password;
                                             
//                                             NSLog(@"USER : %@", dataManager.user.description);
                                             
                                         }
                                         NSLog(@"dataManager.user.description %@",dataManager.user.description);
                                         completionBlock(dataManager.user, httpResponse, error);
                                         
                                     }];
}

// Modify user profile

+(void)modifyProfileWithUsername:(NSString *)oldEmail
                     andPassword:(NSString *)password
                     andNewEmail:(NSString *)newEmail
                    andFirstname:(NSString *)firstname
                     andLastname:(NSString *)lastname
                  andPhoneNumber:(NSString *)phonenumber
                      andPicture:(NSString *)picture
                      completion:(dataPostCompletion)completionBlock
{
    DataManager *dataManager = [DataManager sharedInstance];
    NSLog(@"WS SignUpProfile user.email : %@",dataManager.user.description);
    
    // dictionnaire pour le WS sign Up
    NSDictionary *dictionaryForWSAccount = @{  @"email":newEmail,
                                               @"password":password,
                                               @"firstname":firstname,
                                               @"lastname":lastname,
                                               @"cellphone":phonenumber};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryForWSAccount options:0 error:nil];
    
    
    [[NetworkManager sharedInstance] putRequestWithData:data
                                                  forKey:@"account"
                                             forUsername:oldEmail
                                            andPassword:password
                                    withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         NSLog(@"error : %@", error);
             
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:-1 error:nil];
         
         NSLog(@"User NetworkManager WS Account renvoie DIC : %@",dic);
         
         dataManager.user = [[User alloc] initWithDictionary:dic];
         
         // on réinitialise le keychain dans le cas où il modifie son email.
         if (![oldEmail isEqualToString:newEmail])
         {
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasLoginKey"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             KeychainWrapper *MyKeychainWrapper =[[KeychainWrapper alloc]init];
             
             [MyKeychainWrapper mySetObject:@"" forKey:(__bridge id)kSecAttrAccount];
             [MyKeychainWrapper mySetObject:@"" forKey:(__bridge id)kSecValueData];
             [MyKeychainWrapper writeToKeychain];
         }
         
         NSLog(@"USER WS Account : %@", dataManager.user.description);
             
         completionBlock(dataManager.user, httpResponse, error);
     }];
}


- (NSDictionary *)userCredentials
{
    KeychainWrapper *MyKeychainWrapper =[[KeychainWrapper alloc]init];
    
    //login auto apres avoir récupéré login et password qui se trouvent dans la keychain
    NSString *username = [MyKeychainWrapper myObjectForKey:(__bridge id)kSecAttrAccount];
    NSString *password = [MyKeychainWrapper myObjectForKey:(__bridge id)kSecValueData];
    
    return @{@"username":username, @"password":password};
}


+ (void) downloadUserProfileImage:(dataPostCompletion)completionBlock
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    [[NetworkManager sharedInstance] downloadDataForKey:@"profileImage"
                                            withPicture:dataManager.user.picture
                                            forUsername:[[dataManager user] email]
                                            andPassword:[[dataManager user] password]
                                    withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
    {
        if (httpResponse.statusCode != 200)
        {
            [HTTPResponseHandler handleHTTPResponse:httpResponse
                                        withMessage:@""
                                      forController:self
                                     withCompletion:^
             {
                 nil;
             }];
        }
        else
        {
            if (!error)
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // do stuff with image
                    UIImage *downloadedImage = [UIImage imageWithData:data];
                    DataManager.user.pictureImage = downloadedImage;
                });
            }
            completionBlock([dataManager user], httpResponse, error);
        }
    }];

}



#pragma mark - GETTERS

+(User *)user
{
    return [DataManager sharedInstance].user;
}


@end
