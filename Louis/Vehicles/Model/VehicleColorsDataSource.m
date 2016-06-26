//
//  VehicleColorsDataSource.m
//  Louis
//
//  Created by Thibault Le Cornec on 26/06/16.
//  Copyright © 2016 Louis. All rights reserved.
//

#import "VehicleColorsDataSource.h"


static NSArray *colorsKeysNames;
static NSDictionary *colorsLocalizedNames;


@implementation VehicleColorsDataSource

+ (void)initDataIfNeeded
{
    if (colorsKeysNames == nil) {
        colorsKeysNames = [VehicleColorsDataSource colorsKeysNames];
    }
    
    if (colorsLocalizedNames == nil) {
        colorsLocalizedNames = [VehicleColorsDataSource colorsLocalizedNames];
    }
}


+ (NSUInteger)numberOfColors
{
    [VehicleColorsDataSource initDataIfNeeded];
    return [colorsKeysNames count];
}


+ (NSArray *)colorsKeysNames
{
    return @[[NSNull null],
             @"White",
             @"Black",
             @"Grey",
             @"Red",
             @"Blue",
             @"Yellow",
             @"Green",
             @"Brown",
             @"Other" ];
}


+ (NSDictionary *)colorsLocalizedNames
{
    return @{@"White"  : NSLocalizedString(@"White", nil),
             @"Black"  : NSLocalizedString(@"Black", nil),
             @"Grey"   : NSLocalizedString(@"Grey", nil),
             @"Red"    : NSLocalizedString(@"Red", nil),
             @"Blue"   : NSLocalizedString(@"Blue", nil),
             @"Yellow" : NSLocalizedString(@"Yellow", nil),
             @"Green"  : NSLocalizedString(@"Green", nil),
             @"Brown"  : NSLocalizedString(@"Brown", nil),
             @"Other"  : NSLocalizedString(@"Other", nil)  };
}


+ (NSString *)localizedNameForColorIndex:(NSUInteger)colorIndex
{
    [VehicleColorsDataSource initDataIfNeeded];
    
    if ([[colorsKeysNames objectAtIndex:colorIndex] isEqual:[NSNull null]] == NO) {
        NSString *keyNameForColor = [colorsKeysNames objectAtIndex:colorIndex];
        NSAssert([colorsLocalizedNames objectForKey:keyNameForColor] != nil, @"***** ERROR : The key color \"%@\" doesn't exist !", keyNameForColor);
        return [colorsLocalizedNames objectForKey:keyNameForColor];
    }
    
    return nil;
}


+ (NSString *)colorKeyNameForColorLocalizedName:(NSString *)colorLocalizedName
{
    [VehicleColorsDataSource initDataIfNeeded];
    return [[colorsLocalizedNames allKeysForObject:colorLocalizedName] firstObject];
}


+ (NSUInteger)indexOfColorKeyNameForColorLocName:(NSString *)colorLocalizedName
{
    [VehicleColorsDataSource initDataIfNeeded];
    NSString *colorKeyName = [VehicleColorsDataSource colorKeyNameForColorLocalizedName:colorLocalizedName];
    return [colorsKeysNames indexOfObject:colorKeyName];
}

+ (NSString *)colorLocalizedNameForColorKeyName:(NSString *)colorKeyName
{
    [VehicleColorsDataSource initDataIfNeeded];
    return [colorsLocalizedNames objectForKey:colorKeyName];
}

@end
