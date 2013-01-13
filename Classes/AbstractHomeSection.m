//
//  AbstractHomeSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "AbstractHomeSection.h"
#import "ADViewComposer.h"


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation AbstractHomeSection

@synthesize title;

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)reloadByTimer{}


-(CGFloat)rowHeight {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
-(NSInteger)numberOfElements{
    return 0;
}

-(NSInteger)bestMaxFitRows{
    NSInteger rows = 6;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        if ( IS_IPHONE_5 ) {
            rows++;
        }
        if ( ! [ADViewComposer AdsEnabled] ) {
            rows++;
        }
    }
    return rows;
}


@end
