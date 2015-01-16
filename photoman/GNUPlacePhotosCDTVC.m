//
//  GNUPlacePhotosCDTVC.m
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "GNUPlacePhotosCDTVC.h"
#import "GNUFlickrFetcher.h"
#import "GNUImageViewController.h"
#import "GNUImageScrollViewController.h"
#import "AppDelegate.h"
#import "GNUFlickrDownloader.h"
#import "Place.h"
#import "Photo.h"

@interface GNUPlacePhotosCDTVC ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableDictionary *cashedImages;
@property (nonatomic, strong) Photo *selection;

@end

@implementation GNUPlacePhotosCDTVC

#pragma mark - accessors

- (NSDictionary *)cashedImages
{
    if (!_cashedImages) _cashedImages = [[NSMutableDictionary alloc] init];
    return _cashedImages;
}

- (void)setPlace:(Place *)place
{
    _place = place;
    
    [self setupFetchResultsController];
    
    [GNUFlickrDownloader downloadPhotosForPlaceID:self.place
                           inManagedObjectContext:self.managedObjectContext
                                       maxResults:50];
}



#pragma mark - UITableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"venue";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                 forIndexPath:indexPath];
    
    cell = [self configureTableViewCell:cell atIndexPath:indexPath];

    return cell;
}



#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    self.selection = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // different seques for ipad & iphone
    if (self.splitViewController.viewControllers.count > 1){
        GNUImageViewController *detail = self.splitViewController.viewControllers[1];
        detail.photo = self.selection;
    } else {
        [self performSegueWithIdentifier:@"Show Image" sender:self];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Image"]){
        if ([[segue destinationViewController] isKindOfClass:[GNUImageViewController class]]){
            GNUImageViewController *vc = (GNUImageViewController *)[segue destinationViewController];
            [vc setPhoto:self.selection];

        }
    } else if ([segue.identifier isEqualToString:@"Scroll"]){
        if ([segue.destinationViewController isKindOfClass:[GNUImageScrollViewController class]]){
            GNUImageScrollViewController *vc = (GNUImageScrollViewController *)[segue destinationViewController];
            [vc setPhoto:self.selection];
        }
    }
}

#pragma mark - helpers

- (UITableViewCell *)configureTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Photo *cellPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *identifier = cellPhoto.thumbnailURL;
    
    if ([self.cashedImages objectForKey:identifier]){
        cell.imageView.image = [self.cashedImages valueForKey:identifier];
    } else {
        NSURL *thumbnailURL = [NSURL URLWithString:cellPhoto.thumbnailURL];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:thumbnailURL];
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cashedImages setValue:image forKey:identifier];
                cell.imageView.image = [self.cashedImages valueForKey:identifier];
                [cell setNeedsLayout];
            });
        });
    }
    
    cell.textLabel.text = cellPhoto.title.length ? cellPhoto.title : cellPhoto.photoDescription;
    cell.detailTextLabel.text = cellPhoto.photoDescription.length ? cellPhoto.photoDescription : @"Empty description";
    
    return cell;
}

- (void)setupFetchResultsController
{
    // All photos (from local databade) for current place, sorted alphabetically
    self.managedObjectContext = self.place.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"place.name == %@", self.place.name];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil cacheName:nil];
}

@end
