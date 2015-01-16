//
//  GNUImageViewController.m
//  FlickrFetch
//
//  Created by yuriy ganusyak on 10/16/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "GNUImageViewController.h"
#import "GNUFlickrFetcher.h"
#import "Photo.h"

@interface GNUImageViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) NSURLSession *session;

@end

@implementation GNUImageViewController

# pragma mark - controller lyfecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.photo.title;
    [self.progressView setProgress:0.0];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.progressView setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.25f alpha:1.0f]];
}

# pragma mark - accessors

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    
    self.managedObjectContext = self.photo.managedObjectContext;
    self.imageURL = [NSURL URLWithString:self.photo.imageURL];
    
    [self resetUI];
    [self updatePhotoViewsCounter:photo];
    [self startDownloadingImage:self.imageURL];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

- (NSURLSession *)session
{
    if (!_session){
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}

# pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUIwithImage:image];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
}

# pragma mark - helpers

- (void)startDownloadingImage:(NSURL *)url
{
    [self.activityIndicator setHidden:NO];
    [self.progressView setHidden:NO];
    [[self.session downloadTaskWithURL:url] resume];
}

- (void)updateUIwithImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.activityIndicator setHidden:YES];
    [self.progressView setHidden:YES];
}

- (void)resetUI
{
    self.imageView.image = nil;
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.progressView setHidden:NO];
    [self.progressView setProgress:0.0];
}

- (void)updatePhotoViewsCounter:(Photo *)photo
{
    NSInteger counter = [photo.seen intValue];
    photo.seen = [NSNumber numberWithInteger:counter + 1];
    photo.lastOpened = [NSDate date];
}


@end
