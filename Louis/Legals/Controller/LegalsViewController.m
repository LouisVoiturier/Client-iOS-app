//
//  LegalsViewController.m
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "LegalsViewController.h"
#import "Common.h"

@interface LegalsViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@end

@implementation LegalsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Titre de la fenetre : %@",self.titleInLegalsVC);
    [self setTitle:NSLocalizedString(self.titleInLegalsVC,nil)];
    
    // ===== Menu Configuration ===== //
    [self configureSWRevealViewControllerForViewController:self
                                            withMenuButton:[self menuButton]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // charge la page en fonction de l'URL
    [self downloadFromURL];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}


- (void)downloadFromURL
{
    // UIWebview ne fonctionne qu'avec des URL en https (à vérifier)
    // Url apple par défaut
    NSURL *myURL = [NSURL URLWithString:@"https://store.apple.com/Catalog/fr/Images/salespolicies_institution.html"];
    if ([self.titleInLegalsVC isEqualToString:@"Menu-Help"])
    {
         myURL = [NSURL URLWithString:NSLocalizedString(@"URL-Help", nil)];
        [GAI sendScreenViewWithName:@"Support"];
    }
    if ([self.titleInLegalsVC isEqualToString:@"Menu-CGV"])
    {
         myURL = [NSURL URLWithString:NSLocalizedString(@"URL-CGV", nil)];
        [GAI sendScreenViewWithName:@"Terms"];
    }
    if ([self.titleInLegalsVC isEqualToString:@"Menu-Legals"])
    {
         myURL = [NSURL URLWithString:NSLocalizedString(@"URL-Legals", nil)];
        [GAI sendScreenViewWithName:@"Legals"];
    }

    NSURLRequest *myNSURLRequest = [NSURLRequest requestWithURL:myURL];
    [_myWebView loadRequest:myNSURLRequest];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
