//
//  DataManager+User_Vehicles.h
//  Louis
//
//  Created by Thibault Le Cornec on 12/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager+User.h"
#import "Vehicle.h"


@interface DataManager (User_Vehicles)

+ (NSArray *)userVehicles;
+ (void)addVehicle:   (Vehicle *)vehicle withCompletionBlock:(dataPostCompletion)completionBlock;
+ (void)modifyVehicle:(Vehicle *)vehicle withCompletionBlock:(dataPostCompletion)completionBlock;
+ (void)deleteVehicle:(Vehicle *)vehicle withCompletionBlock:(dataPostCompletion)completionBlock;

@end
