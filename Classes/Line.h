//
//  Line.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Line : NSManagedObject {

}
@property (nonatomic, retain) NSString* long_name;
@property (nonatomic, retain) NSString* short_name;
@property (nonatomic, retain) NSString* usage;
@property (nonatomic, retain) NSString* bgcolor;
@property (nonatomic, retain) NSString* fgcolor;
@property (nonatomic, retain) NSSet* stops;

+ (NSFetchedResultsController*) findAll;

@end
