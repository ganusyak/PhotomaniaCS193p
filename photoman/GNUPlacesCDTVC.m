    //
//  GNUPlacesCDTVC.m
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "GNUPlacesCDTVC.h"
#import "GNUPlacePhotosCDTVC.h"
#import "AppDelegate.h"
#import "Place.h"

@interface GNUPlacesCDTVC ()
@property (nonatomic, strong) Place *selection;
@end

@implementation GNUPlacesCDTVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.title = @"Popular places";
}

#pragma mark - accessors

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    [self setupFetchedResultsController];
}


#pragma mark - UITableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Places Cell" forIndexPath:indexPath];
    
    Place *cellPlace = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = cellPlace.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu photos",(unsigned long)[cellPlace.photos count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    self.selection = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [self performSegueWithIdentifier:@"Show Place Photos Table" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Place Photos Table"]){
        if ([[segue destinationViewController] isKindOfClass:[GNUPlacePhotosCDTVC class]]){
            GNUPlacePhotosCDTVC *vc = (GNUPlacePhotosCDTVC *)[segue destinationViewController];
            [vc setPlace:self.selection];
            [vc setTitle:self.selection.name];
        }
    }
}

#pragma mark - helpers

- (void)setupFetchedResultsController
{
    // Flickr most popular places, sectioned by Country name
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    
    request.predicate = nil;
    NSSortDescriptor *countrySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"country.countryName" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *placeSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)];
    request.sortDescriptors = @[countrySortDescriptor, placeSortDescriptor];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"country.countryName" cacheName:nil];
}

@end
