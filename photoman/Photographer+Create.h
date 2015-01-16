//
//  Photographer+Create.h
//  photoman
//
//  Created by yuriy ganusyak on 10/24/14.
//  Copyright (c) 2014 Yuriy Ganusyak. All rights reserved.
//

#import "Photographer.h"
@interface Photographer (Create)

+ (Photographer *)insertPhotographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
