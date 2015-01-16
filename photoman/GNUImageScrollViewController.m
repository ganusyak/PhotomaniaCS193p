//
//  GNUImageScrollViewController.m
//  photoman
//
//  Created by yuriy ganusyak on 10/26/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "GNUImageScrollViewController.h"
#import "Photo+Create.h"

@interface GNUImageScrollViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GNUImageScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}
#pragma mark - Properties


- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    self.imageURL = [NSURL URLWithString:photo.imageURL];

    [photo updateViewsCounter];
    NSLog(@"%@", photo.seen);
}
// lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

// image property does not use an _image instance variable
// instead it just reports/sets the image in the imageView property
// thus we don't need @synthesize even though we implement both setter and getter

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image; // does not change the frame of the UIImageView
    [self.imageView sizeToFit];   // update the frame of the UIImageView
    
    // self.scrollView could be nil on the next line if outlet-setting has not happened yet
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    //[self.scrollView setContentMode:UIViewContentModeScaleAspectFit];
    [self setupScrollViewZoomScale];
}

- (void)setupScrollViewZoomScale
{

    CGFloat zoomScale = MIN(self.scrollView.bounds.size.width / self.image.size.width,
                            self.scrollView.bounds.size.height / self.image.size.height);
    self.scrollView.minimumZoomScale = zoomScale;
    self.scrollView.zoomScale = zoomScale;
    self.scrollView.maximumZoomScale = 10.0;
    //self.imageView.center = self.scrollView.center;
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setupScrollViewZoomScale];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    _scrollView.delegate = self;
    [self.scrollView setContentMode:UIViewContentModeScaleAspectFit];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

#pragma mark - UIScrollViewDelegate

// mandatory zooming method in UIScrollViewDelegate protocol

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


#pragma mark - Setting the Image from the Image's URL

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    //    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]]; // blocks main queue!
    [self startDownloadingImage:imageURL];
}

- (void)startDownloadingImage:(NSURL *)imageURL
{
    self.image = nil;
    
    if (imageURL){
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error){
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            } else {
                NSLog(@"Error downloading image");
            }

        }];
        [dataTask resume];
    }
    
    

}


@end
