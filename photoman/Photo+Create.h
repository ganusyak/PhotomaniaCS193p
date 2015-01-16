//
//  Photo+Create.h
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "Photo.h"
#define PHOTO_ENTITY @"Photo"

@interface Photo (Create)

+ (Photo *)insertPhotoWithDescription:(NSDictionary *)description inContext:(NSManagedObjectContext *)context;
+ (void)insertArrayOfPhotos:(NSArray *)array inContext:(NSManagedObjectContext *)context;
+ (void)insertArrayOfPhotos:(NSArray *)array capturedAtPlace:(Place *)place inContext:(NSManagedObjectContext *)context;
- (void)updateViewsCounter;
@end
