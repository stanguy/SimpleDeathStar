//
//  AbstractHomeSection.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HomePageDelegate <NSObject>

-(void)reloadSection:(id)section;

@end


@interface AbstractHomeSection : NSObject

@property (nonatomic,assign) id<HomePageDelegate> delegate;
@property (readonly) NSString* title;

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller;
- (void)reloadByTimer;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)numberOfElements;
-(void)selectRow:(NSInteger)row from:(UIViewController*)controller;
-(CGFloat)rowHeight;

-(NSInteger)bestMaxFitRows;

@end
