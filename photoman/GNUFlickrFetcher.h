//
//  GNUFlickrFetch.h
//  FlickrFetch
//
//  Created by yuriy ganusyak on 10/16/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKR_API_KEY @"86c73cdf274ccf7394d25901636a4854"

#define FLICKR_RESULTS_PHOTOS @"photos.photo"

#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_OWNER @"ownername"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"

#define FLICKR_FARM_ID @"farm"
#define FLICKR_SERVER_ID @"server"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_SECRET @"secret"



@interface GNUFlickrFetcher : NSObject
+ (NSURL *)URLForQuery:(NSString *)query;
+ (NSURL *)URLforTopPlaces;

+ (NSURL *)sessionURL;
+ (NSURL *)getFlickrURLforPhoto:(NSDictionary *)photoDictionary;
+ (NSURL *)getFlickrThumbnailURLforPhoto:(NSDictionary *)photoDictionary;
+ (NSURL *)getURLforPlaceInfo:(NSString *)placeID;
+ (NSURL *)URLforPhotosInPlace:(id)flickrPlaceId maxResults:(NSUInteger)maxResults;

@end
