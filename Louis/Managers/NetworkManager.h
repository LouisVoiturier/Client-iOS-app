//
//  NetworkManager.h
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

typedef void(^importCompletion)(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error);
typedef void(^exportCompletion)(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error);


@interface NetworkManager : NSObject


+(instancetype)sharedInstance;

- (void)httpDownloadMethod:(NSString *)method
               withPicture:(NSString *)picture
                    forKey:(NSString *)key
               forUsername:(NSString *)username
               andPassword:(NSString *)password
       withCompletionBlock:(exportCompletion)completionBlock;


-(void)downloadDataForKey:(NSString *)key
              withPicture:(NSString *)picture
              forUsername:(NSString *)username
              andPassword:(NSString *)password
      withCompletionBlock:(exportCompletion)completionBlock;

- (void)postRequestWithData:(NSData *)data
                     forKey:(NSString *)key
                forUsername:(NSString *)username
                andPassword:(NSString *)password
      withCompletionHandler:(exportCompletion)completionBlock;


- (void)putRequestWithData:(NSData *)data
                    forKey:(NSString *)key
               forUsername:(NSString *)username
               andPassword:(NSString *)password
       withCompletionBlock:(exportCompletion)completionBlock;


- (void)deleteRequestWithData:(NSData *)data
                       forKey:(NSString *)key
                  forUsername:(NSString *)username
                  andPassword:(NSString *)password
          withCompletionBlock:(exportCompletion)completionBlock;


- (void)getDataForKey:(NSString *)key
          forUsername:(NSString *)username
          andPassword:(NSString *)password
  withCompletionBlock:(importCompletion)completionBlock;


@end
