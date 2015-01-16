//
//  GNUFlickrDownloader.m
//  photoman
//
//  Created by yuriy ganusyak on 10/27/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "GNUFlickrDownloader.h"
#import "GNUFlickrFetcher.h"
#import "Place+Create.h"
#import "Photo+Create.h"

@interface GNUFlickrDownloader ()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation GNUFlickrDownloader

+ (void)downloadPhotosForPlaceID:(Place *)place
          inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                      maxResults:(NSUInteger)maxResults
{
    NSString *placeID = place.placeID;
    NSURL *requestURL = [GNUFlickrFetcher URLforPhotosInPlace:placeID
                                                   maxResults:maxResults];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:requestURL
                                                                 completionHandler:^(NSData *data,
                                                                                     NSURLResponse *response,
                                                                                     NSError *error) {
        if (!error){
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:nil];
            NSArray *resultsArray = [jsonDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Photo insertArrayOfPhotos:resultsArray
                           capturedAtPlace:place
                                 inContext:managedObjectContext];
            });
        } else {
            // handle error
        }
        
    }];
    [dataTask resume];
}

@end
