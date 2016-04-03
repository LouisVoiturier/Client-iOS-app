//
//  ValetFakerManager.m
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ValetFakerManager.h"

@implementation ValetFakerManager

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    [sharedInstance initManager];
    return sharedInstance;
}


-(void)initManager
{
    NSArray *firstValetPositions = @[[[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.870423, 2.349212)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.870324, 2.349669)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.870162, 2.350334)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.869811, 2.352107)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.870724, 2.353158)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.871952, 2.353827)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.872355, 2.354133)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.872599, 2.355071)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.872394, 2.355957)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.872149, 2.357435)]
                                     ];
    
    NSDictionary *firstValetDatas = @{@"username":@"first@mail.com",
                                      @"password":@"hallo",
                                      @"name":@{@"first":@"Bradley", @"last":@"Cooper"},
                                      @"cellphone":@"+33620966045",
                                      @"picture":@"http://www.filmosphere.com/wp-content/uploads/2015/03/bradley-cooper-partenaire-de-jennifer-lawrence.jpg",
                                      @"positions":firstValetPositions
                                      };
    
    ValetFaker *firstValet = [[ValetFaker alloc] initWithDictionary:firstValetDatas];
    
    NSArray *secondValetPositions = @[[[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.869758, 2.352451)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.870324, 2.349669)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.870162, 2.350334)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.869811, 2.352107)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.870724, 2.353158)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.871952, 2.353827)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.872355, 2.354133)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.872599, 2.355071)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.872394, 2.355957)],
                                     [[Coords alloc] initWithCLLocation2D:CLLocationCoordinate2DMake(48.872149, 2.357435)]
                                     ];
    
    NSDictionary *secondValetDatas = @{@"username":@"second@mail.com",
                                      @"password":@"hallo",
                                      @"name":@{@"first":@"Henry", @"last":@"Cavill"},
                                      @"cellphone":@"+33620966045",
                                      @"picture":@"http://www.dcplanet.fr/wp-content/uploads/2015/08/henry-cavill.jpg",
                                      @"positions":secondValetPositions
                                      };
    
    ValetFaker *secondValet = [[ValetFaker alloc] initWithDictionary:secondValetDatas];
    self.valetFakers = @[firstValet, secondValet];
}


+(void)requestAValetWithLocation:(CLLocationCoordinate2D)location completion:(valetGetCompletion)compbloc
{
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        [NSThread sleepForTimeInterval:1.0f];
        dispatch_async(dispatch_get_main_queue(), ^{
            compbloc(YES);
        });
    });
}

+(NSArray *)getAllValetsCoords
{
    NSMutableArray *mutableValets = [[NSMutableArray alloc] init];
    for (ValetFaker *item in [ValetFakerManager sharedInstance].valetFakers)
    {
        [mutableValets addObject:[item getFakerCurrentLocation]];
    }
    return mutableValets.copy;
}


@end
