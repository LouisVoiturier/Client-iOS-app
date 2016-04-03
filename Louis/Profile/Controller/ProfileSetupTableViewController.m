//
//  ProfileSetupTableViewController.m
//  Louis
//
//  Created by Giang Christian on 18/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ProfileSetupTableViewController.h"
#import "Common.h"
#import "ProfileSetupTableViewCell.h"
#import "ResearchPopupView.h"
#import "ProfilePictureViewWithButton.h"
#import "DataManager+User.h"
#import "KeychainWrapper.h"

#define NB_SECTION 1;

@interface ProfileSetupTableViewController ()
{
    
}

@property (nonatomic, strong) NSMutableArray *cellTypesGroupedBySection;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, strong) UITextField *firstNameTextField;
@property (nonatomic, strong) UITextField *lastNameTextField;
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *emailTextField;

@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *lastNameLabel;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UILabel *emailLabel;

@property (nonatomic,strong) ProfilePictureViewWithButton *profilePicture;
@property (nonatomic,strong) BigButtonView *footerView;
@property (nonatomic,strong) ResearchPopupView *RPV;
@property (nonatomic, strong) DataManager *dataManager;

@property (nonatomic, strong) NSMutableArray *errorsTable;

@end

typedef NS_ENUM (NSInteger, TypedefEnumProfileCellType) {
    TypedefEnumProfileCellTypeFirstName,
    TypedefEnumProfileCellTypeLastName,
    TypedefEnumProfileCellTypePhoneNumber,
    TypedefEnumProfileCellTypeEmail
};


@implementation ProfileSetupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"ProfileSetup-Title", nil)];
    [self.tableView setBackgroundColor:[UIColor louisBackgroundApp]];
    
    _errorsTable = [[NSMutableArray alloc]init];
    
    // Configure cellule de la tableview
    [self configureCells];
    
    // headerView
    [self addPictureInHeaderView];
    
    // footerView
    [self addButtonInFooterView];
    
    // Le clavier disparait quand on clique sur l'écran
    [self dismissKeyboardOnTapGesture];
    
    // Ajout Bar bouton Annuler à droite
    [self addBarButtonCancel];

    
}

-(void) addBarButtonCancel
{
    // Ajout Bar bouton Annuler à droite
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc]
                                        initWithTitle:NSLocalizedString(@"CancelButtonItem-Title", nil)
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(barButtonCancelTouch)];

    self.navigationItem.rightBarButtonItem = barButtonCancel;

}


-(IBAction)barButtonCancelTouch
{
    // Si pas de modifications
    if ([[_footerView button] isEnabled] == NO)
    {
        // retour à la view précédent
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        // sinon, on demande à l'utilisateur de confirmer
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ProfileSetup-DiscardAllChange-Confirm-Title", nil) message:NSLocalizedString(@"ProfileSetup-DiscardAllChange-Confirm-Msg", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        
        // Quand l'utilisateur choisit  "oui" (abandon des modif)
        UIAlertAction *cancelConfirmed = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-YES", nil)
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * action)
                                  {
                                      
                                      // retour à la view précédent
                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                  }];
        [actionSheet addAction:cancelConfirmed];
        
        
        // Quand l'utilisateur choisit  "non"
        UIAlertAction *discardNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-NO",nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * action)
                                 {
                                     // Quand l'utilisateur choisit  "non", ne rien faire
                                     
                                 }];
        [actionSheet addAction:discardNo];
        
        [self presentViewController:actionSheet animated:true completion:nil];
    }

    
    
   
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
    self.navigationItem.hidesBackButton = YES;
    
    [GAI sendScreenViewWithName:@"Edit Profile"];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // enlever le clavier
    [[self view] endEditing:YES];
    
}




- (void)configureCells
{
    _cellTypesGroupedBySection = [[NSMutableArray alloc]init];
    
    [_cellTypesGroupedBySection addObject:@(TypedefEnumProfileCellTypeFirstName)];
    [_cellTypesGroupedBySection addObject:@(TypedefEnumProfileCellTypeLastName)];
    [_cellTypesGroupedBySection addObject:@(TypedefEnumProfileCellTypePhoneNumber)];
    [_cellTypesGroupedBySection addObject:@(TypedefEnumProfileCellTypeEmail)];
    
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
     _dataManager = [DataManager sharedInstance];
    
}

-(void) addPictureInHeaderView
{
    /***** Header *****/
    //Ajouter photo et bouton dans headerview
    _profilePicture = [[ProfilePictureViewWithButton alloc] initWithFrameAndBottomButton:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.25)];
    [[_profilePicture firstButton]  setTitle:NSLocalizedString(@"ProfileSetup-Change-Picture",nil) forState:UIControlStateNormal];
    [[_profilePicture firstButton]  addTarget:self action:@selector(modifyPictureButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    // underline button text
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[_profilePicture firstButton].titleLabel.text];
    [titleString setAttributes:@{NSForegroundColorAttributeName:[UIColor louisMainColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[titleString length])];
    
    [[_profilePicture firstButton] setAttributedTitle: titleString forState:UIControlStateNormal];
    
    [[_profilePicture firstButton] setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [self.tableView setTableHeaderView:self.profilePicture];
    
    // Ajout action quand on clique sur la photo
    
    [_profilePicture imageView].userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyPictureButtonTouch)];
    [[_profilePicture imageView] addGestureRecognizer:tap];


}



-(void) addButtonInFooterView
{
    //Ajouter le bouton dans le footerview
    
    _footerView = [BigButtonView bigButtonViewTypeMainWithTitle:NSLocalizedString(@"SignUpProfile-Button-Title", nil)];
    [[_footerView button] addTarget:self action:@selector(saveProfileButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [[_footerView button] setEnabled:NO];
    
    [[self tableView] setTableFooterView:_footerView];
}


-(void) startActivityIndicator
{
    _RPV = [[ResearchPopupView alloc] init];
    [_RPV changeToSearchingStateWithMessage:@"Enregistrement en cours"];
}

-(void) stopActivityIndicator
{
    [_RPV dismiss];
}


- (IBAction)saveProfileButtonTouch
{
    //Initialisation d'un actionSheet
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ProfileSetup-SaveChange-Confirm-Title", nil) message:NSLocalizedString(@"ProfileSetup-SaveChange-Confirm-Msg", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    
    // Quand l'utilisateur choisit  "oui"
    UIAlertAction *saveYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-YES", nil)
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * action)
                              {
                                  
                                  // Vérif format des champs et appel WS pour enregister les modifications
                                  [self saveProfileChange];
                              }];
    [actionSheet addAction:saveYes];
    
   
    // Quand l'utilisateur choisit  "non"
    UIAlertAction *saveNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-NO",nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action)
                             {
                                 // Quand l'utilisateur choisit  "non", ne rien faire
                                 
                             }];
    [actionSheet addAction:saveNo];
  
    [self presentViewController:actionSheet animated:true completion:nil];

    
}


-(void) saveProfileChange
{
    [[_footerView button] setEnabled:NO];
   
    //Vérifie les formats des firstnam, lastname, phonenumber, email
    [self checkFormatFirstname] ;
    [self checkFormatLastname] ;
    [self checkFormatPhoneNumber] ;
    [self checkFormatEmail] ;
    
    // calculer le nombre d'erreur
    // _errorsTable est incrémenté à chaque erreur dans les 3 méthodes de vérification ci dessus
    NSUInteger nbError = [_errorsTable count];
    NSLog(@"_errorsTable :%@",_errorsTable);
    if (nbError == 0)
    {
        [self startActivityIndicator];
        
        // ------------
        // CGIA WARNING A modifier quand le WS image sera implémenté.
        // ------------
        self.picture = @"http://monimage.png";
        
        
        
        // récupération ancien user
        NSString *oldEmail = _dataManager.user.email;
        [_dataManager.user setPassword:[[_dataManager userCredentials] valueForKey:@"password"]];
        NSString *password = _dataManager.user.password;
 
        NSLog(@"WS SignUpProfile avant : %@",_dataManager.user.description);
      
        // mis à jour des données modifiés dans le dataManager
        _dataManager.user.firstName = _firstNameTextField.text;
        _dataManager.user.lastName  = _lastNameTextField.text;
        _dataManager.user.cellPhone = _phoneNumberTextField.text;
        _dataManager.user.email     = _emailTextField.text; // new email saisi par le user
        
        NSLog(@"WS SignUpProfile apres: %@",_dataManager.user.description);
        
        [DataManager modifyProfileWithUsername :oldEmail
                                    andPassword:password
                                    andNewEmail:self.emailTextField.text
                                   andFirstname:self.firstNameTextField.text
                                    andLastname:self.lastNameTextField.text
                                 andPhoneNumber:self.phoneNumberTextField.text
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
                 dispatch_async(dispatch_get_main_queue(),^
                                {
                                    // ---------------------------------------------
                                    // CGIA_WARNING
                                    // tests temporaire en attendant que le WS nous renvoie des vrais codes error
                                    // ---------------------------------------------
                                    [self saveEmailPwdIntoKeyChain:_emailTextField.text andPassword:self.dataManager.user.password];
                                    
                                    NSLog(@"WS ProfileSetup user.email : %@",user.description);
                                    if (user.email)
                                    {
                                        // Si upload image = OK, alors appel au WS upload photo
                                        if (user.email)
                                        {
                                            if ([[_profilePicture imageView] image])
                                            {
                                                _dataManager.user.pictureImage = [[_profilePicture imageView] image];
                                            }
                                          
                                            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Upload photo to server" message:@"Le Webservice pour uploader la photo n'est pas encore implémenté" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [myAlert show];
                                            
                                            
                                            NSLog(@"upload photo success");
                                            [[_footerView button] setEnabled:NO];
                                            
                                        }
                                        else
                                        {
                                            NSLog(@"upload photo failed");
                                            [[_footerView button] setEnabled:YES];
                                        }
                                        [self stopActivityIndicator];
                                    }
                                    else
                                    {
                                        [self stopActivityIndicator];
                                    }
                                });
             }
         }];
        
    }
    else
    {
        // afficher les messages d'erreur
        [self showErreursMessages];
        [[_footerView button] setEnabled:YES];
    }

    
    // Réinitialise table des erreurs
    [_errorsTable removeAllObjects];
    
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




//===============================================
#pragma mark - Add picture or take photo
//===============================================

//Affiche une actionSheet pour prendre une photo ou choisir une photo dans le librairie des photos
-(IBAction) modifyPictureButtonTouch
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
    [[_footerView button] setEnabled:YES];
    
    NSLog(@"didFinishPickingMediaWithInfo info : %@",info);
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [[_profilePicture imageView] setImage:chosenImage];
    
   
    // Transformer l'image en NSData avec un taux de compression à 1
    self.imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
    //    [self uploadPicture:self.imageData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}



//===============================================
#pragma mark - Table view data source
//===============================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NB_SECTION;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellTypesGroupedBySection count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileSetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileSetupCell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    TypedefEnumProfileCellType cellType = [[_cellTypesGroupedBySection objectAtIndex:indexPath.row] integerValue];
    
    // Affecter les pointers aux labels et textfields de la tableView pour changer leurs propriétés
    [self setPointersToCellLabelAndTextField:cellType
                                    andLabel:cell.profileSetupLabel
                                andtextField:cell.profileSetupTextField];
    
    return cell;

    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ProfileSetupTableViewCell  *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    [[cellSelected profileSetupTextField] becomeFirstResponder];

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




-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    // Le bouton "Enregistrer" devient accessible dès que l'utilisateur modifie l'un des 4 champs
    [[_footerView button] setEnabled:YES];
    
    // Empecher de saisir plus de 30 caractères pour firstname et lastname
    if ((textField.tag == TypedefEnumProfileCellTypeFirstName) || (textField.tag == TypedefEnumProfileCellTypeLastName))
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        return (newLength > 30) ? NO : YES;
    }
    
    // Empecher de saisir plus de 13 numéro pour le numero de telephone
    if (textField.tag == TypedefEnumProfileCellTypePhoneNumber)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return (([string isEqualToString:filtered])&&(newLength <= 13));
        
    }
    
    return YES;
    
}



//===============================================
#pragma mark TextFields and Labels
//===============================================

// Affecter les pointers aux labels et textfields de la tableView pour changer leurs propriétés
- (void)setPointersToCellLabelAndTextField:(TypedefEnumProfileCellType)cellType
                                  andLabel:(UILabel*)label
                              andtextField:(UITextField*)textField
{
    [label setFont:[UIFont louisLabelFont]];
    
    // Affecter les propriétés communes à tous les textfield
    [textField setTextColor:[UIColor louisTitleAndTextColor]];
    [textField setFont:[UIFont louisLabelFont]];
    [textField setTag:cellType];
    [textField setDelegate:self];
    [textField setKeyboardType:UIKeyboardTypeAlphabet];
    [textField setReturnKeyType:UIReturnKeyNext];
    
    switch (cellType)
    {
        case TypedefEnumProfileCellTypeFirstName:
        {
            textField.text = _dataManager.user.firstName;
            
            // ce test permet de ne pas modifier les propriétés une seule fois. Il permet notamment de ne pas modifier la couleur des labels lorsque la tableview se rafraichisse. En effet en cas d'erreur de saisi (ex:phoneNumber < 10 chiffres) les labels sont mis en rouge
            if (!_firstNameTextField)
            {
                // Affecter le pointer firstNameLabel au label firstName pour pouvoir le manipuler (ex: mettre la couleur en rouge).
                label.text = NSLocalizedString(@"Profile-FirstName-Label",nil);
                [label setTextColor:[UIColor louisLabelColor]];
                _firstNameLabel = label;
                
                // Affecter le pointer firstNameTextField au textField firstNameTextField
                textField.placeholder = NSLocalizedString(@"Profile-FirstName-Placeholder",nil);
                textField.autocapitalizationType = UITextAutocapitalizationTypeWords ;
                _firstNameTextField = textField;
                break;
            }
            
        }
            
        case TypedefEnumProfileCellTypeLastName:
        {
            textField.text = _dataManager.user.lastName;
            
            if (!_lastNameTextField)
            {
                // Affecter le pointer _lastNameLabel au label lastName pour pouvoir le manipuler.
                label.text = NSLocalizedString(@"Profile-LastName-Label", nil);
                [label setTextColor:[UIColor louisLabelColor]];
                _lastNameLabel = label;
                
                // Affecter le pointer _lastNameTextField au textField lastName
                textField.placeholder = NSLocalizedString(@"Profile-LastName-Placeholder",nil);
                textField.autocapitalizationType = UITextAutocapitalizationTypeWords ;
                _lastNameTextField = textField;
                break;
            }
            
        }
            
        case TypedefEnumProfileCellTypePhoneNumber:
        {
            textField.text = _dataManager.user.cellPhone;
            
            if (!_phoneNumberTextField)
            {
                // Affecter les pointers _phoneNumberLabel et _phoneNumberTextField
                label.text = NSLocalizedString(@"Profile-PhoneNumber-Label", nil);
                [label setTextColor:[UIColor louisLabelColor]];
                _phoneNumberLabel = label;
                
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.placeholder  = NSLocalizedString(@"Profile-PhoneNumber-Placeholder",nil);
                _phoneNumberTextField = textField;
                break;
            }
            
        }
            
        case TypedefEnumProfileCellTypeEmail:
        {
            textField.text = _dataManager.user.email;
            
            // Affecter le pointer _emailTextField au textField de l'email pour changer ses propriétés
            if (!_emailTextField)
            {
                label.text = NSLocalizedString(@"Sign-Email-Label",nil);
                [label setTextColor:[UIColor louisLabelColor]];
                _emailLabel = label;

                textField.keyboardType = UIKeyboardTypeEmailAddress;
                textField.returnKeyType = UIReturnKeyDone;
                textField.placeholder = NSLocalizedString(@"Sign-Email-TextField",nil);
                textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                _emailTextField = textField;
            }
        }
            
        default:
            break;
    }
    
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType] == UIReturnKeyNext)
    {
        int j=0;
        NSUInteger nbRows = [self.cellTypesGroupedBySection count];
        for ( j=0; j<nbRows; j++)
        {
            ProfileSetupTableViewCell *myCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
            if ([myCell profileSetupTextField] == textField)
            {
                ProfileSetupTableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j+1 inSection:0]];
                [[nextCell profileSetupTextField] becomeFirstResponder];

            }
        }
    }
    else if ([textField returnKeyType] == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
        [self saveProfileButtonTouch];
    }
    
    return YES;
}





// afficher les messages d'erreur
-(void)showErreursMessages
{
    // calculer le nombre d'erreur
    NSUInteger nbError = [_errorsTable count];
    
    // S'il y a au moins une erreur
    if (nbError > 0)
    {
        
        if (nbError == 1) // une seule erreur
        {
            // S'il n'y a qu'une seule erreur, elle se trouve à l'indice 0 du tableau des erreurs (_errorsTable)

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[_errorsTable objectAtIndex:0][2]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil) otherButtonTitles:nil];
            [alert show];
            [[_errorsTable objectAtIndex:0][1] becomeFirstResponder];
            
        }
        else
        {
            // Il y a plusieurs erreurs de format
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"SignUpProfile-Check-Multiple-Error", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            
            // On place le curseur sur la 1ere erreur (index 0)
            
            [[_errorsTable objectAtIndex:0][1] becomeFirstResponder];
            
           
            
        }
    }
    
}



// Test format du firstname
-(void)checkFormatFirstname
{
    // Le prenom ne doit pas faire moins de 2 caractères et ne doit pas faire plus de 30 caractères
    // Avant de tester, on enlève les espaces avant et après
    NSString *textFirstName = [_firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    _firstNameLabel.textColor = [UIColor louisLabelColor];
    _firstNameLabel.font = [UIFont louisLabelFont];
    
    if (textFirstName.length < 2 || textFirstName.length > 30)
    {
        _firstNameLabel.textColor = [UIColor redColor];
        [_errorsTable addObject:@[@(TypedefEnumProfileCellTypeFirstName),_firstNameTextField, NSLocalizedString(@"SignUpProfile-Check-Firstname-ErrMsg", nil)]];
    }
}


// Test format du lastname
-(void)checkFormatLastname
{
    // Le nom ne doit pas faire moins de 2 caractères et ne doit pas faire plus de 30 caractères
    // Avant de tester, on enlève les espaces avant et après
    NSString *textLastName = [_lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    _lastNameLabel.textColor = [UIColor louisLabelColor];
    _lastNameLabel.font = [UIFont louisLabelFont];
    
    if (textLastName.length < 2 || textLastName.length > 30)
    {
        _lastNameLabel.textColor = [UIColor redColor];
        [_errorsTable addObject:@[@(TypedefEnumProfileCellTypeLastName),_lastNameTextField, NSLocalizedString(@"SignUpProfile-Check-Lastname-ErrMsg", nil)]];
    }
}

// Test format du cellphone
-(void)checkFormatPhoneNumber
{
    _phoneNumberLabel.textColor = [UIColor louisLabelColor];
    _phoneNumberLabel.font = [UIFont louisLabelFont];
    if (_phoneNumberTextField.text.length < 10 || _phoneNumberTextField.text.length > 13)
    {
        _phoneNumberLabel.textColor = [UIColor redColor];
        [_errorsTable addObject:@[@(TypedefEnumProfileCellTypePhoneNumber),_phoneNumberTextField, NSLocalizedString(@"SignUpProfile-Check-PhoneNumber-ErrMsg", nil)]];
    }
}

// vérifie si le format de l'adresse mail est correct
-(void)checkFormatEmail
{
    NSString *emailString = self.emailTextField.text;
    
    // Expression régulière pour vérifier le format de l'email  "abc@example.com" ou "abc@example.com.fr".
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,9}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    _emailLabel.textColor = [UIColor louisLabelColor];
    if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
    {
        _emailLabel.textColor = [UIColor redColor];
        
        // Ajoute l'erreur dans le tableau des erreurs
        [_errorsTable addObject:@[@(TypedefEnumProfileCellTypeEmail),_emailTextField, NSLocalizedString(@"SignUp-Check-Email-Format",nil)]];
        
    }
}

@end
