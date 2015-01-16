//
//  GNUFlickrFetch.m
//  FlickrFetch
//
//  Created by yuriy ganusyak on 10/16/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "GNUFlickrFetcher.h"
@interface GNUFlickrFetcher ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation GNUFlickrFetcher



+ (NSURL *)URLForQuery:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=%@", query, FLICKR_API_KEY];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:query];
}

+ (NSURL *)URLforTopPlaces

{
    return [self URLForQuery:@"https://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7"];
}

+ (NSURL *)URLforPhotosInPlace:(id)flickrPlaceId maxResults:(NSUInteger)maxResults;
{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&place_id=%@&per_page=%lu&extras=original_format,tags,description,geo,date_upload,owner_name,place_url", flickrPlaceId, (unsigned long)maxResults]];
}

+ (NSString *)URLPrefix
{
    return @"https://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList";
}

+ (NSURL *)sessionURL
{
    NSString *resultString = [NSString stringWithFormat:@"%@&place_type_id=7&format=json&nojsoncallback=1&api_key=%@", [self URLPrefix], FLICKR_API_KEY];
    return [NSURL URLWithString:resultString];
}

+ (NSURL *)getURLforPlaceInfo:(NSString *)placeID
{
    NSString *requestURL =[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.places.getInfo&place_id=%@&format=json&nojsoncallback=1&api_key=%@", placeID, FLICKR_API_KEY];
    return [NSURL URLWithString:requestURL];
}

+ (NSURL *)getFlickrURLforPhoto:(NSDictionary *)photoDictionary
{
    NSString *farm_id = [photoDictionary objectForKey:FLICKR_FARM_ID];
    NSString *server_id = [photoDictionary objectForKey:FLICKR_SERVER_ID];
    NSString *photo_id = [photoDictionary objectForKey:FLICKR_PHOTO_ID];
    NSString *secret = [photoDictionary objectForKey:FLICKR_PHOTO_SECRET];
    NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",farm_id, server_id, photo_id, secret];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
}

+ (NSURL *)getFlickrThumbnailURLforPhoto:(NSDictionary *)photoDictionary
{
    NSString *farm_id = [photoDictionary objectForKey:FLICKR_FARM_ID];
    NSString *server_id = [photoDictionary objectForKey:FLICKR_SERVER_ID];
    NSString *photo_id = [photoDictionary objectForKey:FLICKR_PHOTO_ID];
    NSString *secret = [photoDictionary objectForKey:FLICKR_PHOTO_SECRET];
    NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_q.jpg",farm_id, server_id, photo_id, secret];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
}



- (NSURLSession *)session
{
    if (!_session){
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    
    return _session;
}
@end
