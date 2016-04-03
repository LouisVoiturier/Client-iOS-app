//
//  DataManager.h
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "User.h"
#import "Order.h"

typedef void (^dataPostCompletion)(User *user, NSHTTPURLResponse *httpResponse, NSError *error);
typedef void (^orderPostCompletion)(Order *order, NSHTTPURLResponse *httpResponse, NSError *error);


@interface DataManager : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) NSArray *previousOrders;
@property (nonatomic, strong) NSDictionary *serviceHoursDic;


+ (instancetype)sharedInstance;
+ (NSData *)dataForObject:(id)object;
+ (void)postData:(NSData *)data   toCurrentUserForKey:(NSString *)key withCompletionBlock:(dataPostCompletion)completionBlock;
+ (void)putData:(NSData *)data    toCurrentUserForKey:(NSString *)key withCompletionBlock:(dataPostCompletion)completionBlock;
+ (void)deleteData:(NSData *)data toCurrentUserForKey:(NSString *)key withCompletionBlock:(dataPostCompletion)completionBlock;

@end
