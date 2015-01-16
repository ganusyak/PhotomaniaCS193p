//
//  Country.h
//  photoman
//
//  Created by yuriy ganusyak on 10/27/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * countryID;
@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSSet *places;
@end

@interface Country (CoreDataGeneratedAccessors)

- (void)addPlacesObject:(Place *)value;
- (void)removePlacesObject:(Place *)value;
- (void)addPlaces:(NSSet *)values;
- (void)removePlaces:(NSSet *)values;

@end
