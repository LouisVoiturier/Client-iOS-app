//
//  ImageManager.m
//  Louis
//
//  Created by François Juteau on 19/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ImageManager.h"
#import "NetworkManager.h"

@implementation ImageManager

+(void)getImageFromUrlPath:(NSString *)urlPath withCompletion:(cacheImageCompletion)compblock
{
    [[NetworkManager sharedInstance] httpDownloadMethod:@"GET"
                                            withPicture:urlPath
                                                 forKey:@""
                                            forUsername:@""
                                            andPassword:@""
                                    withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
    {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            compblock(image);
        }
        else
        {
            NSLog(@"IMAGE MANAGER : NO DATA : error : %@", error.debugDescription);
        }
    }];
}

+(void)TESTgetImageFromUrlPath:(NSString *)urlPath withCompletion:(cacheImageCompletion)compblock
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [paths objectAtIndex:0];
//    BOOL isDir = NO;
//    NSError *error;
//    if (! [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO)
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
//    }
//    
//    NSString *filePath = [cachePath stringByAppendingPathComponent:urlPath];
//    
//    
//    NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:&error];
//    
//    if (error)
//    {
//        NSLog(@"IMAGE MANAGER ERROR : %@", error.debugDescription);
//    }
//    
//    if (!data)
//    {
//        [[NetworkManager sharedInstance] httpDownloadMethod:@"GET"
//                                                withPicture:urlPath
//                                                     forKey:@""
//                                                forUsername:@""
//                                                andPassword:@""
//                                        withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
//         {
//             if (data)
//             {
//                 UIImage *image = [UIImage imageWithData:data];
//                 
//                 // Create path.
//                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                 NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:urlPath];
//                 
//                 // Save image.
//                 [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
//                 
//                 compblock(image);
//             }
//             else
//             {
//                 NSLog(@"CACHE IMAGE MANAGER : NO DATA");
//             }
//             
//         }];
//    }
//    else
//    {
//        compblock([UIImage imageWithData:data]);
//    }
//    
//
}

@end
