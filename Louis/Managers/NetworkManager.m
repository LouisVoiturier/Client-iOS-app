//
//  NetworkManager.m
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#import "NetworkManager.h"

//#error Set your API URL.
static NSString* const kBaseURL = @"https://fierce-spire-6248.herokuapp.com/api/";


@interface NetworkManager()

// TODELETE
@property (nonatomic, strong) NSDictionary *urls;

@end


@implementation NetworkManager

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



-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _urls = @{@"User" : @"user"};
    }
    return self;
}


// cette methode downloadTaskWithURL télécharge la photo sur l'iphone et nous renvoie son url "locate" stocké sur l'iphone
// Cette méthode n'est pas utilisé pour l'instant. On utilise juste dataWithContentsOfURL qui a priori ne télécharge pas la photo
- (void)httpDownloadMethod:(NSString *)method
               withPicture:(NSString *)picture
                    forKey:(NSString *)key
               forUsername:(NSString *)username
               andPassword:(NSString *)password
       withCompletionBlock:(exportCompletion)completionBlock
{
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDownloadTask *downloadTask =[session downloadTaskWithURL:[NSURL URLWithString:picture] completionHandler:
                                             ^(NSURL *location, NSURLResponse *response, NSError *error)
                                             {
                                                   NSLog(@"NSURLResponse %@", response);
                                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                   NSLog(@"NetworkManager %@ httpResponse status code: %ld", key, (long)[httpResponse statusCode]);
                                          
                                                   NSLog(@"downloadTaskWithURL image url location : %@",location);
                                                   NSData * data = [NSData dataWithContentsOfURL:location];
                                                   completionBlock(data, httpResponse, error);

                                            }];
    [downloadTask resume];
}



- (void)httpRequestMethod:(NSString *)method
                 withData:(NSData *)data
                   forKey:(NSString *)key
              forUsername:(NSString *)username
              andPassword:(NSString *)password
      withCompletionBlock:(exportCompletion)completionBlock
{
    // ----- Link to API ----- //
    NSString* urlStr = [kBaseURL stringByAppendingPathComponent:key];
    NSURL* url = [NSURL URLWithString:urlStr];
    
    // ----- String for Authorization ----- //
    NSString *authStr   = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData    = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    
    // ----- Request Creation ----- //
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // ----- Create Session ----- //
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // ----- Session Data Task ----- //
    NSURLSessionTask* dataTask;
    if (data != nil)
    {
        [request setHTTPBody:data];
    }
        
    dataTask = (NSURLSessionDataTask *)[session dataTaskWithRequest:request completionHandler:
                                        ^(NSData *data, NSURLResponse *response, NSError *error)
                                        {
                                            completionBlock(data, (NSHTTPURLResponse *)response, error);
                                        }];

    // ----- Execution of Task ----- //
    [dataTask resume];
}


-(void)postRequestWithData:(NSData *)data
                    forKey:(NSString *)key
               forUsername:(NSString *)username
               andPassword:(NSString *)password
     withCompletionHandler:(exportCompletion)completionBlock
{
    [self httpRequestMethod:@"POST"
                   withData:data
                     forKey:key
                forUsername:username
                andPassword:password
        withCompletionBlock:completionBlock];
}



- (void)putRequestWithData:(NSData *)data
                    forKey:(NSString *)key
               forUsername:(NSString *)username
               andPassword:(NSString *)password
       withCompletionBlock:(exportCompletion)completionBlock
{
    [self httpRequestMethod:@"PUT"
                   withData:data
                     forKey:key
                forUsername:username
                andPassword:password
        withCompletionBlock:completionBlock];
}



- (void)deleteRequestWithData:(NSData *)data
                       forKey:(NSString *)key
                  forUsername:(NSString *)username
                  andPassword:(NSString *)password
          withCompletionBlock:(exportCompletion)completionBlock
{
    [self httpRequestMethod:@"DELETE"
                   withData:data
                     forKey:key
                forUsername:username
                andPassword:password
        withCompletionBlock:completionBlock];
}



-(void)getDataForKey:(NSString *)key
         forUsername:(NSString *)username
         andPassword:(NSString *)password
 withCompletionBlock:(exportCompletion)completionBlock
{
    [self httpRequestMethod:@"GET"
                   withData:nil
                     forKey:key
                forUsername:username
                andPassword:password
        withCompletionBlock:completionBlock];
}



-(void)downloadDataForKey:(NSString *)key
              withPicture:(NSString *)picture
              forUsername:(NSString *)username
              andPassword:(NSString *)password
      withCompletionBlock:(exportCompletion)completionBlock
{
    [self httpDownloadMethod:@"GET"
                 withPicture:picture
                      forKey:key
                 forUsername:username
                 andPassword:password
         withCompletionBlock:completionBlock];
    }

@end
