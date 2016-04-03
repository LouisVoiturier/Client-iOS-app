//
//  HTTPResponseHandler.m
//  Louis
//
//  Created by François Juteau on 30/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "HTTPResponseHandler.h"


@implementation HTTPResponseHandler

+(void)handleHTTPResponse:(NSHTTPURLResponse *)httpResponse
              withMessage:(NSString *)message
            forController:(UIViewController *)controller
            withCompletion:(okPressedCompletion)compbloc
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        
        NSString *codeMessage = [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"URLResponse-Title", @""), (long)httpResponse.statusCode];
        
        NSString *errorMessage;
        
        switch (httpResponse.statusCode)
        {
            case 401:
                errorMessage = NSLocalizedString(@"URLResponse-401", @"");
                break;
                
            case 404:
                errorMessage = NSLocalizedString(@"URLResponse-404", @"");
                break;
                
            case 503:
                errorMessage = NSLocalizedString(@"URLResponse-503", @"");
                break;
                
            default:
                break;
        }
        
        NSString *fullmessage = [NSString stringWithFormat:@"%@\n%@", errorMessage, message];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:codeMessage message:fullmessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action)
                             {
                                 [alertController dismissViewControllerAnimated:YES completion:^
                                  {
                                      compbloc();
                                  }];
                             }];
        
        [alertController addAction:ok];
        
        [controller presentViewController:alertController animated:YES completion:nil];
    });
    
}

@end
