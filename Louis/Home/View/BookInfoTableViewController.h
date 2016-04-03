//
//  BookInfoTableViewController.h
//  Louis
//
//  Created by François Juteau on 09/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookInfoTableViewController : UITableViewController

/**********************/
/***** PROPERTIES *****/
/**********************/

@property (nonatomic, strong) UIPickerView *pickerView;


/*******************/
/***** METHODS *****/
/*******************/
#pragma mark - Extern methods

// Change la valeur de la cell selectionné avant la validation de la valeur du picker
-(void)changeCurrentSelectedRowValueToPickerValue;

-(void)reloadData;

@end
