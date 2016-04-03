//
//  MenuTableViewController.m
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "MenuTableViewController.h"
#import "SWRevealViewController.h"
#import "ProfilePictureView.h"
#import "LegalsViewController.h"
#import "Common.h"
#import "DataManager+User.h"

@interface MenuTableViewController ()
{
    NSIndexPath *selectedIndexPath ;
    NSIndexPath *profileIndexPath;
    UITableViewCell *rememberSelectedMenuItem;
}

@property (nonatomic, strong) ProfilePictureView *profilePicture;

@end

@implementation MenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
    // Configure le menu avec ses items
    [self initMenuDictionary];
    
    /***** Header affiche photo *****/
    self.profilePicture = [[ProfilePictureView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.15)];
    [[self.profilePicture imageView] setUserInteractionEnabled:YES];
    [[self.profilePicture firstnameLabel] setUserInteractionEnabled:YES];
    [[self.profilePicture lastnameLabel] setUserInteractionEnabled:YES];
    
    // Ajout action quand on clique sur la photo, le nom et le prénom
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [[_profilePicture imageView] addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [[_profilePicture firstnameLabel] addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [[_profilePicture lastnameLabel] addGestureRecognizer:tap3];
    
    [self.tableView setTableHeaderView:self.profilePicture];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [GAI sendScreenViewWithName:@"Menu"];
    
    DataManager *dataManager = [DataManager sharedInstance];
    if ( dataManager.user.pictureImage)
    {
        [self.profilePicture imageView].image = dataManager.user.pictureImage;
    }
    
    // Demande trello : Ajouter l'effet de rubrique active dans le menu
    if (selectedIndexPath)
    {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}


-(IBAction)imageTapped
{
    // la mémorisation de cet indexPath permet de colorier le backgroundColor de la cellule profile du menu quand l'utilisateur clique sur la photo
    selectedIndexPath = profileIndexPath;
    
    NSMutableDictionary *menuDictionary = [[NSMutableDictionary alloc]init];
    menuDictionary[@"Menu-Profile"] = @"Menu-Profile";
    menuDictionary[@"storyboardName"] = @"Profile" ;
    menuDictionary[@"viewControllerIdentifier"] = @"NavProfile";
    menuDictionary[@"segueIdentifier"] = @"MenuToProfile";

    //Appel au Storyboard associé à l'élément du menu
    [self goToAnotherStoryBoard:menuDictionary];

}

#pragma mark - Config du menu

// Ajouter un item au menu
-(void)addMenuItem:(NSString *)menu
             andSB:(NSString *)sb
            andVCI:(NSString *)vci
          andSegue:(NSString *)segue
{
    NSMutableDictionary *menuDictionary = [[NSMutableDictionary alloc]init];
    menuDictionary[@"menu"] = menu;
    menuDictionary[@"storyboardName"] = sb;
    menuDictionary[@"viewControllerIdentifier"] = vci;
    menuDictionary[@"segueIdentifier"] = segue;
    
    [_menu addObject:menuDictionary];
}


-(void)initMenuDictionary
{
    //_menu est un tableau de dictionnaire
    _menu = [[NSMutableArray alloc]init];
    
    // Alimentation du menu
    // Les 3 derniers menus Help, CGV et Legals vont vers le meme ViewController
    [self addMenuItem:@"Menu-EmptyLine"  andSB:@""  andVCI:@""  andSegue:@""];
    [self addMenuItem:@"Menu-Home"     andSB:@"Home"     andVCI:@"NavHome"     andSegue:@"MenuToHome"];
    [self addMenuItem:@"Menu-Profile"  andSB:@"Profile"  andVCI:@"NavProfile"  andSegue:@"MenuToProfile"];
    [self addMenuItem:@"Menu-Vehicles" andSB:@"Vehicles" andVCI:@"NavVehicles" andSegue:@"MenuToVehicles"];
    [self addMenuItem:@"Menu-Payment"  andSB:@"Payment"  andVCI:@"NavPayment"  andSegue:@"MenuToPayment"];
    [self addMenuItem:@"Menu-Meetings" andSB:@"Meetings" andVCI:@"NavMeetings" andSegue:@"MenuToMeetings"];
    [self addMenuItem:@"Menu-Coupons"  andSB:@"Coupons"  andVCI:@"NavCoupons"  andSegue:@"MenuToCoupons"];
    [self addMenuItem:@"Menu-EmptyLine"  andSB:@""  andVCI:@""  andSegue:@""];
    [self addMenuItem:@"Menu-Help"     andSB:@"Legals"   andVCI:@"NavLegals"   andSegue:@"MenuToLegals"];;
    [self addMenuItem:@"Menu-CGV"      andSB:@"Legals"   andVCI:@"NavLegals"   andSegue:@"MenuToLegals"];
    [self addMenuItem:@"Menu-Legals"   andSB:@"Legals"   andVCI:@"NavLegals"   andSegue:@"MenuToLegals"];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_menu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellHome" forIndexPath:indexPath];
    
    NSDictionary *menuDictionary = [_menu objectAtIndex:indexPath.row];
 
    cell.textLabel.text = NSLocalizedString(menuDictionary[@"menu"],nil);
    if ([menuDictionary[@"menu"] isEqualToString:@"Menu-Profile"])
    {
        // la mémorisation de cet indexPath permet de colorier le backgroundColor de la cellule profile du menu quand l'utilisateur clique sur la photo
        profileIndexPath = indexPath;
    }

    if ([menuDictionary[@"menu"] isEqualToString:@"Menu-EmptyLine"])
    {
        // Ajout ligne vide dans le menu et empêche la sélection
        cell.textLabel.text = @"";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (indexPath.row == 0)
    {
        // supprime le trait de séparation entre les cellules
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    // Cell background color and fontsize
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:20.f weight:UIFontWeightRegular]];
    [[cell textLabel] setTextColor:[UIColor louisSubtitleColor]];
    
    // la taille de font des menus aide, CGV et mentions légales est plus petite
    if ([menuDictionary[@"segueIdentifier"] isEqualToString:@"MenuToLegals"])
    {
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.f weight:UIFontWeightRegular]];
        [[cell textLabel] setTextColor:[UIColor louisLabelColor]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    selectedIndexPath = indexPath;
    NSDictionary *menuDictionary = [_menu objectAtIndex:indexPath.row];
    
    // Si le menu sélectionné est différent de la ligne vide du menu
    if (!([menuDictionary[@"menu"] isEqualToString:@"Menu-EmptyLine"]))
    {
        //Appel au Storyboard associé à l'élément du menu
        [self goToAnotherStoryBoard:menuDictionary];
    }
}




//Appel au Storyboard associé au élément du menu
-(void) goToAnotherStoryBoard : (NSDictionary *)dictionary
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:dictionary[@"storyboardName"] bundle:nil];
    
    UINavigationController* navController;
    
    // On utilise le HomeViewController garder en property dans le SWReveal pour ne pas avoir a recharger
    if ([dictionary[@"segueIdentifier"] isEqualToString:@"MenuToHome"] && [self revealViewController].comonHomeViewController)
    {
        HomeViewController * _Nonnull nonNullHome = [self revealViewController].comonHomeViewController;
        navController = [[UINavigationController alloc] initWithRootViewController:(UIViewController*)nonNullHome];
    }
    else
    {
        navController = [sb instantiateViewControllerWithIdentifier:dictionary[@"viewControllerIdentifier"]];
    }
    
    
    if ([dictionary[@"segueIdentifier"] isEqualToString:@"MenuToLegals"])
    {
        // passage du titre au NavLegals ViewController.
        // Le contenu des Webviews Help, CGV ou Legals seront affiché en fonction du titre
        LegalsViewController *rootViewController = [[navController viewControllers] firstObject];
        rootViewController.titleInLegalsVC = dictionary[@"menu"];
    }
    
    SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:dictionary[@"segueIdentifier"] source:self destination:navController];
    [segue perform];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
