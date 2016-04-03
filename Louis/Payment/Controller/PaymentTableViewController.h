//
//  PaymentTableViewController.h
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property NSString *titre;


#pragma mark - Segues

-(IBAction)unwindAfterValidating:(UIStoryboardSegue *)segue;


@end
