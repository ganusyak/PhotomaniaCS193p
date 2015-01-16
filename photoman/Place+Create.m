//
//  Place+Create.m
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "Place+Create.h"
#import "Country+Create.h"
#import "GNUCoreDataKeys.h"

@implementation Place (Create)

+ (NSString *)countryNameForPlace:(NSDictionary *)placeDescription
{
    NSString *contentString = [placeDescription valueForKey:PLACE_CONTENT_KEY];
    NSArray *contentStringComponents = [contentString componentsSeparatedByString:@", "];
    return [contentStringComponents lastObject];
}

+ (Place *)insertPlace:(NSDictionary *)placeDescription inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *newPlace = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PLACE_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"placeID == %@", [placeDescription valueForKey:PLACE_ID]];
    
    NSError *error = nil;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    
    if (error || !fetchResults || [fetchResults count] > 1){
        // handle errors
    } else if (fetchResults.count) {
        return [fetchResults firstObject]; // return existing place
    } else {
        // add new Place to database
        newPlace = [NSEntityDescription insertNewObjectForEntityForName:PLACE_ENTITY
                                                 inManagedObjectContext:context];
        
        newPlace.placeID = [placeDescription valueForKey:PLACE_ID];
        newPlace.name = [placeDescription valueForKey:PLACE_NAME];
        NSString *countryName = [self countryNameForPlace:placeDescription];
        newPlace.country = [Country insertCountryWithName:countryName
                                   inManagedObjectContext:context];
    }
    
    return newPlace;
    
}



+ (void)insertPlaces:(NSArray *)places inManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *place in places){
        [Place insertPlace:place inManagedObjectContext:context];
    }
}

@end
