//
//  ProfileSetupTableViewCell.m
//  Louis
//
//  Created by Giang Christian on 18/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ProfileSetupTableViewCell.h"

@implementation ProfileSetupTableViewCell

//- (void)configureCellWithType:(TypedefEnumSignUpProfileCellType) cellType
//{
//    //    self->_type = cellType;
//    //
//    NSString *localizedLabelKey       = [NSString stringWithFormat:@"Vehicle-Setup-Label-%lu", (unsigned long)cellType];
//    NSString *localizedPlaceholderKey = [NSString stringWithFormat:@"Vehicle-Setup-Placeholder-%lu", (unsigned long)cellType];
//    [self.profileLabel setText:NSLocalizedString(localizedLabelKey, nil)];
//    [self.profileTextField setPlaceholder:NSLocalizedString(localizedPlaceholderKey, nil)];
//    
//    switch (cellType)
//    {
//            [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//            
//        case TypedefEnumSignUpProfileCellTypeFirstName : case TypedefEnumSignUpProfileCellTypeLastName :
//            [self.profileTextField setKeyboardType:UIKeyboardTypeDefault];
//            [self.profileTextField setReturnKeyType:UIReturnKeyNext];
//            break;
//        case TypedefEnumSignUpProfileCellTypePhoneNumber:
//            [self.profileTextField setKeyboardType:UIKeyboardTypeDecimalPad];
//            [self.profileTextField setReturnKeyType:UIReturnKeyNext];
//            break;
//        case TypedefEnumSignUpProfileCellTypeEmail:
//            [self.profileTextField setKeyboardType:UIKeyboardTypeDefault];
//            [self.profileTextField setReturnKeyType:UIReturnKeyDone];
//            break;
//        case TypedefEnumSignUpProfileCellTypePassword:
//            [self.profileTextField setKeyboardType:UIKeyboardTypeDefault];
//            [self.profileTextField setReturnKeyType:UIReturnKeyDone];
//            break;
//    }
//}

@end
