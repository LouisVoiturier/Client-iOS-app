//
//  VehicleSetupTableViewController.n
//  Louis
//
//  Created by Thibault Le Cornec on 29/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "VehicleSetupTableViewController.h"
#import "VehicleSetupTableViewCell.h"
#import "VehicleSetupPickerCell.h"
#import "Common.h"
#import "DataManager+User_Vehicles.h"





#pragma mark - ##### Define Macro #####
// ********************************** //
// ---------- DEFINE MACRO ---------- //
// ********************************** //

#define NB_SECTIONS 1
#define NB_ROWS 4
#define NB_COMPONENT 1





#pragma mark - Static Properties
// *************************************** //
// ---------- STATIC PROPERTIES ---------- //
// *************************************** //

/** Cell identifier for standard cell (UILabel + UITextField) */
static NSString *kTxtFieldCellID = @"vehicleSetupTxtFieldCell";
/** Cell Identifier for picker cell */
static NSString *kPickerCellID = @"vehicleSetupColorPickerCell";





#pragma mark - Private Vars & Properties
// *********************************************** //
// ---------- PRIVATE VARS & PROPERTIES ---------- //
// *********************************************** //

@interface VehicleSetupTableViewController ()
{
    NSMutableArray *setupTextFields;
    BigButtonView *bigButtonView;
    UIPickerView *pickerViewColor;
    NSIndexPath  *pickerIndexPath;
    NSInteger selectedColorIndex;
    NSArray *pickerDataSource;
}
@end





@implementation VehicleSetupTableViewController

#pragma mark - Controller Lifecycle
// ****************************************** //
// ---------- CONTROLLER LIFECYCLE ---------- //
// ****************************************** //


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    setupTextFields = [[NSMutableArray alloc] init];
    NSArray *visibleCells = [[self tableView] visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        if ([cell isKindOfClass:[VehicleSetupTableViewCell class]]) {
            [setupTextFields addObject:[(VehicleSetupTableViewCell*)cell txtField]];
        } else if ([cell isKindOfClass:[VehicleSetupPickerCell class]]) {
            pickerViewColor = [(VehicleSetupPickerCell*)cell colorPicker];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ---------- Init UI ---------- //
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
    // ----- Save Button -----
    bigButtonView = [BigButtonView bigButtonViewTypeMainWithTitle:NSLocalizedString(@"Vehicle-Setup-Button-Title", nil)];
    [[bigButtonView button] addTarget:self action:@selector(saveVehicleButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [[self tableView] setTableFooterView:bigButtonView];
    
    // ----- Row Height -----
    // Needed for the color picker cell
    [[self tableView] setEstimatedRowHeight:44.f];
    [[self tableView] setRowHeight:UITableViewAutomaticDimension];

    // ----- Gesture Recognizer -----
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle)];
    [tapGesture setCancelsTouchesInView:NO];
    [[self tableView] addGestureRecognizer:tapGesture];
    
    // ---------- Init Data ---------- //
    pickerDataSource = @[[NSNull null], @"Blanc", @"Noir", @"Gris", @"Rouge",
                         @"Bleu", @"Jaune", @"Vert", @"Marron", @"Autre"];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[[self navigationController] navigationBar] setTintColor:[UIColor louisMainColor]];
    [[self navigationItem] setLeftBarButtonItem:nil];
    [[self navigationItem] setRightBarButtonItem:nil];
    
    pickerIndexPath = nil;
    selectedColorIndex = 0;
    
    //  If view is in edition mode, values from vehicle are put in the text field
    if ([self isInEdition]) {
        [GAI sendScreenViewWithName:@"Edit Car"];
        
        [self setTitle:[NSLocalizedString(@"Vehicle-Setup-View-Title-Edit", nil) uppercaseString]];
        
        if (_shouldShowDeleteButton) {
            [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Vehicle-Setup-View-RightBarButton-Edit", nil)
                                                                                          style:UIBarButtonItemStylePlain
                                                                                         target:self
                                                                                         action:@selector(deleteVehicle)]];
        }
        
        UITextField *brandTxtField = [setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeBrand];
        UITextField *modelTxtField = [setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeModel];
        UITextField *colorTxtField = [setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeColor];
        UITextField *plateTxtField = [setupTextFields objectAtIndex:VehicleSetupTableViewCellTypePlate];
        
        [brandTxtField setText:[_vehicleInEdition brand]];
        [modelTxtField setText:[_vehicleInEdition model]];
        selectedColorIndex = [pickerDataSource indexOfObject:[_vehicleInEdition color]];
        if (selectedColorIndex != NSNotFound) {
            [colorTxtField setText:[pickerDataSource objectAtIndex:selectedColorIndex]];
        }
        [plateTxtField setText:[_vehicleInEdition numberPlate]];
        
        [[bigButtonView button] setEnabled:YES];
    } else {
        [GAI sendScreenViewWithName:@"Add Car"];
        
        [self setTitle:[NSLocalizedString(@"Vehicle-Setup-View-Title-Add", nil) uppercaseString]];
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Vehicle-Setup-View-RightBarButton-Cancel", nil)
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(cancelAdd)]];
        [pickerViewColor selectRow:0 inComponent:0 animated:NO];
        [[bigButtonView button] setEnabled:NO];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isInEdition] == NO) {
        [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeBrand] becomeFirstResponder];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self pickerIsShown]) {
        [[self tableView] beginUpdates];
        [[self tableView] deleteRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        pickerIndexPath = nil;
        [[self tableView] endUpdates];
    }
    
    // Reset text in text fields
    for (UITextField *txtField in setupTextFields) {
        [txtField setText:nil];
    }
}





#pragma mark - Object Edition
// ************************************ //
// ---------- OBJECT EDITION ---------- //
// ************************************ //
- (void)deleteVehicle
{
    
    UIAlertController *deleteConfirmationAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Vehicle-Delete-Alert-Title", nil)
                                                                                     message:NSLocalizedString(@"Vehicle-Delete-Alert-Message", nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionNO  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Vehicle-Delete-Alert-Action-No", nil)  style:UIAlertActionStyleCancel      handler:nil];
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:NSLocalizedString(@"Vehicle-Delete-Alert-Action-Yes", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [DataManager deleteVehicle:_vehicleInEdition withCompletionBlock:
                                        ^(User *user, NSHTTPURLResponse *httpResponse, NSError *error) {
                                            if (httpResponse.statusCode != 200) {
                                                [HTTPResponseHandler handleHTTPResponse:httpResponse
                                                                            withMessage:@""
                                                                          forController:self
                                                                         withCompletion:nil];
                                            } else {
                                                if ([_delegate respondsToSelector:@selector(modelListUpdatedForType:atIndexPath:)]) {
                                                    [_delegate modelListUpdatedForType:VehiclesModelUpdateTypeDelete atIndexPath:_vehicleInEditionIndexPath];
                                                }
                                            }
                                        }];
                                
//                                    NSMutableArray *userVehiclesMutable = [userVehicles mutableCopy];
//                                    [userVehiclesMutable removeObjectAtIndex:indexPath.row];
//                                    userVehicles = [userVehiclesMutable copy];
                                    
                                    [[self tableView] endUpdates];
                                    [[self navigationController] popViewControllerAnimated:YES];
                                }];
    
    [deleteConfirmationAlert addAction:actionNO];
    [deleteConfirmationAlert addAction:actionYES];
    
    [self presentViewController:deleteConfirmationAlert animated:YES completion:
    ^{
        [GAI sendScreenViewWithName:@"Delete Car"];
     }];
    deleteConfirmationAlert = nil;
    
    
    
    
//    [[self navigationController] popToRootViewControllerAnimated:YES];
    
}


- (void)cancelAdd
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NB_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self pickerIsShown]){
        return NB_ROWS+1;
    } else {
        return NB_ROWS;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([self pickerIsShown] && indexPath.row == pickerIndexPath.row) {
        // ===== Picker Cell ===== //
     
         VehicleSetupPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:@"vehicleSetupColorPickerCell"];
        
        if (pickerCell == nil) {
            pickerCell = [[VehicleSetupPickerCell alloc] initWithStyle:-1 reuseIdentifier:kPickerCellID];
        }
        
        [[pickerCell colorPicker] setDataSource:self];
        [[pickerCell colorPicker] setDelegate:self];
        [pickerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[pickerCell colorPicker] selectRow:selectedColorIndex inComponent:0 animated:NO];
        
        cell = pickerCell;
    } else {
        // ===== TextField Cell ===== //
        
        VehicleSetupTableViewCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:kTxtFieldCellID];
        
        NSUInteger indexForConfiguration = indexPath.row;
        if ([self pickerIsShown] && indexForConfiguration >= pickerIndexPath.row) {
            indexForConfiguration -= 1;
        }
        
        if (textFieldCell == nil) {
            textFieldCell = [[VehicleSetupTableViewCell alloc] initWithStyle:-1 reuseIdentifier:kTxtFieldCellID];
            [setupTextFields replaceObjectAtIndex:indexForConfiguration withObject:[textFieldCell txtField]];
        }
        
        [textFieldCell configureCellWithType:indexForConfiguration];
        [[textFieldCell txtField] setDelegate:self];
        
        cell = textFieldCell;
    }
    
    return cell;
}





#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != pickerIndexPath.row)
    {
        if (indexPath.row == VehicleSetupTableViewCellTypeColor) {
            [[self tableView] beginUpdates];
            [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
            if ([self pickerIsShown]) {
                [Tools rotateLayer:[[[[[self tableView] cellForRowAtIndexPath:indexPath] txtField] rightView] layer]
                fromStartingDegree:M_PI
                   toArrivalDegree:0.0
                         inSeconds:0.3];
                [[self tableView] deleteRowsAtIndexPaths:@[pickerIndexPath]
                                        withRowAnimation:UITableViewRowAnimationMiddle];
                pickerIndexPath = nil;
            } else if (![self pickerIsShown]) {
                [Tools rotateLayer:[[[[[self tableView] cellForRowAtIndexPath:indexPath] txtField] rightView] layer]
                fromStartingDegree:0.0
                   toArrivalDegree:M_PI
                         inSeconds:0.3];
                pickerIndexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
                [tableView insertRowsAtIndexPaths:@[pickerIndexPath]
                                 withRowAnimation:UITableViewRowAnimationMiddle];

            }
            [tableView endUpdates];
        } else {
            VehicleSetupTableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
            if ([cellSelected type] != VehicleSetupTableViewCellTypeColor) {
                [[cellSelected txtField] becomeFirstResponder];
            }
        }
    }
}





#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return NB_COMPONENT;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerDataSource count];
}





#pragma mark - Table view delegate

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    selectedColorIndex = row;
    VehicleSetupTableViewCell *cellColor = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForItem:pickerIndexPath.row-1 inSection:0]];
    
    if ([[pickerDataSource objectAtIndex:selectedColorIndex] isEqual:[NSNull null]] == NO) {
        [[cellColor txtField] setText:[pickerDataSource objectAtIndex:selectedColorIndex]];
    } else {
        [[cellColor txtField] setText:nil];
    }
    
    [self enableSaveButtonIfPossible];
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if ([[pickerDataSource objectAtIndex:row] isEqual:[NSNull null]] == NO) {
        return [pickerDataSource objectAtIndex:row];
    }
    
    return nil;
}





#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType] == UIReturnKeyNext) {
        NSUInteger indexOfNextTextField = [setupTextFields indexOfObject:textField]+1;
        VehicleSetupTableViewCell *setupCell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexOfNextTextField inSection:0]];
        
        if ([setupCell type] == VehicleSetupTableViewCellTypeColor) {
            [textField resignFirstResponder];
            [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForItem:indexOfNextTextField inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:[self tableView] didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:indexOfNextTextField inSection:0]];
        } else {
            [[setupTextFields objectAtIndex:indexOfNextTextField] becomeFirstResponder];
        }
    } else if ([textField returnKeyType] == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    
    [self enableSaveButtonIfPossible];
    
    return YES;
}


//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self enableSaveButtonIfPossible];
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [self enableSaveButtonIfPossible];

//    return YES;
//}






#pragma mark - Backup objet

- (void)saveVehicleButtonTouched:(UIButton *)sender
{
    NSLog(@"// ===== Ajout/Modification d'une voiture demandée !! ===== //");
    
    if ([self pickerIsShown]) {
        [[self tableView] beginUpdates];
        [[self tableView] deleteRowsAtIndexPaths:@[pickerIndexPath]
                                withRowAnimation:UITableViewRowAnimationMiddle];
        pickerIndexPath = nil;
        [[self tableView] endUpdates];
    }
    
    // Récupération des (posssible) nouvelles valeurs pour le véhicule
    NSString *brand       = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeBrand] text];
    NSString *model       = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeModel] text];
    NSString *color       = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeColor] text];
    NSString *numberPlate = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypePlate] text];
  
    if ([self isInEdition]) {
        [_vehicleInEdition setBrand:brand];
        [_vehicleInEdition setModel:model];
        [_vehicleInEdition setColor:color];
        [_vehicleInEdition setNumberPlate:numberPlate];
        
        // Envoi au DataManager
        [DataManager editVehicle:_vehicleInEdition withCompletionBlock:^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
         {
             if (httpResponse.statusCode != 200) {
                 [HTTPResponseHandler handleHTTPResponse:httpResponse
                                             withMessage:@""
                                           forController:self
                                          withCompletion:nil];
             } else {
                 if ([_delegate respondsToSelector:@selector(modelListUpdatedForType:atIndexPath:)]) {
                     [_delegate modelListUpdatedForType:VehiclesModelUpdateTypeEdit atIndexPath:nil];
                 }
             }
         }];
        
        
//        [[self navigationController] popToRootViewControllerAnimated:YES];
        [[self navigationController] popViewControllerAnimated:YES];
    } else {
        [DataManager addVehicle:[[Vehicle alloc] initWithBrand:brand
                                                         model:model
                                                         color:color
                                                andNumberPlate:numberPlate] withCompletionBlock:
         ^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
        {
            if (httpResponse.statusCode != 200) {
                [HTTPResponseHandler handleHTTPResponse:httpResponse
                                            withMessage:@""
                                          forController:self
                                         withCompletion:nil];
            } else {
                if ([_delegate respondsToSelector:@selector(modelListUpdatedForType:atIndexPath:)]) {
                    [_delegate modelListUpdatedForType:VehiclesModelUpdateTypeAdd atIndexPath:nil];
                }
            }
         }];
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}





#pragma mark - Utilities / Miscellaneous

/**
 *  Dismiss keyboard when user touch out of the table view
 */
- (void)tapGestureHandle
{
    // Dismiss Keyboard
    [[self view] endEditing:YES];
}


- (BOOL)isInEdition
{
    return _vehicleInEdition != nil;
}


- (BOOL)pickerIsShown
{
    return pickerIndexPath != nil;
}



- (void)enableSaveButtonIfPossible
{
    BOOL shouldEnableButton= NO;
    
    NSString *brand = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeBrand] text];
    NSString *model = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeModel] text];
    NSString *color = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeColor] text];
    
    if (brand != nil && [brand isEqualToString:@""]==NO && model != nil && [model isEqualToString:@""]==NO && color != nil && [color isEqualToString:@""]==NO) {
        shouldEnableButton = YES;
    }

    [[bigButtonView button] setEnabled:shouldEnableButton];
}


//- (BOOL)validFields:(NSString*)plateNumberString
//{
//    if([plateNumberString length]==0)
//    {
//        return NO;
//    }
//    
//    NSString *oldPlateRegex = @"^[0-9]{3,4}-[A-Z]{2,3}-[0-9]{2}$";
//    NSString *newPlateRegex = @"^[A-Z]{2}-[0-9]{3}-[A-Z]{2}$";
//    
//    NSPredicate *oldPlateNumberVerification = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", oldPlateRegex];
//    NSPredicate *newPlateNumberVerification = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", newPlateRegex];
//    
//    if ([oldPlateNumberVerification evaluateWithObject:plateNumberString] != YES ||
//        [newPlateNumberVerification evaluateWithObject:plateNumberString] != YES)
//    {
//        UIAlertController *errorPlateNumberFormat = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"", nil) message:NSLocalizedString(@"", nil) preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *buttonOK = [UIAlertAction actionWithTitle:NSLocalizedString(@"", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//        {
//            
//        }];
//        
//        [errorPlateNumberFormat addAction:buttonOK];
//    }
//    
////    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
////    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
////    
////    NSLog(@"%i", regExMatches);
////    if (regExMatches == 0) {
////        return NO;
////    } else {
////        return YES;
////    }
//    
//    return YES;
//}

@end
