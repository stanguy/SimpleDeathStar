//
//  TripViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/06/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableWithAdViewController.h"
@class StopTime;

@interface TripViewController : TableWithAdViewController {
@private
    StopTime* stopTime_;
    NSFetchedResultsController* fetchedResultsController_;
}
@property (nonatomic,retain) StopTime* stopTime;
@property (nonatomic,retain) NSFetchedResultsController* fetchedResultsController;
@end
