//
//  DataManager+Order.m
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager+Order.h"
#import "DataManager+User.h"

@implementation DataManager (Order)

+(void)checkInWithLocation:(Coords *)location completion:(orderPostCompletion)compbloc
{
    DataManager *dataManager = [DataManager sharedInstance];
    NSDictionary *userCredential = [dataManager userCredentials];
    
    [[NetworkManager sharedInstance] postRequestWithData:[DataManager dataForObject:location]
                                                  forKey:@"order"
                                             forUsername:userCredential[@"username"]
                                             andPassword:userCredential[@"password"]
                                   withCompletionHandler:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         if (!error)
         {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:-1 error:nil];
             
             NSLog(@"CHECKIN ORDER DIC : %@", dic);
             Order *order = [[Order alloc] initWithDictionary:dic];
             [DataManager sharedInstance].order = order;
         }
         
         compbloc([DataManager order], httpResponse, error);
     }];
}

+(void)checkOutWithLocation:(Coords *)location completion:(orderPostCompletion)compbloc
{
    DataManager *dataManager = [DataManager sharedInstance];
    NSDictionary *userCredential = [dataManager userCredentials];
    
    NSDictionary *dicData = @{@"id":dataManager.order._id, @"location":location.getArrayValue};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dicData options:0 error:&error];
    
    [[NetworkManager sharedInstance] postRequestWithData:data
                                                  forKey:@"checkout"
                                             forUsername:userCredential[@"username"]
                                             andPassword:userCredential[@"password"]
                                   withCompletionHandler:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         if (!error)
         {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:-1 error:nil];
             Order *order = [[Order alloc] initWithDictionary:dic];
             [DataManager sharedInstance].order = order;
         }
         
         compbloc([DataManager order], httpResponse, error);
     }];
}

+(void)deleteCurrentOrderWithcompletion:(orderPostCompletion)compbloc
{
    DataManager *dataManager = [DataManager sharedInstance];
    NSDictionary *userCredential = [dataManager userCredentials];
    
    NSDictionary *dicData = @{@"id":dataManager.order._id};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dicData options:0 error:&error];
    
    
    [[NetworkManager sharedInstance] deleteRequestWithData:data
                                                    forKey:@"order"
                                             forUsername:userCredential[@"username"]
                                             andPassword:userCredential[@"password"]
                                   withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         if (!error)
         {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:-1 error:nil];
             Order *order = [[Order alloc] initWithDictionary:dic];
             NSLog(@"DELETE ORDER DIC : %@", dic);
             [DataManager sharedInstance].order = order;
         }
         
         compbloc([DataManager order], httpResponse, error);
     }];
}

+(Order *)order
{
    return [DataManager sharedInstance].order;
}

@end
