//
//  ProfileTableViewController.h
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewController : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate >
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property NSString *titre;
@property NSMutableArray *clientProfile;
@property NSMutableArray *clientProfileLabel;


typedef NS_ENUM (NSInteger, TypedefEnumSignUpProfileCellType) {
    TypedefEnumSignUpProfileCellTypeFirstName,
    TypedefEnumSignUpProfileCellTypeLastName,
    TypedefEnumSignUpProfileCellTypePhoneNumber,
    TypedefEnumSignUpProfileCellTypeEmail,
    TypedefEnumSignUpProfileCellTypePassword,
    TypedefEnumSignUpProfileCellTypeDisconnectButton
};

@end
