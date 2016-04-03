//
//  HTTPResponseHandler.h
//  Louis
//
//  Created by François Juteau on 30/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^okPressedCompletion)();

@interface HTTPResponseHandler : NSObject

+(void)handleHTTPResponse:(NSHTTPURLResponse *)httpResponse
              withMessage:(NSString *)message
            forController:(UIViewController *)controller
           withCompletion:(okPressedCompletion)compbloc;

@end
