//
//  GNUShowRecentlyViewedPhotos.m
//  photoman
//
//  Created by yuriy ganusyak on 10/27/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "GNUShowRecentlyViewedPhotos.h"
#import "GNUImageViewController.h"
#import "AppDelegate.h"
#import "Photo.h"
#import "GNUCoreDataKeys.h"

@interface GNUShowRecentlyViewedPhotos ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Photo *selection;

@end

@implementation GNUShowRecentlyViewedPhotos

static NSString *recentPhotoSegueIdentifier = @"Show Recent Photo";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    // Up to 20 photos, opened at least once, sorted by last view time
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PHOTO_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"seen > %d", 0];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:LAST_OPENED_KEY ascending:NO]];
    request.fetchLimit = 20;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recent Photos Cell" forIndexPath:indexPath];

    cell = [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (UITableViewCell *)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Photo *cellPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = cellPhoto.title;
    cell.detailTextLabel.text = [self dateStringForDate:cellPhoto.lastOpened];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)dateStringForDate:(NSDate *)date
{
    NSString *dateString = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateString = [dateFormatter stringFromDate:date];

    return dateString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selection = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // different seques for ipad & iphone
    if (self.splitViewController.viewControllers.count > 1){
        GNUImageViewController *detail = self.splitViewController.viewControllers[1];
        detail.photo = self.selection;
    } else {
        [self performSegueWithIdentifier:recentPhotoSegueIdentifier sender:self];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:recentPhotoSegueIdentifier]){
        if ([[segue destinationViewController] isKindOfClass:[GNUImageViewController class]]){
            GNUImageViewController *vc = (GNUImageViewController *)[segue destinationViewController];
            [vc setPhoto:self.selection];
            [vc setTitle:self.selection.title];
        }
    } 
}


@end
