//
//  DataManager+Order.h
//  Louis
//
//  Created by François Juteau on 26/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager.h"
#import "Coords.h"

@interface DataManager (Order)

+(void)checkInWithLocation:(Coords *)location completion:(orderPostCompletion)compbloc;
+(void)checkOutWithLocation:(Coords *)location completion:(orderPostCompletion)compbloc;
+(void)deleteCurrentOrderWithcompletion:(orderPostCompletion)compbloc;

+(Order *)order;

@end
