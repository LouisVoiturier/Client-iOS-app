//
//  DataManager+User_Vehicles.m
//  Louis
//
//  Created by Thibault Le Cornec on 12/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager+User_Vehicles.h"


@implementation DataManager (User_Vehicles)


+ (NSArray *)userVehicles
{
    return [[[DataManager sharedInstance] user] vehicles];
}


+ (void)addVehicle:(Vehicle *)vehicle withCompletionBlock:(dataPostCompletion)completionBlock
{
    [DataManager postData:[DataManager dataForObject:vehicle] toCurrentUserForKey:@"vehicle" withCompletionBlock:completionBlock];
}


+ (void)editVehicle:(Vehicle *)vehicle withCompletionBlock:(dataPostCompletion)completionBlock
{
    //TODO: change method to "putData" when API is ready
    [DataManager postData:[DataManager dataForObject:vehicle] toCurrentUserForKey:@"vehicle" withCompletionBlock:completionBlock];
}


+ (void)deleteVehicle:(Vehicle *)vehicle withCompletionBlock:(dataPostCompletion)completionBlock
{
    [DataManager deleteData:[DataManager dataForObject:vehicle] toCurrentUserForKey:@"vehicle" withCompletionBlock:completionBlock];
}


@end
