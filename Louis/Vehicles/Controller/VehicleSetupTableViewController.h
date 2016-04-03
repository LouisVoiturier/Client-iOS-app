//
//  VehicleSetupTableViewController.h
//  Louis
//
//  Created by Thibault Le Cornec on 29/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

@import UIKit;
@class Vehicle;


@protocol VehiculeSetupDelegate <NSObject>

@required
- (void)modelListUpdatedAtIndexPath:(NSIndexPath *)indexUpdated;

@end



@interface VehicleSetupTableViewController : UITableViewController <UITableViewDataSource,
                                                                    UITableViewDelegate,
                                                                    UITextFieldDelegate,
                                                                    UIPickerViewDataSource,
                                                                    UIPickerViewDelegate>

@property (strong, nonatomic) Vehicle *vehicleInEdition;
@property (strong, nonatomic) NSIndexPath *vehicleInEditionIndexPath;
@property (strong, nonatomic) id <VehiculeSetupDelegate> delegate;
@property (nonatomic) BOOL shouldShowDeleteButton;

@end