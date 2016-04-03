//
//  SignUpProfileTableViewController.m
//  Louis
//
//  Created by Giang Christian on 01/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "SignUpProfileTableViewController.h"
#import "Common.h"
#import "SignUpProfileTableViewCell.h"
#import "AddPaymentTableViewController.h"
#import "ProfilePictureViewWithButton.h"
#import "DataManager+User.h"
#import "DataManager+User_Vehicles.h"
#import "ResearchPopupView.h"
#import "SignUpProfilePickerTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KeychainWrapper.h"

// TableView
#define NB_SECTION 2
#define NB_ROW_FOR_SECTION_0 3
#define NB_ROW_FOR_SECTION_1 4

// nb de composant dans pickerView
#define NB_COMPONENT 1
#define PICKER_POSITION_IN_TABLEVIEW 2

// clés du dictionnaire dans le NSMutableArray workingArrayForCells
#define kTextField @"textField"
#define kCelltype @"celltype"
#define kLabel @"label"
#define kLabelText @"labelText"
#define kTextField @"textField"
#define kTextFieldPlaceholder @"textFieldPlaceholder"
#define kErrorFlag @"errorFlag"
#define kErrorMsg @"errorMsg"


typedef NS_ENUM (NSInteger, TypedefEnumProfileCellType) {
    TypedefEnumProfileCellTypeFirstName,
    TypedefEnumProfileCellTypeLastName,
    TypedefEnumProfileCellTypePhoneNumber,
    TypedefEnumProfileCellTypeCarBrand,
    TypedefEnumProfileCellTypeCarModel,
    TypedefEnumProfileCellTypeCarColor,
    TypedefEnumProfileCellTypeCarPlate
};


@interface SignUpProfileTableViewController ()
{
//    NSInteger  indexPickerRow;
    NSIndexPath  *pickerIndexPath;
    NSInteger selectedColorIndex;
    NSArray *pickerDataSource;
    BOOL aColorHasBeenSelected ;
    BOOL pickerViewIsShown;
    UIPickerView *myPicker;
}

@property (nonatomic, strong) NSMutableArray *workingArrayForCells;

//@property (nonatomic, strong) NSMutableArray *cellTypesGroupedBySection;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic,strong) ProfilePictureViewWithButton *profilePicture;
@property (nonatomic,strong) BigButtonView *footerView;
@property (nonatomic,strong) ResearchPopupView *RPV;

//@property (nonatomic, strong) NSMutableArray *errorsTable;

@end


@implementation SignUpProfileTableViewController

// Ajout Bar bouton de raccourci à droite pour test dev uniquement
-(IBAction)raccourciGoToAddPayment
{
    [self goToAddPayment];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Sign-Up-Title", nil)];
    aColorHasBeenSelected = NO;
    pickerViewIsShown = NO;
    
    [self.tableView setBackgroundColor:[UIColor louisBackgroundApp]];
   
    // Configure cellule de la tableview
//    [self configureCells];
    [self configureWorkingCells];

    // headerView
    [self addPictureInHeaderView];
    
    // footerView
    [self addButtonInFooterView];

    // Le clavier disparait quand on clique sur l'écran
    [self dismissKeyboardOnTapGesture];

    
//    // Ajout Bar bouton de raccourci à gauche pour test dev uniquement
//    UIBarButtonItem *barBoutonRaccourci = [[UIBarButtonItem alloc]
//                                           initWithTitle:@"raccourci"
//                                           style:UIBarButtonItemStylePlain
//                                           target:self
//                                           action:@selector(raccourciGoToAddPayment)];
//    
//    self.navigationItem.leftBarButtonItem = barBoutonRaccourci;
    
}


-(IBAction)barButtonCancelTouch
{
      [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)dismissKeyboardOnTapGesture
{
    // Le clavier disparait quand on clique sur l'écran
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // attention, la propriété ci-dessous doit absolument être positionné à "NO" sinon on ne passera jamais par le didSelectRowAtIndexPath
    tap.cancelsTouchesInView = NO;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    //suppression bouton back
//    self.navigationItem.leftBarButtonItem=nil;
//    self.navigationItem.hidesBackButton = YES;
    [GAI sendScreenViewWithName:@"Subscription Step 2"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [_firstNameTextField becomeFirstResponder];
//    [[[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeFirstName] objectForKey:@"textField"] becomeFirstResponder];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // enlever le clavier
    [[self view] endEditing:YES];
    
    // Change "back" bar button name for the next viewcontroller
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BackButtonItem-Title",nil)
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:nil
                                                                     action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}



-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    if ([self pickerIsShown])
//    {
//        [[self tableView] beginUpdates];
//        [[self tableView] deleteRowsAtIndexPaths:@[pickerIndexPath]
//                                withRowAnimation:UITableViewRowAnimationMiddle];
//        pickerIndexPath = nil;
//        [[self tableView] endUpdates];
//    }
}



- (BOOL)pickerIsShown
{
    return pickerIndexPath != nil;
}

#pragma mark - Config du menu

// Ajouter un item au menu
-(void)addItemCellType:(NSNumber *)celltype
              andLabel:(UILabel *)label
          andLabelText:(NSString *)labelText
          andTextField:(UITextField *)textField
      andTFPlaceHolder:(NSString *)tfPlaceholder
          andErrorFlag:(NSNumber *)errorFlag
           andErrorMsg:(NSString *)errorMsg

{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    dictionary[kCelltype]  = celltype;
    dictionary[kLabel]     = label;
    dictionary[kLabelText] = labelText;
    dictionary[kTextField] = textField;
    dictionary[kTextFieldPlaceholder] = tfPlaceholder;
    dictionary[kErrorFlag] = errorFlag;
    dictionary[kErrorMsg]  = errorMsg;
    
    [_workingArrayForCells addObject:dictionary];
}



-(void)configureWorkingCells
{
    //_workingArrayForCells est un tableau de dictionnaire contenant des infos des cells de la tableview qu'on va manipuler
    _workingArrayForCells = [[NSMutableArray alloc]init];
    
    [self addItemCellType:@(TypedefEnumProfileCellTypeFirstName)
                 andLabel:nil
             andLabelText:NSLocalizedString(@"Profile-FirstName-Label",nil)
             andTextField:nil
         andTFPlaceHolder:nil
             andErrorFlag:@(NO)
              andErrorMsg:NSLocalizedString(@"SignUpProfile-Check-Firstname-ErrMsg", nil)];
    
    [self addItemCellType:@(TypedefEnumProfileCellTypeLastName)
                 andLabel:nil
             andLabelText:NSLocalizedString(@"Profile-LastName-Label",nil)
             andTextField:nil
         andTFPlaceHolder:nil
             andErrorFlag:@(NO)
              andErrorMsg:NSLocalizedString(@"SignUpProfile-Check-Lastname-ErrMsg", nil)];
    
    [self addItemCellType:@(TypedefEnumProfileCellTypePhoneNumber)
                 andLabel:nil
             andLabelText:NSLocalizedString(@"Profile-PhoneNumber-Label",nil)
             andTextField:nil
         andTFPlaceHolder:NSLocalizedString(@"Profile-PhoneNumber-Placeholder",nil)
             andErrorFlag:@(NO)
              andErrorMsg:NSLocalizedString(@"SignUpProfile-Check-PhoneNumber-ErrMsg", nil)];
    
    [self addItemCellType:@(TypedefEnumProfileCellTypeCarBrand)
                 andLabel:nil
             andLabelText:NSLocalizedString(@"Vehicle-Setup-Label-0",nil)
             andTextField:nil
         andTFPlaceHolder:NSLocalizedString(@"Vehicle-Setup-Placeholder-0",nil)
             andErrorFlag:@(NO)
              andErrorMsg:NSLocalizedString(@"SignUpProfile-Check-VehiculeBrand-ErrMsg", nil)];
    
    [self addItemCellType:@(TypedefEnumProfileCellTypeCarModel)
                 andLabel:nil
             andLabelText:NSLocalizedString(@"Vehicle-Setup-Label-1",nil)
             andTextField:nil
         andTFPlaceHolder:NSLocalizedString(@"Vehicle-Setup-Placeholder-1",nil)
             andErrorFlag:@(NO)
              andErrorMsg:NSLocalizedString(@"SignUpProfile-Check-VehiculeModel-ErrMsg", nil)];
    
    [self addItemCellType:@(TypedefEnumProfileCellTypeCarColor)
                 andLabel:nil
             andLabelText:NSLocalizedString(@"Vehicle-Setup-Label-2",nil)
             andTextField:nil
         andTFPlaceHolder:NSLocalizedString(@"Vehicle-Setup-Placeholder-2",nil)
             andErrorFlag:@(NO)
              andErrorMsg:NSLocalizedString(@"SignUpProfile-Check-VehiculeColor-ErrMsg", nil)];
    
    [self addItemCellType:@(TypedefEnumProfileCellTypeCarPlate)
                 andLabel:nil
             andLabelText:NSLocalizedString(@"Vehicle-Setup-Label-3",nil)
             andTextField:nil
         andTFPlaceHolder:NSLocalizedString(@"Vehicle-Setup-Placeholder-3",nil)
             andErrorFlag:@(NO)
              andErrorMsg:nil];
    
    
    [[self tableView] setEstimatedRowHeight:44.f];
    [[self tableView] setRowHeight:UITableViewAutomaticDimension];
    
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
    
    // ===== Data du pickerview pour le choix des couleurs ===== //
    pickerIndexPath = nil;
    selectedColorIndex = -1;
    pickerDataSource = @[@" ",@"Blanc", @"Noir", @"Gris", @"Rouge", @"Bleu",
                         @"Jaune", @"Vert", @"Marron", @"Autre"];
    
}


//
//- (void)configureCells {
//    
//    _cellTypesGroupedBySection = [[NSMutableArray alloc]init];
//    
//    NSMutableArray *firstSection = [[NSMutableArray alloc]init];
//    [firstSection addObject:@(TypedefEnumProfileCellTypeFirstName)];
//    [firstSection addObject:@(TypedefEnumProfileCellTypeLastName)];
//    [firstSection addObject:@(TypedefEnumProfileCellTypePhoneNumber)];
// 
//    NSMutableArray *secondSection = [[NSMutableArray alloc]init];
//    [secondSection addObject:@(TypedefEnumProfileCellTypeCarBrand)];
//    [secondSection addObject:@(TypedefEnumProfileCellTypeCarModel)];
//    [secondSection addObject:@(TypedefEnumProfileCellTypeCarColor)];
//    [secondSection addObject:@(TypedefEnumProfileCellTypeCarPlate)];
//
//    [self.cellTypesGroupedBySection addObject:firstSection];
//    [self.cellTypesGroupedBySection addObject:secondSection];
//    
//    
//}



-(void) addPictureInHeaderView
{
    /***** Header *****/
    //Ajouter photo et bouton dans headerview
    _profilePicture = [[ProfilePictureViewWithButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.25)];
    [[_profilePicture firstButton]  setTitle:NSLocalizedString(@"SignUpProfile-AddPicture",nil) forState:UIControlStateNormal];
    [[_profilePicture firstButton]  addTarget:self action:@selector(addPictureButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    // Souligne le texte du button
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[_profilePicture firstButton].titleLabel.text];
    [titleString setAttributes:@{NSForegroundColorAttributeName:[UIColor louisMainColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[titleString length])];
    
    [[_profilePicture firstButton] setAttributedTitle: titleString forState:UIControlStateNormal];
    [[_profilePicture firstButton] setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    [self.tableView setTableHeaderView:self.profilePicture];
    
    
    [_profilePicture imageView].userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPictureButtonTouch)];
    [[_profilePicture imageView] addGestureRecognizer:tap];
}


-(void) addButtonInFooterView
{
    //Ajouter le bouton dans le footerview
    
    _footerView = [BigButtonView bigButtonViewTypeMainWithTitle:NSLocalizedString(@"SignUpProfile-Button-Title", nil)];
    [[_footerView button] addTarget:self action:@selector(registerProfileButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [[_footerView button] setEnabled:NO];
    
    [[self tableView] setTableFooterView:_footerView];
}



//===============================================
# pragma mark Appel webservices
//===============================================

-(void) startActivityIndicator
{
    _RPV = [[ResearchPopupView alloc] init];
    [_RPV changeToSearchingStateWithMessage:@"Enregistrement en cours"];
}


-(void) stopActivityIndicator
{
    [_RPV dismiss];
}


- (void)registerProfileButtonTouch
{
    [[_footerView button] setEnabled:NO];
   
    //Vérifie les formats des firstname, lastname, etc ...
    [self checkFormatFirstname] ;
    [self checkFormatLastname] ;
    [self checkFormatPhoneNumber] ;
    [self checkFormatVehiculeBrand] ;
    [self checkFormatVehiculeModel] ;
    [self checkSelectedColor] ;
    
    // calculer le nombre d'erreur
    NSUInteger nbError = 0;
    NSUInteger nbRow = [_workingArrayForCells count];
    
    for (int i=0; i < nbRow ;i++)
    {
        if ([[[_workingArrayForCells objectAtIndex:i] objectForKey:@"errorFlag"] boolValue] == YES)
        {
            nbError ++;
        }
    }

    // Pas d'erreur
    if (nbError == 0)
    {
        [self startActivityIndicator];

        // Pas d'erreur de format
        // Appel au WS SignUp
        self.picture = @"http://monimage.png";
        
        NSLog(@"Avant DataManager signUpWithUsername self.email:%@ ; self.password :%@",self.email, self.password);
        UITextField * firstNameTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeFirstName] objectForKey:@"textField"];
        UITextField * lastNameTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeLastName] objectForKey:@"textField"];
        UITextField * phoneNumberTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypePhoneNumber] objectForKey:@"textField"];
        
        [DataManager signUpWithUsername:self.email
                            andPassword:self.password
                           andFirstname:firstNameTF.text
                            andLastname:lastNameTF.text
                         andPhoneNumber:phoneNumberTF.text
                             andPicture:self.picture
                             completion:^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
         {
             if (httpResponse.statusCode != 200)
             {
                 [HTTPResponseHandler handleHTTPResponse:httpResponse
                                             withMessage:@""
                                           forController:self
                                          withCompletion:^
                  {
                      nil;
                  }];
             }
             else
             {
                 
                 // ---------------------------------------------
                 // CGIA_WARNING
                 // tests temporaire en attendant que le WS nous renvoie des vrais codes error
                 // ---------------------------------------------
                 NSLog(@"Apres DataManager signUpWithUsername self.email:%@ ; self.password :%@",self.email, self.password);
                 NSLog(@"WS SignUpProfile user.description : %@",user.description);
                 if (user.email)
                 {
                     //-----------------------------------------------------------------
                     // Quand le WS sera implémenté, il faut coder ici l'appel au WS pour uploader la photo vers le serveur
                     //-----------------------------------------------------------------
                     // Si upload image = OK, alors appel au WS addvehicle
                     if (user.email)
                     {
                         NSLog(@"upload photo success");

                         // Appel au webservice pour ajouter les infos du véhicule
                         [self callAddVehicleWebservice];
                     }
                     else
                     {
                         NSLog(@"upload photo failed");
                         [self stopActivityIndicator];
                     }
                 }
                 else
                 {
                     [self stopActivityIndicator];
                     
                 }
             }
         }];
    }
    else
    {
        // afficher les messages d'erreur
        [self showErreursMessages];
    }
    
    [[_footerView button] setEnabled:YES];
    
    // Réinitialise les flags erreurs
   for (int i=0; i < nbRow ;i++)
    {
        [[_workingArrayForCells objectAtIndex:i] setValue:@(NO) forKey:kErrorFlag];
    }
}


-(void) callAddVehicleWebservice
{
    // Appel au WS Création d'un véhicule
    
    UITextField * carBrandTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarBrand] objectForKey:@"textField"];
    UITextField * carModelTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarModel] objectForKey:@"textField"];
    UITextField * carColorTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarColor] objectForKey:@"textField"];
    UITextField * carPlateTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarPlate] objectForKey:@"textField"];

    NSLog(@"Avant DataManager addVehicle self.email:%@ ; self.password :%@",self.email, self.password);
    
    [DataManager addVehicle:[[Vehicle alloc] initWithBrand:carBrandTF.text
                                                     model:carModelTF.text
                                                     color:carColorTF.text
                                            andNumberPlate:carPlateTF.text]
                                       withCompletionBlock:^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         if (httpResponse.statusCode != 200)
         {
             [HTTPResponseHandler handleHTTPResponse:httpResponse
                                         withMessage:@""
                                       forController:self
                                      withCompletion:^
              {
                  nil;
              }];
         }
         else
         {
             // Test temporaire en attendant que le WS nous retourne des code erreurs
             if (user.email)
             {
                 NSLog(@"Apres DataManager addVehicle self.email:%@ ; self.password :%@",self.email, self.password);
                 NSLog(@"WS Add Vehicule succes for user : %@", user.description);
                 dispatch_async(dispatch_get_main_queue(),
                                ^{
                                    // Enregistre email et password dans keychain
                                    [self saveEmailPwdIntoKeyChain:self.email andPassword:self.password];
                                    NSLog(@"WS Add keychain  self.email:%@ ; self.password :%@",self.email, self.password);
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"vehiclesListUpdated" object:nil];
                                    
                                    DataManager *dataManager = [DataManager sharedInstance];
    
                                    [dataManager.user setPassword:self.password];
                                    
                                    
                                    [self stopActivityIndicator];
                                    
                                    // on débranche vers le ViewController "addPayment"
                                    [self goToAddPayment];
                                });
             }
             else
             {
                 NSLog(@"WS Add Vehicule failed for user : %@", user.email);
                 [self stopActivityIndicator];
             }
         }
     }
     ];  // crochet fermant du DataManager
}


// Enregistre l'email et le mot de passe dans keychain pour l'auto login
-(void) saveEmailPwdIntoKeyChain:(NSString *)email andPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLoginKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    KeychainWrapper *MyKeychainWrapper =[[KeychainWrapper alloc]init];
    
    [MyKeychainWrapper mySetObject:email    forKey:(__bridge id)kSecAttrAccount];
    [MyKeychainWrapper mySetObject:password forKey:(__bridge id)kSecValueData];
    [MyKeychainWrapper writeToKeychain];
}



// Appel au ViewController AddPayment qui est dans le storyboard Payment
-(void) goToAddPayment
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Payment" bundle:nil];
    AddPaymentTableViewController* AddPaymentTVC = [sb instantiateViewControllerWithIdentifier:@"AddPayment"];
    [[self navigationController] pushViewController:AddPaymentTVC animated:YES];
}



//===============================================
#pragma mark - Table view data source
//===============================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NB_SECTION;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NB_ROW_FOR_SECTION_0;
    }
    else
    {
        if ([self pickerIsShown])
        {
            return (NB_ROW_FOR_SECTION_1 + 1);
        }
        else
        {
            return NB_ROW_FOR_SECTION_1;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self pickerIsShown] && (indexPath.section == 1) && indexPath.row == pickerIndexPath.row)
    {
        SignUpProfilePickerTableViewCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:@"SignUpProfilePickerCell"];
        
        [[pickerCell colorPicker] setDataSource:self];
        [[pickerCell colorPicker] setDelegate:self];
        
        if (pickerCell == nil)
        {
            pickerCell = [[SignUpProfilePickerTableViewCell alloc] initWithStyle:-1 reuseIdentifier:@"SignUpProfilePickerCell"];
        }
        
        return pickerCell;
    }
    else
    {
        SignUpProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignUpProfileCell"];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        NSInteger index = indexPath.row;

        if (indexPath.section == 1)
        {
            // il y a 3 cell dans la 1ere section (firstname, lastname et phoneNumber
            // On recalcul l'index pour récupérer le celltype qui est dans un tableau à 1 dimension
            index = index + 3;
        }
        if ((indexPath.section == 1) && [self pickerIsShown] && indexPath.row > pickerIndexPath.row)
        {
            index = index - 1;
        }
    
        TypedefEnumProfileCellType cellType = [[[_workingArrayForCells objectAtIndex:index] objectForKey:kCelltype] integerValue];
    
        // Alimenter les labels et les placeholder
        [cell.signUpProfileLabel setText:[[_workingArrayForCells objectAtIndex:cellType] objectForKey:kLabelText]];
        [cell.signUpProfileTextField setPlaceholder:[[_workingArrayForCells objectAtIndex:cellType] objectForKey:kTextFieldPlaceholder]];
 

        // Affecter les pointers aux labels et textfields de la tableView pour changer leurs propriétés
        [self setPointersToCellLabelAndTextField:cellType
                                        andLabel:cell.signUpProfileLabel
                                    andtextField:cell.signUpProfileTextField];
        
        return cell;
    }
}


// Création d'une view avec un pickerview, une toolbar et un bouton "Done"
// Cette view est appelée dès que le curseur est sur textfield (de type TypedefEnumProfileCellTypeCarColor)
//-(UIView *) createViewWithPickerViewAndDoneButton
//{
//    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,244)];
//    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
//    
//    [toolBar setBarStyle:UIBarStyleDefault];
//    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SignUpProfile-UIView-Picker-Button-Done", nil)
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:self
//                                                                     action:@selector(buttonDoneTouch)];
//    
//    
//    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    [toolBar setItems:[NSArray arrayWithObjects:flexibleSpace,barButtonDone,nil]];
//    
//    barButtonDone.tintColor=[UIColor louisMainColor];
//    [toolBar setBackgroundColor:[UIColor louisBackgroundApp]];
//    
//    myPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 45, self.view.frame.size.width,  190)];
//    
//    [myPicker setDataSource :self];
//    [myPicker setDelegate :self];
//    
//    [myPicker setBackgroundColor:[UIColor whiteColor]];
//    
//    [myView addSubview:toolBar];
//    [myView addSubview:myPicker];
//    return myView;
//
//}


//-(IBAction)buttonDoneTouch
//{
//    // on enlève le curseur (ou clavier) du textfield de type TypedefEnumProfileCellTypeCarColor
//    // resultat : la view, qui est apparu avec la méthode "setInputView" du textfield, disparait
//
//    UITextField *selectedTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarColor] objectForKey:kTextField];
//    
//    pickerViewIsShown = NO;
//    [Tools rotateLayer:selectedTF.rightView.layer fromStartingDegree:M_PI toArrivalDegree:2*M_PI inSeconds:1];
//    [selectedTF resignFirstResponder];
//}


// Affecter les pointers aux labels et textfields de la tableView pour changer leurs propriétés
- (void)setPointersToCellLabelAndTextField:(TypedefEnumProfileCellType)cellType
                                  andLabel:(UILabel*)label
                              andtextField:(UITextField*)textField
{
    
    // Ce teste permet de faire les affectation et de changer les propriétés qu'une seule fois
    if (![[_workingArrayForCells objectAtIndex:cellType] objectForKey:kLabel])
    {
        // affectation des uilabel et uitextfield dans le tableau _workingArrayForCells pour pouvoir les manipuler
        [[_workingArrayForCells objectAtIndex:cellType] setValue:label forKey:kLabel];
        [[_workingArrayForCells objectAtIndex:cellType] setValue:textField forKey:kTextField];
        
        // Affecter les propriétés communes à tous les labels
        [label setFont:[UIFont louisLabelFont]];
        [label setTextColor:[UIColor louisLabelColor]];
        
        // Affecter les propriétés communes à tous les textfield
        [textField setTextColor:[UIColor louisTitleAndTextColor]];
        [textField setFont:[UIFont louisLabelFont]];
        [textField setTag:cellType];
        [textField setDelegate:self];
        [textField setKeyboardType:UIKeyboardTypeAlphabet];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [textField setReturnKeyType:UIReturnKeyNext];
        
        // Affecter les propriétés spécifiques si besoin
        switch (cellType)
        {
            case TypedefEnumProfileCellTypePhoneNumber:
                textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case TypedefEnumProfileCellTypeCarColor:
            {
                textField.enabled = NO;
                textField.rightViewMode = UITextFieldViewModeAlways;// Set rightview mode
                UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowDown"]];
                textField.rightView = rightImageView; // Set right view as image view
                break;
            }
            case TypedefEnumProfileCellTypeCarPlate:
            {
                textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
                textField.keyboardType  = UIKeyboardTypeNamePhonePad;
                textField.returnKeyType = UIReturnKeyDone;
                break;
            }
            default:
                break;
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1) && (indexPath.row == 2))
    {
        [[self tableView] beginUpdates];
        [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([self pickerIsShown])
        {
            [Tools rotateLayer:[[[[[self tableView] cellForRowAtIndexPath:indexPath] signUpProfileTextField] rightView] layer]
            fromStartingDegree:M_PI
               toArrivalDegree:0.0
                     inSeconds:0.3];
            
            [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:pickerIndexPath.row inSection:1]]
                                    withRowAnimation:UITableViewRowAnimationMiddle];
            pickerIndexPath = nil;
        }
        else if (![self pickerIsShown])
        {
            [Tools rotateLayer:[[[[[self tableView] cellForRowAtIndexPath:indexPath] signUpProfileTextField] rightView] layer]
            fromStartingDegree:0.0
               toArrivalDegree:M_PI
                     inSeconds:0.3];
            pickerIndexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
            [tableView insertRowsAtIndexPaths:@[pickerIndexPath]
                             withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
        [tableView endUpdates];
        
        if ([self pickerIsShown])
        {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:pickerIndexPath.row inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        SignUpProfileTableViewCell  *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
//        if (!(indexPath.section ==1 && indexPath.row == 2))
//        {
            [[cellSelected signUpProfileTextField] becomeFirstResponder];
//        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // pour avoir un espace identique entre le top du footer et le button
    return 0.01f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // pour avoir un espace identique entre le top du footer et le button
    return [[UIView alloc] initWithFrame:CGRectZero];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return  NSLocalizedString(@"SignUpProfile-CarHeaderTitle",nil);
    }
    return @"";
}


//===============================================
# pragma mark PickerView Couleur des voitures
//===============================================

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return NB_COMPONENT;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerDataSource count];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITextField *carColorTextField = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarColor] objectForKey:kTextField];
    
    if (row == 0)
    {
        [carColorTextField setText:@""];
        aColorHasBeenSelected = NO ;
    }
    else
    {
        [carColorTextField setText:[pickerDataSource objectAtIndex:row]];
        aColorHasBeenSelected = YES ;
    }
   
    [self setEnableOrDisableToFooterButton:nil andRealTextFieldContent:nil];

}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerDataSource objectAtIndex:row];
}




//===============================================
#pragma mark TextFields and Labels
//===============================================

-(void)setEnableOrDisableToFooterButton:(UITextField *)currentTextField andRealTextFieldContent:(NSString *)realTextFieldContent
{
    // si tous les champs obligatoires sont remplis alors on active le button "Enregistrer"
    
    [[_footerView button] setEnabled:NO];
    
    unsigned long nbChampObligationRempli = 0;
    NSUInteger nbRow = [_workingArrayForCells count];
    
    // On boucle sur le tableau _workingArrayForCells pour tester tous les textfields de la tableView
    for (int i=0; i < nbRow; i++)
    {
            // numéro de plaque non obligatoire
            if (i != TypedefEnumProfileCellTypeCarPlate)
            {
                UITextField *myTextField = [[_workingArrayForCells objectAtIndex:i] objectForKey:kTextField];
                NSString *inputText = [myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if (i == TypedefEnumProfileCellTypeCarColor)
                {
                    // cas particulier pour la couleur de la voiture. Champ non saisissable, rempli lorsqu'un item du picker est sélectionné
                    if ((aColorHasBeenSelected == YES) && !(inputText.length == 0))
                    {
                        nbChampObligationRempli++;
                    }
                }
                else
                {
                    // currentTextField est le textField qui vient de la méthode ShoudChangeCaractersInRange
                    // dans ce cas, le vrai contenu du textfield n'est pas encore mis à jour, c'est pourquoi il faut tester la longueur de la variable realTextFieldContent (qui a été passé en paramètre)
                    if ((currentTextField != nil ) && ( i == currentTextField.tag))
                    {
                        if (realTextFieldContent.length != 0)
                        {
                            nbChampObligationRempli++;
                        }
                    }
                    else
                    {
                        if (inputText.length != 0)
                        {
                            nbChampObligationRempli++;
                        }
                    }
                }
            }
    }
    
    // tous les champs obligatoires sont remplis (ie: les 6 1ere champs)
    nbChampObligationRempli >= 6 ? [[_footerView button] setEnabled:YES] : [[_footerView button] setEnabled:NO];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == TypedefEnumProfileCellTypeCarColor)
    {
        if (pickerViewIsShown == NO)
        {
            pickerViewIsShown = YES;
            [Tools rotateLayer:textField.rightView.layer fromStartingDegree:0 toArrivalDegree:M_PI inSeconds:1];
        }
        else
        {
            pickerViewIsShown = NO;
            [Tools rotateLayer:textField.rightView.layer fromStartingDegree:M_PI toArrivalDegree:2*M_PI inSeconds:1];
        }
    }
    else
    {
        if ( pickerViewIsShown == YES)
        {
            // quand on clique sur une autre cell (différent de carColor), le picker disparait automatiquement
            pickerViewIsShown = NO;
            UITextField *selectedTF = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarColor] objectForKey:kTextField];
            [Tools rotateLayer:selectedTF.rightView.layer fromStartingDegree:M_PI toArrivalDegree:2*M_PI inSeconds:1];
        }
    }
    
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // si tous les champs obligatoires sont remplis alors on active le button "Enregistrer"
    NSString *testString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    testString = [testString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self setEnableOrDisableToFooterButton:textField andRealTextFieldContent:testString];
  
    // Empêcher la saisie dans le textfield de la couleur
    if (textField.tag == TypedefEnumProfileCellTypeCarColor)
    {
        return NO;
    }
 
    // Empêcher de saisir plus de 30 caractères pour firstname et lastname
    if ((textField.tag == TypedefEnumProfileCellTypeFirstName) || (textField.tag == TypedefEnumProfileCellTypeLastName))
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 30) ? NO : YES;
    }

    // Empêcher de saisir plus de 13 numéros pour le numero de telephone
    if (textField.tag == TypedefEnumProfileCellTypePhoneNumber)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return (([string isEqualToString:filtered])&&(newLength <= 13));
    }

    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType] == UIReturnKeyNext)
    {
        NSUInteger indexOfNextTextField = textField.tag+1;
 
        if (indexOfNextTextField == TypedefEnumProfileCellTypeCarColor)
        {
            [textField resignFirstResponder];
            [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForItem:PICKER_POSITION_IN_TABLEVIEW inSection:1] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:[self tableView] didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:PICKER_POSITION_IN_TABLEVIEW inSection:1]];

        }
        else
        {
             [[[_workingArrayForCells objectAtIndex:indexOfNextTextField] objectForKey:kTextField] becomeFirstResponder];
        }
    }
    else if ([textField returnKeyType] == UIReturnKeyDone)
    {
        if (_footerView.button.isEnabled == YES)
        {
            [textField resignFirstResponder];
            [self registerProfileButtonTouch];
        }
        else
        {
            // on position le clavier sur le 1er champ
            [[[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeFirstName] objectForKey:kTextField] becomeFirstResponder];
        }
    }
    
    return YES;
}


// afficher les messages d'erreur
-(void)showErreursMessages
{
    NSUInteger nbError = 0;
    NSInteger firstError = -1;
    NSUInteger nbRow = [_workingArrayForCells count];

    for (int i=0; i < nbRow ;i++)
    {
        if ([[[_workingArrayForCells objectAtIndex:i] objectForKey:@"errorFlag"] boolValue] == YES)
        {
            if (firstError == -1)
            {
                // Mémorise la 1er champ erronnée
                firstError = i;
            }
            nbError ++;
        }
    }
    
    // S'il y a au moins une erreur
    if (nbError > 0)
    {
        UIAlertView *alert;
        
        if (nbError == 1) // une seule erreur
        {
            // S'il n'y a qu'une seule erreur, elle se trouve à l'indice firstError qu'on a mémorisé
            alert = [[UIAlertView alloc] initWithTitle:nil
                                               message:[[_workingArrayForCells objectAtIndex:firstError] objectForKey:kErrorMsg]
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil) otherButtonTitles:nil];
        }
        else
        {
            // Il y a plusieurs erreurs de format
             alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:NSLocalizedString(@"SignUpProfile-Check-Multiple-Error", nil)
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                      otherButtonTitles:nil];
        }
        
        [alert show];
         // On place le curseur (clavier) sur la 1ere erreur
        [[[_workingArrayForCells objectAtIndex:firstError] objectForKey:kTextField] becomeFirstResponder];
    }
}


// Test format du firstname
-(void)checkFormatFirstname
{
    // Le prenom ne doit pas faire moins de 2 caractères et ne doit pas faire plus de 30 caractères
    // Avant de tester, on enlève les espaces avant et après
    UILabel *myLabel = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeFirstName] objectForKey:kLabel];
    myLabel.textColor = [UIColor louisLabelColor];
 
    UITextField *myTextField = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeFirstName] objectForKey:kTextField];
    NSString *textFirstName = [myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textFirstName.length < 2 || textFirstName.length > 30)
    {
        myLabel.textColor = [UIColor redColor];
        [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeFirstName] setValue:@(YES) forKey:kErrorFlag];
    }
//    [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeFirstName] setValue:myLabel forKey:kLabel];
}


// Test format du lastname
-(void)checkFormatLastname
{
    // Le nom ne doit pas faire moins de 2 caractères et ne doit pas faire plus de 30 caractères
    // Avant de tester, on enlève les espaces avant et après
    UILabel *myLabel = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeLastName] objectForKey:kLabel];
    myLabel.textColor = [UIColor louisLabelColor];
    
    UITextField *myTextField = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeLastName] objectForKey:kTextField];
    NSString *textLastName = [myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textLastName.length < 2 || textLastName.length > 30)
    {
        myLabel.textColor = [UIColor redColor];
        [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeLastName] setValue:@(YES) forKey:kErrorFlag];
    }
//    [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeLastName] setValue:myLabel forKey:kLabel];
}


// Test format du cellphone
-(void)checkFormatPhoneNumber
{
    UILabel *myLabel = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypePhoneNumber] objectForKey:kLabel];
    myLabel.textColor = [UIColor louisLabelColor];

    UITextField *myTextField = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypePhoneNumber] objectForKey:kTextField];
    NSString *textPhoneNumber = [myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (textPhoneNumber.length < 10 || textPhoneNumber.length > 13)
    {
        myLabel.textColor = [UIColor redColor];
        [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypePhoneNumber] setValue:@(YES) forKey:kErrorFlag];
    }
//    [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypePhoneNumber] setValue:myLabel forKey:kLabel];
}


// Test format du vehicule brand
-(void) checkFormatVehiculeBrand
{
    UILabel *myLabel = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarBrand] objectForKey:kLabel];
    myLabel.textColor = [UIColor louisLabelColor];
 
    UITextField *myTextField = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarBrand] objectForKey:kTextField];
    NSString *textBrand = [myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textBrand.length == 0)
    {
        myLabel.textColor = [UIColor redColor];
        [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarBrand] setValue:@(YES) forKey:kErrorFlag];
    }
    
//    [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarBrand] setValue:myLabel forKey:kLabel];
}


// Test format du vehicule model
-(void) checkFormatVehiculeModel
{
    UILabel *myLabel = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarModel] objectForKey:kLabel];
    myLabel.textColor = [UIColor louisLabelColor];
    
    UITextField *myTextField = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarModel] objectForKey:kTextField];
    NSString *textBrand = [myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textBrand.length == 0)
    {
        myLabel.textColor = [UIColor redColor];
        [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarModel] setValue:@(YES) forKey:kErrorFlag];
    }
    
//    [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarModel] setValue:myLabel forKey:kLabel];
}


// Test format du vehicule color
-(void) checkSelectedColor
{
    UILabel *myLabel = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarColor] objectForKey:kLabel];
    myLabel.textColor = [UIColor louisLabelColor];
    
    UITextField *myTextField = [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarColor] objectForKey:kTextField];
 
    if (aColorHasBeenSelected == NO || [myTextField.text isEqualToString:@" "])
    {
        myLabel.textColor = [UIColor redColor];
        [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarColor] setValue:@(YES) forKey:kErrorFlag];

    }
//    [[_workingArrayForCells objectAtIndex:TypedefEnumProfileCellTypeCarColor] setValue:myLabel forKey:kLabel];
}



//===============================================
#pragma mark - Add picture or take photo
//===============================================

//Affiche une actionSheet pour prendre une photo ou choisir une photo dans le librairie des photos
-(IBAction) addPictureButtonTouch
{
    NSLog(@"addPictureTouch");
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.editing = false;
    
    //Dans le cas d'un simulateur ou d'un vieux ipad, il n'y a pas de caméra pour prendre une photo.
    //Si le device possède une camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //Initialisation d'un actionSheet
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        //Ajout d'un bouton permettant d'accéder à la librairie des photos sur l'iphone
        UIAlertAction *libPicSel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SignUpProfile-ChoosePicture", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        NSLog(@"library selected");
                                        [imagePicker setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
                                        [self presentViewController:imagePicker animated:true completion:nil];
                                    }];
        [actionSheet addAction:libPicSel];
        
        //Ajout d'un bouton permettant de prendre une photo
        UIAlertAction *cameraSelected = [UIAlertAction actionWithTitle:NSLocalizedString(@"SignUpProfile-TakePicture",nil)
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             NSLog(@"camera selected");
                                             [imagePicker setSourceType: UIImagePickerControllerSourceTypeCamera];
                                             [self presentViewController:imagePicker animated:true completion:nil];
                                         }];
        [actionSheet addAction:cameraSelected];
        
        //Ajout du bouton cancel
        UIAlertAction *cancelSelected = [UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction * action)
                                         {
                                             NSLog(@"cancel selected");
                                         }];
        [actionSheet addAction:cancelSelected];
        
        [self presentViewController:actionSheet animated:true completion:nil];
    }
    else
    {
        //Si le device ne possède pas de camera
        [imagePicker setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:true completion:nil];
    }
}




//Récupère la photo sélectionné ou prise par l'utilisateur
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [[_profilePicture imageView] setImage:chosenImage];
    
    // Transformer l'image en NSData avec un taux de compression à 1
    self.imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
    
    //    [self uploadPicture:self.imageData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}



//==========================================
#pragma mark - Upload Image to server
//==========================================

// non utilisé pour l'instant car le Webservice n'est pas encore créé
- (void)uploadPicture:(NSData *)myImageData
{
    
    NSURLSessionUploadTask *uploadTask;
    //    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    
    // 1 - you’re using an NSURLSessionConfiguration that only permits one connection to the remote host, since your upload process handles just one file at a time
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    
    // 2 The upload and download tasks report information back to their delegates;
    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    // for now just create a random file name, dropbox will handle it if we overwrite a file and create a new name..
    NSURL *url;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    // 3 - Here you set the uploadTask property using the JPEG image obtained from the UIImagePicker
    uploadTask = [upLoadSession uploadTaskWithRequest:request fromData:myImageData];
    
    // 5
    [uploadTask resume];
}



//
//- (void)uploadPic
//{
//    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[self.imageReferenceURL] options:nil];
//    PHAsset *asset = [result firstObject];
//    if (asset) {
//        PHImageManager *manager = [PHImageManager defaultManager];
//        [manager requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//            // upload the `imageData`
//
//            NSURL *fileURL = info[@"PHImageFileURLKey"];
//            NSString *filename = [fileURL lastPathComponent];
//            NSString *mimeType = [self mimeTypeForPath:filename];
//
//            NSString *urlString = @"url";
//
//            NSMutableURLRequest* request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//            [request setHTTPMethod:@"POST"];
//            NSString *boundary = @"---------------------------14737809831466499882746641449";
//            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//            NSMutableData *postbody = [NSMutableData data];
//            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
//            [postbody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
//            [postbody appendData:imageData];
//            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//
//            NSURLSessionTask *task = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:postbody completionHandler:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error) {
//                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"Response  %@",responseString);
//            }];
//            [task resume];
//        }];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
