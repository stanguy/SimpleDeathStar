//
//  CityViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/27/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CityViewController : UITableViewController {
@private
    NSFetchedResultsController *fetchedResultsController_;

}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
