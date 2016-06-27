//
//  VehicleSetupTableViewCell.m
//  Louis
//
//  Created by Thibault Le Cornec on 29/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "VehicleSetupTableViewCell.h"
#import "Common.h"

@implementation VehicleSetupTableViewCell


- (void)configureCellWithType:(VehicleSetupTableViewCellType)cellType
{
    _type = cellType;
    
    NSString *localizedLabelKey       = [NSString stringWithFormat:@"Vehicle-Setup-Label-%lu", (unsigned long)cellType];
    NSString *localizedPlaceholderKey = [NSString stringWithFormat:@"Vehicle-Setup-Placeholder-%lu", (unsigned long)cellType];
    [[self label] setText:NSLocalizedString(localizedLabelKey, nil)];
    [[self txtField] setPlaceholder:NSLocalizedString(localizedPlaceholderKey, nil)];

    switch (cellType)
    {
        case VehicleSetupTableViewCellTypeBrand :
        case VehicleSetupTableViewCellTypeModel :
            [self setSelectionStyle:UITableViewCellSelectionStyleNone];
            [[self txtField] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [[self txtField] setKeyboardType:UIKeyboardTypeDefault];
            [[self txtField] setReturnKeyType:UIReturnKeyNext];
            break;
            
        case VehicleSetupTableViewCellTypeColor:
            [[self txtField] setEnabled:NO];
            [[self txtField] setRightViewMode:UITextFieldViewModeAlways];
            [[self txtField] setTintColor:[UIColor louisLabelColor]];
            [[self txtField] setRightView:[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ArrowDown"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]]];
            break;
            
        case VehicleSetupTableViewCellTypePlate:
            [self setSelectionStyle:UITableViewCellSelectionStyleNone];
            [[self txtField] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
            [[self txtField] setKeyboardType:UIKeyboardTypeNamePhonePad];
            [[self txtField] setReturnKeyType:UIReturnKeyDone];
            break;
            
        default: NSLog(@"***** ERROR : Type \"VehicleSetupTableViewCellNumberOfCells\" is not for configure cell!");
            break;
    }
}

@end
