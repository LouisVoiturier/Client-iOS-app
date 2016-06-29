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



#pragma mark - Macros
/* ******
   MACROS
   ****** */
#define NB_COMPONENT 1



#pragma mark - Static Properties
/* *****************
   STATIC PROPERTIES
   ***************** */

/** Cell identifier for standard cell (UILabel + UITextField) */
static NSString *kTxtFieldCellID = @"vehicleSetupTxtFieldCell";
/** Cell Identifier for picker cell */
static NSString *kPickerCellID = @"vehicleSetupColorPickerCell";


/** Enum for TableView Sections */
typedef NS_ENUM(NSUInteger, VehicleSetupTableViewSection)
{
    VehicleSetupTableViewSectionForm,
    VehicleSetupTableViewSectionNumberOfSections
};





#pragma mark - Private Vars & Properties
/* *************************
   PRIVATE VARS & PROPERTIES
   ************************* */

@interface VehicleSetupTableViewController ()
{
    /** Index of the current selected color */
    NSInteger selectedColorIndex;
    
    /** IndexPath where pickerView is shown in tableView */
    NSIndexPath  *pickerIndexPath;
    
    /** Array with all textFields of the form */
    NSArray *setupTextFields;
    
    /** PickerView object to choose color of vehicle */
    UIPickerView *pickerViewColor;
    
    /** View of the Save button in footer */
    BigButtonView *bigButtonView;
}
@end





@implementation VehicleSetupTableViewController

#pragma mark - Controller Lifecycle
/* ********************
   CONTROLLER LIFECYCLE
   ******************** */

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSMutableArray *mutableTempArray = [[NSMutableArray alloc] init];
    NSArray *visibleCells = [[self tableView] visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        if ([cell isKindOfClass:[VehicleSetupTableViewCell class]]) {
            [mutableTempArray addObject:[(VehicleSetupTableViewCell*)cell txtField]];
        } else if ([cell isKindOfClass:[VehicleSetupPickerCell class]]) {
            pickerViewColor = [(VehicleSetupPickerCell*)cell colorPicker];
        }
    }
    setupTextFields = [mutableTempArray copy];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
    /* Save Button */
    bigButtonView = [BigButtonView bigButtonViewTypeMainWithTitle:NSLocalizedString(@"Vehicle-Setup-Button-Title", nil)];
    [[bigButtonView button] addTarget:self action:@selector(saveVehicleButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [[self tableView] setTableFooterView:bigButtonView];
    
    /* Row Height */
    /* Needed for the color picker cell */
    [[self tableView] setEstimatedRowHeight:44.f];
    [[self tableView] setRowHeight:UITableViewAutomaticDimension];

    /* Gesture Recognizer */
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle)];
    [tapGesture setCancelsTouchesInView:NO];
    [[self tableView] addGestureRecognizer:tapGesture];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[[self navigationController] navigationBar] setTintColor:[UIColor louisMainColor]];
    [[self navigationItem] setLeftBarButtonItem:nil];
    [[self navigationItem] setRightBarButtonItem:nil];
    
    pickerIndexPath = nil;
    selectedColorIndex = 0;
    
    //  If view is in edition mode, values from vehicle are put in the textFields
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
        [colorTxtField setText:[VehicleColorsDataSource colorLocalizedNameForColorKeyName:[_vehicleInEdition color]]];
        selectedColorIndex = [[VehicleColorsDataSource colorsKeysNames] indexOfObject:[_vehicleInEdition color]];
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
    if (![self isInEdition]) {
        [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeBrand] becomeFirstResponder];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
    if ([self pickerIsShown]) {
        [self closeColorPicker];
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (UITextField *txtField in setupTextFields) {
        [txtField setText:nil];
    }
}


- (void)cancelAdd
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return VehicleSetupTableViewSectionNumberOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return VehicleSetupTableViewCellNumberOfCells + ([self pickerIsShown] ? 1 : 0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([self pickerIsShown] && indexPath.row == pickerIndexPath.row) {
        /* Picker Cell  */
        VehicleSetupPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:kPickerCellID];
        [[pickerCell colorPicker] setDataSource:self];
        [[pickerCell colorPicker] setDelegate:self];
        [[pickerCell colorPicker] selectRow:selectedColorIndex inComponent:0 animated:NO];
        [pickerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell = pickerCell;
    } else {
        /* TextField Cell */
        NSUInteger indexForConfiguration = indexPath.row;
        if ([self pickerIsShown] && indexForConfiguration >= pickerIndexPath.row) {
            indexForConfiguration -= 1;
        }
        
        VehicleSetupTableViewCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:kTxtFieldCellID];
        [textFieldCell configureCellWithType:indexForConfiguration];
        [[textFieldCell txtField] setDelegate:self];
        
        cell = textFieldCell;
    }
    
    return cell;
}





#pragma mark - TableView Delegate

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
                [self closeColorPicker];
            } else {
                [self openColorPicker];
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
    return [VehicleColorsDataSource numberOfColors];
}





#pragma mark - TableView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [VehicleColorsDataSource localizedNameForColorIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    selectedColorIndex = row;
    [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeColor] setText:[VehicleColorsDataSource localizedNameForColorIndex:selectedColorIndex]];
    
    [self enableSaveButtonIfPossible];
}





#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType] == UIReturnKeyNext) {
        NSUInteger indexOfNextTextField = [setupTextFields indexOfObject:textField]+1;
        VehicleSetupTableViewCell *setupCell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexOfNextTextField inSection:0]];
        
        if ([setupCell type] == VehicleSetupTableViewCellTypeColor) {
            [textField resignFirstResponder];
            [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForItem:indexOfNextTextField inSection:VehicleSetupTableViewSectionForm] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:[self tableView] didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:indexOfNextTextField inSection:VehicleSetupTableViewSectionForm]];
        } else {
            [[setupTextFields objectAtIndex:indexOfNextTextField] becomeFirstResponder];
        }
    } else if ([textField returnKeyType] == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:textField];
}


- (void)UITextFieldTextDidChange:(NSNotification*)notification
{
    [self enableSaveButtonIfPossible];
}





#pragma mark - Save Vehicle

- (void)saveVehicleButtonTouched:(UIButton *)sender
{
    if ([self pickerIsShown]) {
        [self closeColorPicker];
    }
    
    /* Get (possible) new values for vehicle */
    NSString *brand = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeBrand] text];
    NSString *model = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeModel] text];
    NSString *localizedColor = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeColor] text];
    NSString *color = [[[VehicleColorsDataSource colorsLocalizedNames] allKeysForObject:localizedColor] firstObject];
    NSString *numberPlate = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypePlate] text];
  
    if ([self isInEdition]) {
        /* Update information of vehicle currently in edition */
        [_vehicleInEdition setBrand:brand];
        [_vehicleInEdition setModel:model];
        [_vehicleInEdition setColor:color];
        [_vehicleInEdition setNumberPlate:numberPlate];
        
        /* Send data to DataManager */
        [DataManager editVehicle:_vehicleInEdition withCompletionBlock:
         ^(User *user, NSHTTPURLResponse *httpResponse, NSError *error) {
             if (httpResponse.statusCode != 200) {
                 [HTTPResponseHandler handleHTTPResponse:httpResponse
                                             withMessage:@""
                                           forController:(UIViewController*)_delegate
                                          withCompletion:nil];
             } else {
                 if ([_delegate respondsToSelector:@selector(modelListUpdatedForType:atIndexPath:)]) {
                     [_delegate modelListUpdatedForType:VehiclesModelUpdateTypeEdit atIndexPath:nil];
                 }
             }
         }];
        
        /* Back to vehicles list */
        [[self navigationController] popViewControllerAnimated:YES];
    } else {
        /* Send data to DataManager */
        [DataManager addVehicle:[[Vehicle alloc] initWithBrand:brand
                                                         model:model
                                                         color:color
                                                andNumberPlate:numberPlate] withCompletionBlock:
         ^(User *user, NSHTTPURLResponse *httpResponse, NSError *error) {
            if (httpResponse.statusCode != 200) {
                [HTTPResponseHandler handleHTTPResponse:httpResponse
                                            withMessage:@""
                                          forController:(UIViewController*)_delegate
                                         withCompletion:nil];
            } else {
                if ([_delegate respondsToSelector:@selector(modelListUpdatedForType:atIndexPath:)]) {
                    [_delegate modelListUpdatedForType:VehiclesModelUpdateTypeAdd atIndexPath:nil];
                }
            }
         }];
        
        /* Back to vehicles list */
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}





#pragma mark - Delete Vehicle

- (void)deleteVehicle
{
    UIAlertController *deleteConfirmationAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Vehicle-Delete-Alert-Title", nil)
                                                                                     message:NSLocalizedString(@"Vehicle-Delete-Alert-Message", nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionNO  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Vehicle-Delete-Alert-Action-No", nil)  style:UIAlertActionStyleCancel      handler:nil];
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:NSLocalizedString(@"Vehicle-Delete-Alert-Action-Yes", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                    [DataManager deleteVehicle:_vehicleInEdition withCompletionBlock:
                                        ^(User *user, NSHTTPURLResponse *httpResponse, NSError *error) {
                                            if (httpResponse.statusCode != 200) {
                                                [HTTPResponseHandler handleHTTPResponse:httpResponse
                                                                            withMessage:@""
                                                                          forController:(UIViewController*)_delegate
                                                                         withCompletion:nil];
                                            } else {
                                                if ([_delegate respondsToSelector:@selector(modelListUpdatedForType:atIndexPath:)]) {
                                                    [_delegate modelListUpdatedForType:VehiclesModelUpdateTypeDelete atIndexPath:_vehicleInEditionIndexPath];
                                                }
                                            }
                                        }];
                                    [[self navigationController] popViewControllerAnimated:YES];
                                }];
    [deleteConfirmationAlert addAction:actionNO];
    [deleteConfirmationAlert addAction:actionYES];
    
    [self presentViewController:deleteConfirmationAlert animated:YES completion: ^{
         [GAI sendScreenViewWithName:@"Delete Car"];
     }];
    deleteConfirmationAlert = nil;
}





#pragma mark - Utilities / Miscellaneous

/** Dismiss keyboard when user touch out of the table view */
- (void)tapGestureHandle
{
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


- (CALayer *)colorCellArrowLayer
{
    return [[[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeColor] rightView] layer];
}


- (void)openColorPicker
{
    [[self tableView] beginUpdates];
    [Tools rotateLayer:[self colorCellArrowLayer] fromStartingDegree:0.0 toArrivalDegree:M_PI inSeconds:0.3];
    pickerIndexPath = [NSIndexPath indexPathForItem:VehicleSetupTableViewCellTypeColor+1 inSection:VehicleSetupTableViewSectionForm];
    [[self tableView] insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [[self tableView] endUpdates];
}


- (void)closeColorPicker
{
    [[self tableView] beginUpdates];
    [Tools rotateLayer:[self colorCellArrowLayer] fromStartingDegree:M_PI toArrivalDegree:0.0 inSeconds:0.3];
    [[self tableView] deleteRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    pickerIndexPath = nil;
    [[self tableView] endUpdates];
}


/** Check if fields are filled and if save button can be enable */
- (void)enableSaveButtonIfPossible
{
    BOOL shouldEnableButton= NO;
    
    NSString *brand = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeBrand] text];
    NSString *model = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeModel] text];
    NSString *color = [[setupTextFields objectAtIndex:VehicleSetupTableViewCellTypeColor] text];
    
    if (   brand != nil && brand.length > 0
        && model != nil && model.length > 0
        && color != nil && color.length > 0) {
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
//    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
//    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
//
//    if (regExMatches == 0) {
//        return NO;
//    } else {
//        return YES;
//    }
//
//    return YES;
//}

@end
