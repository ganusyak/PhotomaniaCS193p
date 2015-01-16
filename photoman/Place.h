//
//  Place.h
//  photoman
//
//  Created by yuriy ganusyak on 10/27/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * placeID;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
