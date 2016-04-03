//
//  DataManager+Person.m
//  Louis-Voituriers
//
//  Created by Giang Christian on 10/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager+Person.h"

@implementation DataManager (Person)

+(void)signUpWithUsername:(NSString *)username
              andPassword:(NSString *)password
             andFirstname:(NSString *)firstname
              andLastname:(NSString *)lastname
           andPhoneNumber:(NSString *)phonenumber
            andPictureUrl:(NSURL *)pictureUrl
            completion:(dataPostCompletion)compbloc
{
    DataManager *dataManager = [DataManager sharedInstance];
    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    dictionary[@"username"] = username;
//    dictionary[@"password"] = password;
//    dictionary[@"firstname"] = firstname;
//    dictionary[@"lastname"] = lastname;
//    dictionary[@"gender"] = @"Mr";
//    dictionary[@"cellphone"] = phonenumber;
    
    username = @"christiangiang@free.fr";
    password = @"password";
    firstname = @"firstname";
    lastname = @"lastname";
    phonenumber = @"0033612345678";

    NSDictionary *dictionary = @{   @"username":username,
                                    @"password":password,
                                    @"firstname":firstname,
                                    @"lastname":lastname,
                                    @"gender":@"Mr",
                                    @"cellphone":phonenumber};
    
    // CGIA WARNING
    // Dans les traces du dictionary, on a des guillemets dans les champs username et Cellphone
    // Or dans la variable username (avant affectation dans le dictionnary), il n'y a pas de guillemets

    NSLog(@"DataManager+Person username %@",username);
    
    NSLog(@"DataManager+Person dictionary %@",dictionary);

    
    //    NSData *data = [NSJSONSerialization dataWithJSONObject:[data toDictionary] options:0 error:NULL];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
    
    [[NetworkManager sharedInstance] postData:data
                                       forKey:@"signup"
                                  forUsername:username
                                  andPassword:password
                        withCompletionHandler:^(NSData *data, NSError *error)
     {
         if (!error)
         {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//             NSLog(@"DIC : %@ \n DIC",dic);
             NSLog(@"Person NetworkManager WS renvoie DIC : %@",dic);
             
             dataManager.person = [[Person alloc] initWithDictionary:dic];
             NSLog(@"USER : %@", dataManager.person.description);
         }
         compbloc(dataManager.person, error);
     }];
}


#pragma mark - GETTERS

+(Person *)person
{
    return [DataManager sharedInstance].person;
}


@end
