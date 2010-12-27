//
//  StopViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Line;
@class City;


@interface StopViewController : UITableViewController <UISearchBarDelegate> {
@private
    Line* line_;
    City* city_;
    
    NSArray* stops_;

}
@property (nonatomic, retain) Line* line;
@property (nonatomic, retain) City* city;
@property (nonatomic, retain) NSArray* stops;

@end
