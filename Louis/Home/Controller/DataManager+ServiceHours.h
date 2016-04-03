//
//  DataManager+ServiceHours.h
//  Louis
//
//  Created by François Juteau on 08/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager.h"

typedef void(^hourGetCompletion)(NSHTTPURLResponse *httpResponse, NSError *error);
typedef void(^nextHourGetCompletion)(NSString *message, NSHTTPURLResponse *httpResponse, NSError *error);

@interface DataManager (ServiceHours)

+(void)getNextOpenhourCompletion:(nextHourGetCompletion)completionBlock;

@end
