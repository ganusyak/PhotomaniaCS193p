//
//  Photo.h
//  photoman
//
//  Created by yuriy ganusyak on 10/27/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer, Place;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSString * photoID;
@property (nonatomic, retain) NSNumber * seen;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * lastOpened;
@property (nonatomic, retain) Photographer *photographer;
@property (nonatomic, retain) Place *place;

@end
