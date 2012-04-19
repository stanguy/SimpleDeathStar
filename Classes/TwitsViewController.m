//
//  TwitsViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 4/17/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "TwitsViewController.h"
#import "SBJsonParser.h"

@interface TwitsViewController ()

@property (nonatomic,retain) NSArray* twits_;

- (void)loadTwits;
- (void)refreshTwits;


@end

@interface Twit : NSObject

@property (nonatomic,retain) NSString* text;
@property (nonatomic,retain) NSDate* created_at;
@property (nonatomic,retain) NSNumber* twit_id;

@end

@implementation Twit

@synthesize text,created_at,twit_id;

@end

@implementation TwitsViewController

@synthesize twits_;

static NSString* STM_TWITS_URL = @"http://api.twitter.com/1/statuses/user_timeline.json?user_id=97672707&trim_user=1&include_rts=0&exclude_replies=1&count=100";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.twits_  = [[NSArray alloc] init];
    self.navigationItem.title = @"@starbusmetro";
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"]
                                                                       style:UIBarButtonItemStyleBordered target:self action:@selector(refreshTwits)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    self.tableView.rowHeight = 100.f;
    [settingsButton release];
    [self loadTwits];
}

#pragma -
#pragma Table stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( [self.twits_ count] > 0 ) {
        return [self.twits_ count];
    }
    return 1;
}


enum {
    DATETIME_TAG = 12,
    TEXT_TAG
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TwitCell";
    
    if ( [self.twits_ count] == 0 ) {
        static NSString *CellIdentifierNotwits = @"NoTwitsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierNotwits];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierNotwits] autorelease];
        }
        cell.textLabel.text = @"Pas de twits";
        return cell;
    }
    
    
    UILabel* dateLabel = nil;
    UILabel* textLabel = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake( 10.0f, 35.0f, 50.0f, 90.0f)] autorelease];
        dateLabel.tag = DATETIME_TAG;
        dateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        dateLabel.textColor = [UIColor colorWithRed:0.529f green:0.157f blue:0.153f alpha:1.0f];
        dateLabel.numberOfLines = 0;
        dateLabel.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:dateLabel];
        
        textLabel = [[[UILabel alloc] initWithFrame:CGRectMake( 65.0f, 5.0f, 230.0f, 95.0f)] autorelease];
        textLabel.tag = TEXT_TAG;
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        textLabel.textAlignment = UITextAlignmentRight;
        textLabel.textColor = [UIColor blackColor];
        textLabel.contentMode = UIViewContentModeTop;
//        textLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        textLabel.numberOfLines = 0;
//        textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:textLabel];
        
    } else {
        dateLabel = (UILabel *)[cell.contentView viewWithTag:DATETIME_TAG];
        textLabel = (UILabel *)[cell.contentView viewWithTag:TEXT_TAG];
    }
    
    Twit* twit = [self.twits_ objectAtIndex:indexPath.row];
    // Configure the cell...
    textLabel.text = twit.text;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM\nHH:mm"];
    
    dateLabel.text = [formatter stringFromDate:twit.created_at];
    [dateLabel sizeToFit];
//    [textLabel sizeToFit];
    return cell;
}

#pragma -
#pragma Twits stuff

- (NSURL*)localUrl{
    
    NSArray* urls = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL* directory = [urls objectAtIndex:0];
    return [NSURL URLWithString:@"starbusmetro.json" relativeToURL:directory];
}

- (void)refreshTwits {
    NSLog( @"refresh!" );
    NSURL *url = [NSURL URLWithString:STM_TWITS_URL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( ! [urlData writeToURL:[self localUrl] atomically:YES] ) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: NSLocalizedString( @"Erreur", @"" )
                                   message: NSLocalizedString( @"Impossible de charger la page.", @"" )
                                  delegate: nil
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        [alert release];

        return;
    }
    [self loadTwits];
}

- (void)loadTwits {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSString *content = [[[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[self localUrl]]
                                               encoding:NSUTF8StringEncoding] autorelease];
    NSArray *jsonObjects = [jsonParser objectWithString:content];
    [jsonParser release], jsonParser = nil;
    if ( jsonObjects != nil ) {
//        NSLog( @"%@", jsonObjects );
        NSMutableArray* newTwits = [[NSMutableArray alloc] init];
        NSCharacterSet* at = [NSCharacterSet characterSetWithCharactersInString:@"@"];
        NSDateFormatter *frm = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] 
                            initWithLocaleIdentifier:@"en_US_POSIX"];
        [frm setLocale:locale];
        [locale release];
        [frm setDateStyle:NSDateFormatterLongStyle];
        [frm setFormatterBehavior:NSDateFormatterBehavior10_4];
        [frm setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
        for( NSDictionary* post in jsonObjects ) {
            NSString* text = [post valueForKey:@"text"];
            NSRange find = [text rangeOfCharacterFromSet:at];
            if ( find.location != NSNotFound ) {
                continue;
            }
            NSLog( @"%@", text );
            Twit* twit = [[Twit alloc] init];
            twit.text = text;
            NSString* created_at = [post valueForKey:@"created_at"];
            twit.created_at = [frm dateFromString:created_at];
            twit.twit_id = [post valueForKey:@"id"];
            [newTwits addObject:twit];
            [twit release];
        }
        self.twits_ = newTwits;
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    // Navigation logic may go here. Create and push another view controller.
    Twit* twit = [self.twits_ objectAtIndex:indexPath.row];
    NSString* statusUrl = [NSString stringWithFormat:@"http://twitter.com/starbusmetro/status/%@", twit.twit_id];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:statusUrl]];
}


@end
