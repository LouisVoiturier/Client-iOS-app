//
//  LaunchAppViewController.m
//  Louis
//
//  Created by Giang Christian on 09/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//


#import "LaunchAppViewController.h"

@interface LaunchAppViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myActivityIndicatorView;

@end

@implementation LaunchAppViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    NSLog(@"LaunchAppViewContoller viewdidload");
    
    [_myActivityIndicatorView startAnimating];
    

}

- (void)didReceiveMemoryWarning {
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
