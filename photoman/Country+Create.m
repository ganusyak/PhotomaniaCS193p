//
//  Country+Create.m
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "Country+Create.h"
#import "GNUCoreDataKeys.h"

@implementation Country (Create)

+ (Country *)insertCountryWithName:(NSString *)countryName inManagedObjectContext:(NSManagedObjectContext *)context
{
    Country *country = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:COUNTRY_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"countryName == %@", countryName];
    
    NSError *error = nil;
    
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    
    if (error || !fetchResults || fetchResults.count > 1){
        // TODO: handle errors
    } else if (fetchResults.count) {
        return [fetchResults firstObject]; // return existing object
    } else {
        // add new country with countryName
        country = [NSEntityDescription insertNewObjectForEntityForName:COUNTRY_ENTITY inManagedObjectContext:context];
        country.countryName = countryName;
    }
    
    return country;
}

@end
