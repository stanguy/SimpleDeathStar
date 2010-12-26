//
//  LineViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LineViewController : UITableViewController {
@private
    NSFetchedResultsController *fetchedResultsController_;

}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
