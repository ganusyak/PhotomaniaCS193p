//
//  Photographer+Create.m
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "Photographer+Create.h"
#import "GNUCoreDataKeys.h"

@implementation Photographer (Create)

+ (Photographer *)insertPhotographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photographer *photographer = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PHOTOGRAPHER_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *error = nil;
    
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches || ([matches count] > 1)){
        // handle errors;
    } else if ([matches count]) {
        photographer = [matches firstObject];
    } else {
        photographer = [NSEntityDescription insertNewObjectForEntityForName:PHOTOGRAPHER_ENTITY
                                                     inManagedObjectContext:context];
        photographer.name = name;
        //NSLog(@"Photographer with name %@ added", name);
    }
    
    return photographer;
}
@end
