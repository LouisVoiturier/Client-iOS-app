//
//  DataManager+ServiceHours.m
//  Louis
//
//  Created by François Juteau on 08/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DataManager+ServiceHours.h"
#import "NetworkManager.h"

@implementation DataManager (ServiceHours)

+(void)getServiceHoursCompletion:(hourGetCompletion)completionBlock
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    [[NetworkManager sharedInstance] getDataForKey:@"hour"
                                       forUsername:[[dataManager user] email]
                                       andPassword:[[dataManager user] password]
                               withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         if (!error)
         {
             dataManager.serviceHoursDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         }
         completionBlock(httpResponse, error);
     }];
}


+(void)getNextOpenhourCompletion:(nextHourGetCompletion)completionBlock
{
    [DataManager getServiceHoursCompletion:^(NSHTTPURLResponse *httpResponse, NSError *error)
    {
        completionBlock([DataManager getMessageForServiceHourAvailability], httpResponse, error);
    }];
}


+(NSString *)getMessageForServiceHourAvailability
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:today];
    NSInteger weekDayNumber = comps.weekday;
    NSInteger hour = comps.hour;
    
    NSArray *weekDayConverter = @[@"", @"sun", @"mon", @"tue", @"wed", @"thu", @"fri", @"sat"];
    
    NSString *weekDayString = [weekDayConverter objectAtIndex:weekDayNumber];
    NSLog(@"WEEKDAY : %ld, HOUR : %ld, serviceDIc : %@", (long)weekDayNumber, (long)hour, dataManager.serviceHoursDic);
    
    /********************/
    /***** FJUTEAU TEST *****/
    /********************/
    NSDictionary *testPlanning = @{@"mon":@{@"open":@"0:00", @"close":@"23:59"},
                                   @"tue":@{@"open":@"0:00", @"close":@"23:59"},
                                   @"wed":@{@"open":@"0:00", @"close":@"23:59"},
                                   @"thu":@{@"open":@"0:00", @"close":@"23:59"},
                                   @"fri":@{@"open":@"0:00", @"close":@"23:59"},
                                   @"sat":@{@"open":@"0:00", @"close":@"23:59"},
                                   @"sun":@{@"open":@"0:00", @"close":@"23:59"}};
    NSDictionary *todaysHours = [testPlanning objectForKey:weekDayString];
    
    // Horaire du service aujourd'hui A DECOMMENTER *******************************
//    NSDictionary *todaysHours = [dataManager.serviceHoursDic objectForKey:weekDayString];
    
    // On check si le service est actuellement ouvert
    BOOL afterOpen = [DataManager isServiceHourString:[todaysHours objectForKey:@"open"] beforeHourNowComponents:comps];
    BOOL beforeClose = ![DataManager isServiceHourString:[todaysHours objectForKey:@"close"] beforeHourNowComponents:comps];
    BOOL isOpen = afterOpen && beforeClose;
    
    if (isOpen)
    {
        return @"";
    }
    else
    {
        if (!afterOpen) // Si le service ouvre plus tard dans la journée
        {
            NSString *nextHour = [[testPlanning objectForKey:[weekDayConverter objectAtIndex:weekDayNumber]] objectForKey:@"open"];
            return [NSString stringWithFormat:@"Réouverture prévue à partir de %@", nextHour];
        }
        else  // Si le service ouvre un autre jour
        {
            if (weekDayNumber > 7)
            {
                weekDayNumber = 1;
            }
            else
            {
                weekDayNumber++;
            }
            NSString *nextHour = [[testPlanning objectForKey:[weekDayConverter objectAtIndex:weekDayNumber]] objectForKey:@"open"];
            NSString *localizedIdentifier = [NSString stringWithFormat:@"Home-HourService-WeekDay-%ld", (long)weekDayNumber];
            return [NSString stringWithFormat:@"Réouverture prévue %@ à partir de %@", NSLocalizedString(localizedIdentifier, @""), nextHour];
        }
        
    }
    return nil;
}


+(BOOL)isServiceHourString:(NSString *)string beforeHourNowComponents:(NSDateComponents *)components
{
    // Le format du webservice est HH:MM
    NSArray *hourStringArray = [string componentsSeparatedByString:@":"];
    NSInteger hour = [(NSString *)[hourStringArray objectAtIndex:0] integerValue];
    NSInteger minute = [(NSString *)[hourStringArray objectAtIndex:1] integerValue];
    NSLog(@"Service Hour : %ld, minutes : %ld\nActual Hour : %ld, minutes : %ld", (long)hour, (long)minute, (long)components.hour, (long)components.minute);
    
    BOOL hourCompare = hour < components.hour; // l'heure du service est inférieur à l'heure actuelle
    BOOL minuteCompare = minute < components.minute; // la minute du service est inférieur à la minute actuelle
    BOOL hourEgal = (hour == components.hour); // On veut savoir si les heures sont égales pour comparer les minutes
    
    return hourCompare || (hourEgal && minuteCompare);
}

@end
