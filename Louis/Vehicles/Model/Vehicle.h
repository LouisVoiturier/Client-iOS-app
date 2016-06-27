//
//  Vehicle.h
//  Louis
//
//  Created by Thibault Le Cornec on 25/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleColorsDataSource.h"

@interface Vehicle : NSObject


/* **********
   Properties
   ********** */

@property (nonatomic, copy) NSString *vehicleID;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *numberPlate;



/* *******
   Methods
   ******* */

/* Methods for DataManager */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;


/* Methods for ViewControllers */
- (instancetype)initWithBrand:(NSString *)brand
                        model:(NSString *)model
                        color:(NSString *)color
               andNumberPlate:(NSString *)numberPlate;


- (NSString *)infosResume;

@end
