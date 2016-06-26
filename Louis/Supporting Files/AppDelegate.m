//
//  AppDelegate.m
//  Louis
//
//  Created by Thibault Le Cornec on 24/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

//#import <Google/Analytics.h>
#import <Stripe/Stripe.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "Common.h"
#import "SWRevealViewController.h"
#import "DataManager+User.h"
#import "KeychainWrapper.h"
#import "ResearchPopupView.h"
#import "GeolocForbiddenViewController.h"
#import "ImageManager.h"
#import "ProfileTableViewController.h"

static NSString *const kStripeAPIKey = @"YOUR_STRIPE_API_KEY_HERE";
static NSString *const kGoogleAPIKey = @"YOUR_GOOGLE_API_KEY_HERE";
static NSString *const kGATrackingID = @"YOUR_GOOGLE_ANALYTICS_ID_HERE";
static BOOL applicationBecomActiveIsCalledOnce = YES;
static BOOL hasLogin;


@implementation AppDelegate


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void (^)(BOOL succeeded))completionHandler
{
    // Méthodes for Quick Actions;
}


// cette methode est "deprecated" et censé ETRE remplacé PAR la méthode openUrl option ci-dessous ci-dessous mais elle ne fonctionne pas
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // (url)     scheme://host?query
    // (exemple) louis://reset-password?param1=value1&param2=value2&param3=value3&param4=value4
    
    NSLog(@"sourceApplication Bundle ID: %@", sourceApplication);
    NSLog(@"url complete: %@", url);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"url host: %@", [url host]);
    NSLog(@"URL query: %@", [url query]);

    NSDictionary *dict = [self parseQueryString:[url query]];
    NSLog(@"query dict: %@", dict);
    
    // appel WS pour vérifier la validité du lien
//    if ([self linkIsValid] == (BOOL) dict[@"reset"])
    if ([[dict[@"reset"] uppercaseString] isEqualToString:@"YES"])
    {
        return [self gotoResetPassword];

    }
    else
    {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"Ce lien n'est plus valide" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [myAlert show];
        return YES;
    }

}

- (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [mutableDict setObject:val forKey:key];
    }
    
    NSDictionary *dict = [mutableDict copy];
    
    return dict;
}


-(BOOL) linkIsValid
{
    // appel WS
    return NO ;
}

//// cette methode est censé remplacé la méthode openUrl sourceApplication ci-dessus mais elle ne fonctionne pas
//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
//{
//    return [self gotoResetPassword];
//}

-(BOOL) gotoResetPassword
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    
    ProfileTableViewController *profileTVC  = [sb instantiateViewControllerWithIdentifier:@"ChangePwdTVC"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:profileTVC];
    
    // Dans ce cas, on accède au storyboard défini dans le Main.storyboard (ie : accès à WelcomeViewController).
    UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Mise en place du storyboard et Accès à la Home directement
    SWRevealViewController *slidemenu = [sbMain instantiateViewControllerWithIdentifier:@"MenuTVC"];
    
    
    // define rear and frontviewcontroller
    SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:slidemenu frontViewController:navController];
    
    self.window.rootViewController = revealController;
    
    return YES;
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Google Analytics
    [[GAI sharedInstance] trackerWithTrackingId:kGATrackingID];
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    [GAI sendScreenViewWithName:@"LaunchScreen"];
    return YES;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configuration de la couleur des navBars
    [UINavigationBar appearance].barTintColor =[UIColor louisHeaderColor];
    
    // Attribution de la API KEY d'identification à Stripe
    [Stripe setDefaultPublishableKey:kStripeAPIKey];
    
    //_window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"panda.jpeg"]];
//    self.window.tintColor = [UIColor louisMainColor];
    
    // Google API key binding
    [GMSServices provideAPIKey:kGoogleAPIKey];


    NSLog(@"Debut AppDelegate didFinishLaunchingWithOptions");
    
    //-----------------------------------------------------------------------------------------------------
    // ATTENTION Important
    //-----------------------------------------------------------------------------------------------------
    // s'il ny a pas de point d'entrée dans un storyboard, l'app se plante dès la 1er ligne du didFinishLaunchingWithOptions
    // Le point d'entrée de notre app est placé sur LaunchAppViewController (cf main.storyboard).
    //
    // Ordre d'exécution :
    //     1.AppDelegate.didFinishLaunchingWithOptions
    //     2.LaunchAppViewController.viewDidLoad
    //     3.AppDelegate.applicationDidBecomeActive
    
    // Par conséquent :
    //     1.Pour lancer la vue Welcome directement, il faut faire un self.window.rootViewController = SWRevealViewController dans cette methode didFinishLaunchingWithOptions (du Appdelegate). Le fait de setter le rootVC dans cette methode permet à l'app de se débrancher sur le SWRevealViewController sans passer par le LaunchAppViewController.viewDidLoad. Et d'afficher le Welcome comme indiqué dans le main.storyboard
    
    //     2.Auto Login. Pour Lancer la vue Home (avec la carte) directement, il faut setter le rootViewController dans la methode applicationDidBecomeActive (du Appdelegate) afin qu'on exécute la méthode viewDidLoad du LaunchAppViewController et qu'on lance le "sablier" (activityIndicator) pendant le chargement.
    
    
    BOOL hasLogin = [[NSUserDefaults standardUserDefaults] boolForKey:(@"hasLoginKey")];
   
    // S'il n'y a pas d'auto Login
    if (!hasLogin)  // NO
    {
        // Le code ci-dessous permet d'aller directement sur la vue Welcome sans passer par le viewDidLoad de la vue LaunchAppViewControleur
        // Ce code doit être placé ici dans la méthode didFinishLaunchingWithOptions
        
        NSLog(@"didFinishLaunchingWithOptions : AVANT gotoWelcomeVC : pas d'auto Login");
        [self gotoWelcomeViewController];
        
        NSLog(@"didFinishLaunchingWithOptions : APRES gotoWelcomeVC : pas d'auto Login");
        
    }

    NSLog(@"Fin didFinishLaunchingWithOptions : return YES");
    
    return YES;
}


-(void) gotoGeolocForbiddenViewController
{
    // Dans ce cas, on accède au storyboard défini dans le Main.storyboard (ie : accès à WelcomeViewController).
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GeolocForbiddenViewController *geolocForbiddenVC  = [sb instantiateViewControllerWithIdentifier:@"GeolocForbiddenVC"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:geolocForbiddenVC];
    
    // Mise en place du storyboard et Accès à la Home directement
    SWRevealViewController *slidemenu = [sb instantiateViewControllerWithIdentifier:@"MenuTVC"];

    
    // define rear and frontviewcontroller
    SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:slidemenu frontViewController:navController];
    
    self.window.rootViewController = revealController;
    
}



-(void) gotoWelcomeViewController
{
    // Dans ce cas, on accède au storyboard défini dans le Main.storyboard (ie : accès à WelcomeViewController).
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *SWRevealViewController = [sb instantiateViewControllerWithIdentifier:@"SWRevealVC"];
    self.window.rootViewController = SWRevealViewController;
    
}


-(void) gotoHomeViewController
{
    // Mise en place du storyboard et Accès à la Home directement
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *slidemenu = [sb instantiateViewControllerWithIdentifier:@"MenuTVC"];
    
    UIStoryboard* sbHome = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    // this any item in list you want navigate to
    UINavigationController *home = [sbHome instantiateViewControllerWithIdentifier:@"NavHome"];
    
    // define rear and frontviewcontroller
    SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:slidemenu frontViewController:home];
    
    self.window.rootViewController = revealController;
    
}


// auto login (par appel au WS de login) et accès direct à la home
-(void) autoSignInWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [DataManager signInWithUsername:username
                        andPassword:password
                         completion:^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         NSLog(@"LOGIN SUCCESS and AutoSignIn Success: %@", user.email);
         NSLog(@"Password SUCCESS and AutoSignIn Success: %@", user.password);
         
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            
                            //------------------------------
                            // CGIA WARNING
                            // test temporaire en attendant que le WS nous renvoie des code errors
                            // CGIA WARNING
                            //------------------------------
                            
                            if (user.email)
                            {
                                [DataManager user].password = password;
                                
                                if ([DataManager user].picture)
                                {
                                    [ImageManager getImageFromUrlPath:[DataManager user].picture withCompletion:^(UIImage *image)
                                     {
                                         [DataManager user].pictureImage = image;
                                         NSLog(@"[DataManager user].pictureImage : %@",[DataManager user].pictureImage );
                                     }];
                                }
                               ResearchPopupView *RPV = [[ResearchPopupView alloc]init] ;
                                [RPV.activityIndicator stopAnimating];
                                [RPV removeFromSuperview];
                                switch ([CLLocationManager authorizationStatus])
                                {
                                    case kCLAuthorizationStatusNotDetermined:
                                    case kCLAuthorizationStatusDenied:
                                    case kCLAuthorizationStatusRestricted:
                                    {
                                        NSLog(@"sign in geolocforbidden");
                                        [self gotoGeolocForbiddenViewController];
                                        break;
                                        
                                    }
                                        
                                    case kCLAuthorizationStatusAuthorizedWhenInUse:
                                    case kCLAuthorizationStatusAuthorizedAlways:
                                    {
                                        NSLog(@"dispatch: avec auto Login : AVANT gotoHomeViewController");
                                        
                                        // Si WS renvoie OK pour la connexion, alors on accède directement à Home (la carte).
                                        [self gotoHomeViewController];
                                        
                                        NSLog(@"dispatch: avec auto Login : APRES gotoHomeViewController");
                                        
                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                        
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                NSLog(@"dispatch: pas d'auto Login: AVANT gotoWelcomeViewController");
                                
                                // Si WS renvoie KO pour la connexion, alors on accède à Welcome.
                                [self gotoWelcomeViewController];
                                
                                NSLog(@"dispatch: pas d'auto Login: APRES gotoWelcomeViewController");
                                
                            }
                            
                        });
     }];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"DEBUT AppDelegate applicationDidBecomeActive");
    
    if (applicationBecomActiveIsCalledOnce == YES)
    {
        hasLogin = [[NSUserDefaults standardUserDefaults] boolForKey:(@"hasLoginKey")];
        
        applicationBecomActiveIsCalledOnce = NO;
        // S'il y a l'auto Login
        if (hasLogin)
        {
//            switch ([CLLocationManager authorizationStatus])
//            {
//                case kCLAuthorizationStatusNotDetermined:
//                case kCLAuthorizationStatusDenied:
//                case kCLAuthorizationStatusRestricted:
//                {
//                    NSLog(@"sign in geolocforbidden");
//                    [self gotoGeolocForbiddenViewController];
//                    break;
//                    
//                }
//                    
//                case kCLAuthorizationStatusAuthorizedWhenInUse:
//                case kCLAuthorizationStatusAuthorizedAlways:
//                {
                    NSDictionary *userCredentials = [[DataManager sharedInstance] userCredentials];
                    NSString *username = [userCredentials valueForKey:@"username"];
                    NSString *password = [userCredentials valueForKey:@"password"];
                    
                    //Vérification minimum : email et password ne sont pas vides
                    if (![username isEqualToString:@""] && ![password isEqualToString:@""])
                    {
                        
                        NSLog(@"applicationDidBecomeActive: auto Login : autoSignInWithUsername");
                        [self autoSignInWithUsername:username andPassword:password];
                        
                    }
                    else
                    {
                        hasLogin = NO;
                        [self gotoWelcomeViewController];
                    }
//                    
//                    break;
//                }
//            }
        }
    }
    
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
