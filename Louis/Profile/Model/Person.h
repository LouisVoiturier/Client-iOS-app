//
//  Person.h
//  WebServiceInterface
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 François Juteau. All rights reserved.
//

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *identifiant;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) UIImage *pictureImage;
@property (nonatomic, strong) NSString *cellPhone;
@property (nonatomic, strong) NSString *gender;

@property (nonatomic) CLLocationCoordinate2D location;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(instancetype)initWithEmail:(NSString *)email
                     andName:(NSDictionary *)name
                andCellPhone:(NSString *)cellPhone
                  andPicture:(NSString *)picture;

//-(instancetype)initWithEmail:(NSString *)email
//                 andPassword:(NSString *)password
//                     andName:(NSDictionary *)name
//                andCellPhone:(NSString *)cellPhone ;

@end
