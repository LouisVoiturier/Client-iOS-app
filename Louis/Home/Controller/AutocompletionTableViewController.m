//
//  AutocompletionTableViewController.m
//  Louis
//
//  Created by François Juteau on 06/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "AutocompletionTableViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Common.h"
#import "HomeViewController.h"

@interface AutocompletionTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSArray *autocompleteArray;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) GMSPlacesClient *placesClient;

//@property (nonatomic, strong) UIStoryboardSegue *unwindSegue;

/** Google view */
@property (nonatomic, strong) UIView *googleFooterView;
@property (nonatomic, strong) UILabel *poweredLabel;
@property (nonatomic, strong) UIImageView *googleImageView;


@end

@implementation AutocompletionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Searchbar configuration
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = [UIColor louisMainColor];
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeyGo;
    self.searchBar.placeholder = NSLocalizedString(@"SearchBar-Placeholder", nil);
    
    [self.navigationItem setTitleView:self.searchBar];
    self.navigationItem.hidesBackButton = YES;
    
    self.placesClient = [[GMSPlacesClient alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    /******************************/
    /***** GOOGLE FOOTER VIEW *****/
    /******************************/
    _googleFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    _poweredLabel = [[UILabel alloc] init];
    _poweredLabel.text = @"powered by ";
    _poweredLabel.textAlignment = NSTextAlignmentRight;
    _poweredLabel.font = [UIFont louisMediumLabel];
    
    [_poweredLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_googleFooterView addSubview:_poweredLabel];
    
    _googleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GoogleLogo"]];
    
    [_googleImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_googleFooterView addSubview:_googleImageView];
    _googleFooterView.hidden = YES;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_poweredLabel, _googleImageView);
 
    // Horizontale
    [_googleFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_poweredLabel][_googleImageView(50)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    [_googleFooterView addConstraint:[NSLayoutConstraint constraintWithItem:_poweredLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_googleFooterView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.f
                                                                  constant:-1.5f]];
    
    [_googleFooterView addConstraint:[NSLayoutConstraint constraintWithItem:_googleImageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_googleFooterView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.f
                                                                  constant:0.f]];
    
    [self.tableView setTableFooterView:_googleFooterView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
    [GAI sendScreenViewWithName:@"Search Address"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.autocompleteArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    GMSAutocompletePrediction *autoPrediction = [self.autocompleteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = autoPrediction.attributedFullText.string;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Très moche mais efficace
    HomeViewController *parentViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    GMSAutocompletePrediction *autoPrediction = [self.autocompleteArray objectAtIndex:indexPath.row];
    
    [parentViewController changeLocalizationWithAdress:autoPrediction.attributedFullText.string];
    
    [GAI sendEvent:[GAIDictionaryBuilder createEventWithCategory:@"Search"
                                                          action:@"Autocomplete"
                                                           label:autoPrediction.attributedFullText.string
                                                           value:nil]];
    
    [self.navigationController popToViewController:parentViewController animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


#pragma mark - UISearchBar delegate methods

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    
    // Coordonnées approximatives de paris
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(48.898032, 2.250942)
                                                                       coordinate:CLLocationCoordinate2DMake(48.815831, 2.417450)];
    
    [_placesClient autocompleteQuery:searchBar.text
                              bounds:bounds
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil)
                                {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                }
                            
                                for (GMSAutocompletePrediction* result in results)
                                {
                                    NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                                }
                                
                                self.autocompleteArray = results;
                                dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    // On affiche le logo google uniquement si il y a des éléments dans le tableau
                                    if (self.autocompleteArray.count > 0)
                                    {
                                        self.googleFooterView.hidden = NO;
                                    }
                                    else
                                    {
                                        self.googleFooterView.hidden = YES;
                                    }
                                    
                                    [self.tableView reloadData];
                                });
                            }];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // Très moche mais efficace
    HomeViewController *parentViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    [self.searchBar resignFirstResponder];
    [self.navigationController popToViewController:parentViewController animated:YES];
}

@end
