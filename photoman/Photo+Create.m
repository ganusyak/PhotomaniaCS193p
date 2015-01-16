//
//  Photo+Create.m
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "Photo+Create.h"
#import "Photographer+Create.h"
#import "Place+Create.h"
#import "GNUFlickrFetcher.h"


@implementation Photo (Create)

+ (Photo *)insertPhotoWithDescription:(NSDictionary *)description inContext:(NSManagedObjectContext *)context
{
    
    Photo *photo = nil;
    NSString *photoID = [description valueForKey:FLICKR_PHOTO_ID];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PHOTO_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"photoID = %@", photoID];
    
    NSError *error = nil;
    NSArray *requestResults = [context executeFetchRequest:request error:&error];
    
    if (error || !requestResults || ([requestResults count] > 1)){
        // handle errors
    } else if ([requestResults count]) {
        photo = [requestResults firstObject];
    } else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:PHOTO_ENTITY inManagedObjectContext:context];
        photo.title = [description valueForKey:FLICKR_PHOTO_TITLE];
        photo.photoID = [description valueForKey:FLICKR_PHOTO_ID];
        photo.imageURL = [[GNUFlickrFetcher getFlickrURLforPhoto:description] absoluteString];
        photo.thumbnailURL = [[GNUFlickrFetcher getFlickrThumbnailURLforPhoto:description] absoluteString];
        photo.photoDescription = [description valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.seen = @0;
        NSString *photographerName = [description valueForKey:FLICKR_PHOTO_OWNER];
        photo.photographer = [Photographer insertPhotographerWithName:photographerName inManagedObjectContext:context];
        
    }
    
    return photo;
}

+ (void)insertArrayOfPhotos:(NSArray *)array inContext:(NSManagedObjectContext *)context{
    for (NSDictionary *photo in array){
        [self insertPhotoWithDescription:photo inContext:context];
        // NSLog(@"Photo with title %@ added", [photo valueForKey:FLICKR_PHOTO_TITLE]);
    }
}

+ (void)insertArrayOfPhotos:(NSArray *)array capturedAtPlace:(Place *)place inContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *photo in array){
        Photo *newPhoto = [self insertPhotoWithDescription:photo inContext:context];
        newPhoto.place = place;
    }
}

- (void)updateViewsCounter
{
    self.seen = [NSNumber numberWithInteger:[self.seen integerValue] + 1];
    self.lastOpened = [NSDate date];
}

@end
