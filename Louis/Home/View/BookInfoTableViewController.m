//
//  BookInfoTableViewController.m
//  Louis
//
//  Created by François Juteau on 09/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "BookInfoTableViewController.h"
#import "BookInfoTableViewCell.h"
#import "DataManager+User_Vehicles.h"
#import "DataManager+User_Cards.h"
#import "Vehicle.h"
#import "STPCard+Helper.h"
#import "UIColor+Louis.h"
#import "BookInfoSection.h"

@interface BookInfoTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *descsTextsArray;

@property (nonatomic, strong) NSArray *valuesTextsArray;

@property (nonatomic, strong) NSArray *pickerDataSource;

@end

@implementation BookInfoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerClass:[BookInfoTableViewCell class] forCellReuseIdentifier:@"BookInfoTableViewCell"];
    

    /***********************/
    /***** PIKCER VIEW *****/
    /***********************/
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
    
    self.pickerView.delegate = self;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.hidden = YES;
    
    [self.tableView addSubview:self.pickerView];
    
    
    /************************/
    /***** DESCRIPTIONS *****/
    /************************/
    //    self.descsTextsArray = @[NSLocalizedString(@"", @""), NSLocalizedString(@"", @""), NSLocalizedString(@"", @"")];
    self.descsTextsArray = @[NSLocalizedString(@"Home-Bottom-Table-CellTitle-Vehicle", @""),
                             NSLocalizedString(@"Home-Bottom-Table-CellTitle-Card", @""),
                             NSLocalizedString(@"Home-Bottom-Table-CellTitle-Price", @"")];
    
    [self reloadData];
    
}

#pragma mark - Extern methods

-(void)changeCurrentSelectedRowValueToPickerValue
{
    NSIndexPath *selectedIndex = self.tableView.indexPathForSelectedRow;
    BookInfoTableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:selectedIndex];
    selectedCell.valueLabel.text = [[self.pickerDataSource objectAtIndex:[self.pickerView selectedRowInComponent:0]] infosResume];
}

-(void)reloadData
{
    /********************/
    /***** VALUES *******/
    /********************/
    NSString *paymentValue, *vehicleValue;
    
    if ([DataManager userVehicles] && [[DataManager userVehicles] firstObject]  )
    {
        vehicleValue = [[[DataManager userVehicles] firstObject] infosResume];
    }
    else
    {
        vehicleValue =  NSLocalizedString(@"Home-Bottom-Table-NoVehicle", @"");
    }
    
    if ([DataManager userCreditCards] && [[DataManager userCreditCards] firstObject])
    {
        paymentValue = [[[DataManager userCreditCards] firstObject] infosResume];
    }
    else
    {
        paymentValue =  NSLocalizedString(@"Home-Bottom-Table-NoCards", @"");
    }
    
    NSString *tarifsValue = @"5€/heure";
    
    self.valuesTextsArray = @[vehicleValue, paymentValue, tarifsValue];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.descsTextsArray)
    {
        return self.descsTextsArray.count;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BookInfoSection *sectionView = [[BookInfoSection alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookInfoTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.descLabel.text = [self.descsTextsArray objectAtIndex:indexPath.row];
    cell.valueLabel.text = [self.valuesTextsArray objectAtIndex:indexPath.row];
    
    switch (indexPath.row)
    {
        case 0:
            if ([DataManager userVehicles].count < 2)  // Si on a plus d'un véhicule, on affiche l'arrowDown
            {
                cell.arrowDownImageView.hidden = YES;
            }
            else
            {
                cell.arrowDownImageView.hidden = NO;
            }
            break;
            
        case 1:
            if ([DataManager userCreditCards].count < 2)  // Si on a plus d'une carte, on affiche l'arrowDown
            {
                cell.arrowDownImageView.hidden = YES;
            }
            else
            {
                cell.arrowDownImageView.hidden = NO;
            }
            break;
            
        case 2:  // Il n'y a pas de picker sur le prix donc pas d'arrowDown
            cell.arrowDownImageView.hidden = YES;
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.pickerDataSource = nil;
    switch (indexPath.row)
    {
        case 0:
            self.pickerDataSource = [DataManager userVehicles];
            
            break;
            
        case 1:
            self.pickerDataSource = [DataManager userCreditCards];
            break;
            
        case 2:
            self.pickerDataSource = nil;
            break;
            
        default:
            break;
    }
    
    
    if (self.pickerDataSource && self.pickerDataSource.count > 1 ) // On active le picker uniquement si il y a plusieurs données
    {
        self.pickerView.hidden = NO;
        [self.pickerView reloadAllComponents];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"BookButtonStateChange"
         object:self];
    }
}
    


#pragma mark - PickerView delegate methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerDataSource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.pickerDataSource objectAtIndex:row] infosResume];
}

@end
