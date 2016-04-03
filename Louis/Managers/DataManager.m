//
//  DataManager.m
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import "DataManager+User.h"

@implementation DataManager

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}



+ (NSData *)dataForObject:(id)object
{    
    NSAssert([object respondsToSelector:@selector(dictionary)], @"Object SHOULD respond to selector 'dictionary' !");
    
    NSDictionary *objectDictionary = [object dictionary];
    NSError *error;
    return [NSJSONSerialization dataWithJSONObject:objectDictionary options:0 error:&error];
}



+ (void)postData:(NSData *)data toCurrentUserForKey:(NSString *)key withCompletionBlock:(dataPostCompletion)completionBlock
{
    DataManager *dataManager = [DataManager sharedInstance];
    NSLog(@"Avant postRequestWithData key = %@\n user.description = %@", key, dataManager.user.description);
    
    NSString *savePassword = dataManager.user.password;

    [[NetworkManager sharedInstance] postRequestWithData:data
                                                  forKey:key
                                             forUsername:[[dataManager user] email]
                                             andPassword:[[dataManager user] password]
                                   withCompletionHandler:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
                                    {
                                        if (!error)
                                        {
                                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:-1 error:nil];
                                         
                                            dataManager.user = [[User alloc] initWithDictionary:dic];
                                            NSLog(@"USER DIC : %@", dic);
                            
                                            NSString *password =[[dataManager userCredentials] valueForKey:@"password"];

                                            if (password.length == 0)
                                            {   // le password n'est pas encore renseigné dans le keychain à ce stade du processus d'inscription et il ne faut pas écraser la valeur dans dataManager.user.password.
                                                [dataManager.user setPassword:savePassword];
                                            }
                                            else
                                            {
                                                [dataManager.user setPassword:password];
                                                NSLog(@"Password enregistré dans keychain,%@", password);
                                            }
                                            
                                            NSLog(@"Apres postRequestWithData key = %@\n user.description = %@", key, dataManager.user.description);
                                            
//                                            NSString *beforeID = dataManager.user.customerStripId ;
                                            // On affecte le customer Id de la première carte au User pour pouvoir la delete
                                            dataManager.user.customerStripId = [[[dic objectForKey:@"creditCard"] firstObject] objectForKey:@"customer"];
                                            
//                                            NSString *afterID = dataManager.user.customerStripId ;
                                        }
                                        
                                        completionBlock([dataManager user], httpResponse, error);
                                    }];
}



+ (void)putData:(NSData *)data toCurrentUserForKey:(NSString *)key withCompletionBlock:(dataPostCompletion)completionBlock
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    [[NetworkManager sharedInstance] putRequestWithData:data
                                                 forKey:key
                                            forUsername:[[dataManager user] email]
                                            andPassword:[[dataManager user] password]
                                    withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
                                     {
                                         if (!error)
                                         {
                                             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:-1 error:nil];
                                             
                                             dataManager.user = [[User alloc] initWithDictionary:dic];
                                             [dataManager.user setPassword:[[dataManager userCredentials] valueForKey:@"password"]];
                                             
                                             // On affecte le customer Id de la première carte au User pour pouvoir la delete
                                             dataManager.user.customerStripId = [[[dic objectForKey:@"creditCard"] firstObject] objectForKey:@"customer"];
                                         }
                                         
                                         completionBlock([dataManager user], httpResponse, error);
                                     }];
}



+ (void)deleteData:(NSData *)data toCurrentUserForKey:(NSString *)key withCompletionBlock:(dataPostCompletion)completionBlock
{
    DataManager *dataManager = [DataManager sharedInstance];
    [[NetworkManager sharedInstance] deleteRequestWithData:data
                                                    forKey:key
                                               forUsername:[[dataManager user] email]
                                               andPassword:[[dataManager user] password]
                                       withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
                                         {
                                             if (!error)
                                             {
                                                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:-1 error:nil];
                                                 
                                                 dataManager.user = [[User alloc] initWithDictionary:dic];
                                                 [dataManager.user setPassword:[[dataManager userCredentials] valueForKey:@"password"]];
                                                 
                                                 // On affecte le customer Id de la première carte au User pour pouvoir la delete
                                                 dataManager.user.customerStripId = [[[dic objectForKey:@"creditCard"] firstObject] objectForKey:@"customer"];
                                             }
                                             
                                             completionBlock([dataManager user], httpResponse, error);
                                         }];
}

@end
