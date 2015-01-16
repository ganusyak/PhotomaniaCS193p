//
//  Place+Create.h
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "Place.h"

@interface Place (Create)
+ (NSString *)countryNameForPlace:(NSDictionary *)placeDescription;
+ (void)insertPlaces:(NSArray *)places inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Place *)insertPlace:(NSDictionary *)placeDescription inManagedObjectContext:(NSManagedObjectContext *)context;

@end
