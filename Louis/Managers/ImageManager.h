//
//  ImageManager.h
//  Louis
//
//  Created by François Juteau on 19/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^cacheImageCompletion)(UIImage *image);

@interface ImageManager : NSObject

+(void)getImageFromUrlPath:(NSString *)urlPath withCompletion:(cacheImageCompletion)compblock;

@end
