//
//  SignUpProfileTableViewController.h
//  Louis
//
//  Created by Giang Christian on 01/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface SignUpProfileTableViewController : UITableViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate >

@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *password;

@end
