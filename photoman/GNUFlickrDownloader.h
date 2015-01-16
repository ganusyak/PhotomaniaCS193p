//
//  GNUFlickrDownloader.h
//  photoman
//
//  Created by yuriy ganusyak on 10/27/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Photo;
@class Place;
@interface GNUFlickrDownloader : NSObject
+ (void)downloadPhotosForPlaceID:(Place *)place
          inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                      maxResults:(NSUInteger)maxResults;
@end
