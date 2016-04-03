//
//  MenuTableViewController.h
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MenuTableViewController : UITableViewController

@property NSMutableArray *menu;
@property NSMutableArray *tableauSegueIdentifier;
@property (weak, nonatomic) IBOutlet UILabel *clientName;
@property (weak, nonatomic) IBOutlet UIImageView *clientPicture;
@property (weak, nonatomic) IBOutlet UIView *viewInHeader;
@property UIImage *clientPictureTemp;
@property NSString *clientNameTemp;

@end
