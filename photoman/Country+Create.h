//
//  Country+Create.h
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "Country.h"

@interface Country (Create)

+ (Country *)insertCountryWithName:(NSString *)countryName inManagedObjectContext:(NSManagedObjectContext *)context;

@end
