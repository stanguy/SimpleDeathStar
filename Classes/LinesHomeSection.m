//
//  LinesHomeSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 6/30/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import "LinesHomeSection.h"

#import "Line.h"
#import "StopViewController.h"

@interface LinesHomeSection ()

@property (nonatomic,retain) NSArray* lines;

@end

@implementation LinesHomeSection

@synthesize lines;

-(id) init {
    self = [super init];
    NSLog( @"!@#" );
    if ( self ) {
        self.lines = [[[Line findAll:LINE_USAGE_ALL] fetchedObjects] retain];
    }
    return self;
    
}

-(NSString*) title {
    return @"Recherche par lignes";
}

-(NSInteger) numberOfElements {
    return [self.lines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifierLine = @"Line";
    Line* line = [lines objectAtIndex:indexPath.row];
    NSString* cellIdentifierParticularLine = [CellIdentifierLine stringByAppendingString:line.src_id];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierParticularLine ];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierParticularLine] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString( @"Ligne %@", @"" ), line.short_name];
    cell.detailTextLabel.text = line.long_name;
    
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    [cell.textLabel sizeToFit];
    CGRect frame = cell.frame;
    frame.size.width += 120;
    cell.frame = frame;
    return cell;
}

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller{
    Line* line = [lines objectAtIndex:row];
    StopViewController* stopViewController = [[StopViewController alloc] initWithNibName:@"StopViewController" bundle:nil];
    stopViewController.line = line;
    [controller.navigationController pushViewController:stopViewController animated:YES];
    [stopViewController release];

}

@end
