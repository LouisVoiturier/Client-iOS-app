//
//  VehicleTableViewController.h
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

@import UIKit;
#import "VehicleSetupTableViewController.h"


@interface VehiclesTableViewController : UITableViewController <VehicleSetupDelegate>

/* **********
   Properties
   ********** */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end
