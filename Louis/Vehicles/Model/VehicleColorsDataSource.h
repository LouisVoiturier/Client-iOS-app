//
//  VehicleColorsDataSource.h
//  Louis
//
//  Created by Thibault Le Cornec on 26/06/16.
//  Copyright © 2016 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleColorsDataSource : NSObject

+ (NSUInteger)numberOfColors;

/**
 * @brief Names of all possible colors
 *
 * @warning if a value is added, the corresponding localized name should be added
 * in the `colorsLocalizedNames´ dictionary !
 */
+ (NSArray *)colorsKeysNames;

/** 
 * @brief Names of all possible colors localized
 *
 * @warning if a value is added, the corresponding key name should be added
 * in the `colorsKeysNames´ dictionary !
 */
+ (NSDictionary *)colorsLocalizedNames;

/**
 *  @brief Return the NString of the localized name for the color at the given index.
 *
 *  @param colorIndex Index of the color in the `colorKeysNames´ array
 *
 *  @return Return the NString of the localized name for the color at the given index.
 */
+ (NSString *)localizedNameForColorIndex:(NSUInteger)colorIndex;

/**
 *  @brief Return the NSString of the key name corresponding to the localized
 *  color name given in parameter.
 *
 *  @param colorLocalizedName NSString of localized name for a color
 *
 *  @return Return the NSString of the key name corresponding to the localized
 *  color name given in parameter.
 */
+ (NSString *)colorKeyNameForColorLocalizedName:(NSString *)colorLocalizedName;

/**
 *  @brief Return the index of a color key name corresponding of the localized
 *  color name givent in parameter.
 *
 *  @param colorLocalizedName NSString of localized name for a color
 *
 *  @return Return the index of a color key name corresponding of the localized
 *  color name givent in parameter.
 */
+ (NSUInteger)indexOfColorKeyNameForColorLocName:(NSString *)colorLocalizedName;

/**
 *  @brief Return an NSString of the localized name for the color ket name given
 *  in parameter.
 *
 *  @param colorKeyName NSString of a color key name in `colorKeysNames´
 *
 *  @return Return an NSString of the localized name for the color ket name given
 *  in parameter.
 */
+ (NSString *)colorLocalizedNameForColorKeyName:(NSString *)colorKeyName;

@end
