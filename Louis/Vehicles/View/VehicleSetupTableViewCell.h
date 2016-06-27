//
//  VehicleSetupTableViewCell.h
//  Louis
//
//  Created by Thibault Le Cornec on 29/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

@import UIKit;


typedef NS_ENUM(NSUInteger, VehicleSetupTableViewCellType)
{
    VehicleSetupTableViewCellTypeBrand,
    VehicleSetupTableViewCellTypeModel,
    VehicleSetupTableViewCellTypeColor,
    VehicleSetupTableViewCellTypePlate,
    VehicleSetupTableViewCellNumberOfCells
};

@interface VehicleSetupTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *txtField;
@property (nonatomic, readonly) VehicleSetupTableViewCellType type;

/**
 *  @brief Configure cell's label and text field according of type.
 *
 *  @param type The cell type. See `VehicleSetupTableViewCellType´ for the possible values.
 *
 */
- (void)configureCellWithType:(VehicleSetupTableViewCellType)type;

@end
