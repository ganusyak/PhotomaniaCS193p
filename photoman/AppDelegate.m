//
//  AppDelegate.m
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "AppDelegate.h"
#import "GNUFlickrFetcher.h"
#import "Place+Create.h"
#import "Photo+Create.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation AppDelegate

- (NSURLSession *)session
{
    if (!_session){
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }

    return _session;
}


- (NSArray *)flickrPhotosWithURL:(NSURL *)flickrURL
{
    NSArray *resultsArray = nil;
    
    
    
    return resultsArray;
}

- (void)performFetchWithURL:(NSURL *)fetchURL
{
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:fetchURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *placesArray = [jsonDictionary valueForKeyPath:@"places.place"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Place insertPlaces:placesArray inManagedObjectContext:self.managedObjectContext];
            });
        } else {
            // handle error
        }
        
    }];
    [dataTask resume];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self performFetchWithURL:[GNUFlickrFetcher URLforTopPlaces]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"photoman" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    

    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Store.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";

    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                               NSInferMappingModelAutomaticallyOption : @(YES) };
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            [self showAlert];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)showAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Unable to save data." message:@"Please contact a tech. support" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

- (NSURL *)applicationStoresDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationApplicationSupportDirectory = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *URL = [applicationApplicationSupportDirectory URLByAppendingPathComponent:@"Stores"];
    
    if (![fileManager fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        [fileManager createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for data stores.");
            
            return nil;
        }
    }
    
    return URL;
}

- (NSURL *)applicationIncompatibleStoresDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *URL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Incompatible"];
    
    if (![fileManager fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        [fileManager createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for corrupt data stores.");
            
            return nil;
        }
    }
    
    return URL;
}



- (NSString *)nameForIncompatibleStore {
    // Initialize Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Configure Date Formatter
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    
    return [NSString stringWithFormat:@"%@.sqlite", [dateFormatter stringFromDate:[NSDate date]]];
}

@end
