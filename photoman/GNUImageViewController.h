//
//  GNUImageViewController.h
//  FlickrFetch
//
//  Created by yuriy ganusyak on 10/16/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@interface GNUImageViewController : UIViewController

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) Photo *photo;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

