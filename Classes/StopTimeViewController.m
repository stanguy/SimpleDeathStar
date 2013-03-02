//
//  StopTimeViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "StopTimeViewController.h"
#import "KeolisRennesAPI.h"
#import "APIStopTime.h"
#import "Line.h"
#import "Stop.h"
#import "StopTime.h"
#import "Direction.h"
#import "GridScrollView.h"
#import "TripViewController.h"
#import "Favorite.h"

#import "SimpleDeathStarAppDelegate.h"
#import "PoiViewController.h"
#import "ADViewComposer.h"
#import "StopTimeFormatter.h"

#import "iToast.h"

#define xstr(s) str(s)
#define str(s) #s

const int kRowHeight = 50;
const int kCellWidth = 46;


@interface StopTimeViewController () {
    BOOL realtime;
    NSUInteger formatter_mode;
}

@property (nonatomic, retain) NSDictionary* realtimeStoptimes;
@property (nonatomic, retain) NSArray* realtimeDirections;
@property (nonatomic, retain) StopTimeFormatter* time_formatter;

@end

@implementation StopTimeViewController

@synthesize fetchedResultsController = _fetchedResultsController, line, stop, dateChangeView, realtimeStoptimes, realtimeDirections, refreshItem, dateChangeItem;
@synthesize tableView, scrollView, containerView, favButton, poiButton, alertNoResult = alertNoResult_, datePicker;

enum SHEET_IDS {
    SHEET_POI,
    SHEET_TIME
};

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    realtime = false;
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;


    timeShift_ = 0;
    viewedDate_ = [NSDate date];
    [viewedDate_ retain];

    self.scrollView.tileWidth  = kCellWidth;
    self.scrollView.tileHeight = kRowHeight;
    self.view.clipsToBounds = YES;
    self.tableView.scrollEnabled = NO;
    [self createFloatingGrid];
    
    if ( self.line != nil && self.stop != nil ) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ / %@", self.line.short_name, self.stop.name];
    } else if ( self.stop != nil ) {
        self.navigationItem.title = self.stop.name;
    }
    
    
    self.dateChangeItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock"] style:UIBarButtonItemStylePlain target:self action:@selector(changeDate:)] autorelease];
    self.refreshItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshRealtime:)] autorelease];
    UIImage* favImage;
    if ( [Favorite existsWithLine:self.line andStop:self.stop andOhBTWIncCounter:YES] ) {
        favImage = [UIImage imageNamed:@"favorites_remove"];
    } else {
        favImage = [UIImage imageNamed:@"favorites_add"];
    }
    self.favButton = [[[UIBarButtonItem alloc] initWithImage:favImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavorite:)] autorelease];
    self.poiButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app_globe"] style:UIBarButtonItemStylePlain target:self action:@selector(selectOption:)] autorelease];
    UIBarButtonItem *flexible = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    self.toolbarItems = [NSArray arrayWithObjects:self.dateChangeItem , flexible, self.poiButton, flexible, self.favButton, nil];

    self.activity.hidden = YES;
    self.activity.hidesWhenStopped = YES;
    viewComposer = [[ADViewComposer alloc] initWithView:self.containerView];
    
    UILongPressGestureRecognizer* longPressure = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressure.minimumPressDuration = 1.5f;
    longPressure.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:[longPressure autorelease]];
    
    self.time_formatter = [[[StopTimeFormatter alloc] init] autorelease];
    self.time_formatter.ref_date = viewedDate_;
    formatter_mode = 0;
}

-(void)rotateFormatMode {
    NSUInteger max_level;
    if ( realtime ) {
        max_level = 3;
    } else {
        max_level = 5;
    }
    formatter_mode = ++formatter_mode % max_level;
    NSString* display_type = @"";
    switch ( formatter_mode ) {
        case 0:
            [self.time_formatter resetDefaults];
            display_type = @"Suivant les préférences";
            break;
        case 1:
            self.time_formatter.time_type = STOPTIME_DEPARTURE;
            self.time_formatter.relative = false;
            display_type = @"Départ / absolu";
            break;
        case 2:
            self.time_formatter.time_type = STOPTIME_DEPARTURE;
            self.time_formatter.relative = true;
            display_type = @"Départ / relatif";
            break;
        case 3:
            self.time_formatter.time_type = STOPTIME_ARRIVAL;
            self.time_formatter.relative = false;
            display_type = @"Arrivée / absolu";
            break;
        case 4:
            self.time_formatter.time_type = STOPTIME_ARRIVAL;
            self.time_formatter.relative = true;
            display_type = @"Arrivée / relatif";
            break;
        default:
            NSLog( @"WE SHOULD NOT HAVE COME HERE!#@" );
            break;
    }
    NSString* full_text = [@"Affichage :\n" stringByAppendingString:display_type];
    [[[iToast makeText:full_text] setGravity:iToastGravityBottom] show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [viewComposer changeDisplay:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}


- (UIAlertView*)alertNoResult {
    NSString* defaultMsg = NSLocalizedString( @"Il n'y a pas d'horaire de passage prévu à la date indiquée", @"" );
    if ( alertNoResult_ != nil ) {
        alertNoResult_.message = defaultMsg;
        return alertNoResult_;
    }
    alertNoResult_ = [[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Aucun passage", @"" )
                                                 message:defaultMsg
                                                delegate:nil 
                                       cancelButtonTitle:@"Ok" 
                                       otherButtonTitles:nil] retain];
    return alertNoResult_;
}    

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ( realtime ) {
        if  ( nil != self.realtimeDirections ) {
            return [self.realtimeDirections count];
        } else {
            return 0;
        }
    } else {
        return [[self.fetchedResultsController sections] count];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GridCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.accessoryType =  UITableViewCellAccessoryNone; 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *directionName;
    if ( realtime ) {
        directionName = [self.realtimeDirections objectAtIndex:indexPath.row];
    } else {
        id<NSFetchedResultsSectionInfo> section = [[self.fetchedResultsController sections] objectAtIndex:indexPath.row];
        StopTime* st = [[section objects] objectAtIndex:0];
        directionName = st.direction.headsign;
        if ( self.line == nil ) {
            directionName = [NSString stringWithFormat:NSLocalizedString( @"%@ vers %@", @"" ), st.line.short_name, directionName];
        }
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.textLabel.text =  directionName;
    cell.detailTextLabel.text =  @" ";
    
    return cell;
}


- (NSFetchedResultsController*) fetchedResultsController {
    if ( nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    self.fetchedResultsController = [StopTime findByLine:self.line andStop:self.stop atDate:viewedDate_];
    if ( [[_fetchedResultsController sections] count] < 1 ) {
        [self.alertNoResult show];
    }
    
    return _fetchedResultsController;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}

#pragma mark -
#pragma mark GridScrollView

- (void)createFloatingGrid {
    self.tableView.hidden = NO;
    //    [self.tableView reloadData];
    self.scrollView.hidden = YES;
    
    int nb_max_stops = 0;
    int nbStops = [self tableView:nil numberOfRowsInSection:0];
    if (nbStops == 0) {
        return;
    }
    for ( int i = 0; i < nbStops ; ++i) {
        NSInteger count;
        if ( realtime ) {
            count = [[self.realtimeStoptimes objectForKey:[self.realtimeDirections objectAtIndex:i]] count];
        } else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:i];
            count = [sectionInfo numberOfObjects] ;
        }
        if ( count > nb_max_stops) {
            nb_max_stops = count;
        }
    }
    int gridWidth = (nb_max_stops * kCellWidth) + 12;
    int gridHeight = (nbStops * kRowHeight);
    [scrollView setContentSize:CGSizeMake(gridWidth, gridHeight)];
    
    [self adjustScrollViewFrame];
    [self.view bringSubviewToFront:scrollView];
    
    //    [self.view addSubview:scrollView];
    
    [scrollView reloadData];    
}

- (void)adjustScrollViewFrame {
    scrollView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    
}

- (UIView *)gridScrollView:(GridScrollView *)scrollView tileForRow:(int)row column:(int)column {
    NSString* ftime = @"";
    static NSString* NO_TIME = @"\u2014:\u2014";
    BOOL use_em = NO;
    if ( realtime ) {
        if (  self.realtimeStoptimes ) {
            if ( self.realtimeDirections && row >= [self.realtimeDirections count]) {
                return nil;
            }
            NSArray* times = [self.realtimeStoptimes objectForKey:[self.realtimeDirections objectAtIndex:row]];
            if ( column >= [times count] ) {
                ftime = NO_TIME;
            } else {
                APIStopTime* stoptime = [times objectAtIndex:column];

                ftime = [self.time_formatter format:stoptime];
                use_em = ! stoptime.accurate;
            }
        }
    } else {
        if ( row >= [[self.fetchedResultsController sections] count] ) {
            return nil;
        }
        if ( column >= [ [[self.fetchedResultsController sections] objectAtIndex:row] numberOfObjects] ) {
            ftime =  NO_TIME;
        } else {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:column inSection:row];
            StopTime* st = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            ftime = [self.time_formatter format:st];
        }
    }
    UIView *cellview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kRowHeight)];
    UILabel *label = [[UILabel alloc] init];
    if ( use_em ) {
        label.font = [UIFont italicSystemFontOfSize:12.0];
    } else {
        label.font = [UIFont systemFontOfSize:12.0];
    }
    if ( self.time_formatter.relative ) {
        if ( [ftime length] < 2 ) {
            label.textColor = [UIColor redColor];
        }
        if ( ftime != NO_TIME ) {
            label.text = [ftime stringByAppendingString:@" min"];
        }
    } else {
        label.text = ftime;        
    }
    
    // fill
    
    label.backgroundColor = [UIColor clearColor];
    
    if (column % 2 == 0) {
        cellview.backgroundColor = [UIColor clearColor];
    } else {
        cellview.backgroundColor = [UIColor colorWithRed: (214/255.0) green: (214/255.0) blue: (255/255.0) alpha: 0.3];
    }
    
    label.frame = CGRectMake(8, 15, kCellWidth, kRowHeight - 15);
    [cellview addSubview:label];
    [label release];
    
   
    return [cellview autorelease];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    tableView.contentOffset = CGPointMake(0, aScrollView.contentOffset.y);
    self.scrollView.directionalLockEnabled = YES; // I don't know why this keeps getting set to NO otherwise
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self alignGridAnimated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self alignGridAnimated:YES];
}

- (void)alignGridAnimated:(BOOL)animated {
    float x = self.scrollView.contentOffset.x;
    float y = self.scrollView.contentOffset.y;
    float maxY = self.scrollView.contentSize.height - self.scrollView.frame.size.height - (kRowHeight / 2);
    
    if (y == self.scrollView.contentSize.height - self.scrollView.frame.size.height) {
        return;
        
    }
    // when at bottom, align toward bottom, except when too few rows
    float newY;
    if ( (y > maxY ) &&  (maxY >= self.scrollView.frame.size.height) )   {
        newY = self.scrollView.contentSize.height - self.scrollView.frame.size.height + 10;
    } else {
        newY = round(y/kRowHeight) * kRowHeight;
    }
    CGPoint contentOffset = CGPointMake( (round(x/kCellWidth) * kCellWidth), newY);
    
    [self.scrollView setContentOffset:contentOffset animated:animated];        
}

- (void)touchedRowAndCol:(NSArray*)rowAndCol {
    if ( realtime ) { return; }
    int row = [[rowAndCol objectAtIndex:0] intValue];
    int col = [[rowAndCol objectAtIndex:1] intValue];
    NSArray* sections = [self.fetchedResultsController sections];
    if ( row >= [sections count] ) {
        return;
    }
    id<NSFetchedResultsSectionInfo> section = [sections objectAtIndex:row];
    if ( col >= [section numberOfObjects] ) {
        return;
    }
    [viewComposer toDisappear];
    StopTime* st = [[section objects] objectAtIndex:col];
    TripViewController* tripViewController = [[TripViewController alloc] initWithNibName:@"TripViewController" bundle:nil];
    tripViewController.stopTime = st;
    [self.navigationController pushViewController:tripViewController animated:YES];
    [tripViewController release];
}

- (void)doubleTouchedRowAndCol:(NSArray*)rowAndCol {
    NSLog( @"%@", rowAndCol );
    if ( realtime ) { return; }
//    int row = [[rowAndCol objectAtIndex:0] intValue];
    int col = [[rowAndCol objectAtIndex:1] intValue];
    int nb_max_stops = 0;
    int nbStops = [[self.fetchedResultsController sections] count];
    if (nbStops == 0) {
        return;
    }
    for ( int i = 0; i < nbStops ; ++i) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:i];
        if ( [sectionInfo numberOfObjects] > nb_max_stops) {
            nb_max_stops = [sectionInfo numberOfObjects];
        }
    }
    int max_cell_by_width = [[UIScreen mainScreen] bounds].size.width / kCellWidth;
    int ref_col = nb_max_stops > max_cell_by_width ? nb_max_stops : max_cell_by_width;
    if ( col >= ref_col - 2 ) {
        [self shiftRight:nil];
    } else if ( col <= 2 ) {
        [self shiftLeft:nil];
    }
}

#pragma mark -
#pragma mark Date handling

-(void)changeDate:(id)sender {
    if ( self.dateChangeView == nil ) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DateNavigation" owner:self options:nil];
        NSEnumerator *enumerator = [nib objectEnumerator];
        id object;
        while ((object = [enumerator nextObject])) {
            if ([object isMemberOfClass:[UIView class]]) {
                self.dateChangeView = (UIView*) object;
                break;
            }
        }
        self.dateChangeView.frame = CGRectMake( 0, self.view.frame.size.height - 260, self.view.frame.size.width, 260 );
        [self.view addSubview:self.dateChangeView];
    } else if ( ! [self.dateChangeView isHidden] ) {
        [self.view sendSubviewToBack:self.dateChangeView];
        self.dateChangeView.hidden = YES;
        return;
    }
    self.datePicker.date = viewedDate_;
    [self.view bringSubviewToFront:self.dateChangeView];
    self.dateChangeView.hidden = NO;
    TAKE_SCREENSHOT(@"ChangeDate");
}

-(void)onChangeDate:(id)sender {
    [self.view sendSubviewToBack:self.dateChangeView];
    self.dateChangeView.hidden = YES;
    [viewedDate_ release];
    viewedDate_ = [self.datePicker.date retain];
    self.time_formatter.ref_date = viewedDate_;
    [self reloadData];    
}
- (void)onDismissChangeDate:(id)sender {
    [self.view sendSubviewToBack:self.dateChangeView];
    self.dateChangeView.hidden = YES;
}


- (IBAction)shiftLeft:(id)sender {
    [self.view sendSubviewToBack:self.dateChangeView];
    self.dateChangeView.hidden = YES;
    NSDate* tmpDate = [[viewedDate_ dateByAddingTimeInterval:-BASE_TIMESHIFT] retain];
    [viewedDate_ release];
    viewedDate_ = tmpDate;
    self.time_formatter.ref_date = viewedDate_;
    [self reloadData];
}
- (IBAction)shiftRight:(id)sender {
    [self.view sendSubviewToBack:self.dateChangeView];
    self.dateChangeView.hidden = YES;
    NSDate* tmpDate = [[viewedDate_ dateByAddingTimeInterval:BASE_TIMESHIFT] retain];
    [viewedDate_ release];
    viewedDate_ = tmpDate;
    self.time_formatter.ref_date = viewedDate_;
    [self reloadData];
}

-(void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self rotateFormatMode];
        [self reloadData];
    }
}

#pragma mark -
#pragma mark Others

- (void)reloadData {
    if ( ! realtime ) {
        self.fetchedResultsController = nil;
    }
    [self.tableView reloadData];
    [self.scrollView reloadData];
    [self createFloatingGrid];
}


- (IBAction)toggleFavorite:(id)sender {

    if ( [Favorite existsWithLine:self.line andStop:self.stop] ) {
        // remove
        [Favorite deleteWithLine:self.line andStop:self.stop];
        self.favButton.image = [UIImage imageNamed:@"favorites_add"];
    } else {
        // create new favorite
        [Favorite addWithLine:self.line andStop:self.stop];
        self.favButton.image = [UIImage imageNamed:@"favorites_remove"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"favorites" object:nil];
}

- (IBAction)selectOption:(id)sender {
    UIActionSheet* sheet = [[UIActionSheet alloc ] initWithTitle:NSLocalizedString( @"Options", @"")
                                                        delegate:self 
                                               cancelButtonTitle:NSLocalizedString( @"Annuler", @"" )
                                          destructiveButtonTitle:nil 
                                               otherButtonTitles:nil];
    if ( realtime ) {
        [sheet addButtonWithTitle:NSLocalizedString( @"Horaires théoriques", @"" )];
    } else {
        [sheet addButtonWithTitle:NSLocalizedString( @"Temps réel", @"" )];        
    }
    if ( [self.stop allCounts] > 0 ) {
        [sheet addButtonWithTitle:NSLocalizedString( @"Points d'intérêts proches", @"" )];
    }
    [sheet showFromToolbar:self.navigationController.toolbar];
    [sheet release];
    TAKE_SCREENSHOT(@"realtime");
}

#ifndef KEOLIS_API_KEY
#error "Missing Key for the API"
#endif

-(void)loadRealTimeData{
    KeolisRennesAPI* api = [[[KeolisRennesAPI alloc] init] autorelease];
    api.key = [NSString stringWithCString:xstr(KEOLIS_API_KEY) encoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSArray* stoptimes = [[api findNextDepartureAtStop:self.stop error:&error] retain];
    if ( error ) {
        NSLog( @"failed to find departures" );
        [self performSelectorOnMainThread:@selector(endRealtimeFetch:) withObject:@true waitUntilDone:NO];
        [stoptimes release];
        return;
    }
    NSMutableDictionary* sorted_times = [NSMutableDictionary dictionaryWithCapacity:[stoptimes count] / 2];
    for ( APIStopTime* stoptime in stoptimes ) {
        NSString* st_title;
        if ( nil != self.line ) {
            if ( ! [self.line isEqual:stoptime.line] ) {
                continue;
            }
            st_title = stoptime.direction;
        } else {
            st_title = [NSString stringWithFormat:NSLocalizedString( @"%@ vers %@", @"" ), stoptime.line.short_name, stoptime.direction];
        }
        NSMutableArray* times = [sorted_times objectForKey:st_title];
        if ( nil == times ) {
            times = [NSMutableArray arrayWithCapacity:1];
        }
        [times addObject:stoptime];
        [sorted_times setObject:times forKey:st_title];
    }
    @synchronized(self) {
        self.realtimeStoptimes = sorted_times;
        self.realtimeDirections = [[sorted_times allKeys] sortedArrayUsingComparator:^(id first, id second){
            return [((NSString*)first) compare:((NSString*)second) options:NSNumericSearch];
        }];
    }
    [stoptimes release];
    [self performSelectorOnMainThread:@selector(endRealtimeFetch:) withObject:@false waitUntilDone:NO];
}

- (void)endRealtimeFetch:(NSNumber*)hasError {
    [self.activity stopAnimating];
    if ( [hasError boolValue] ) {
        UIAlertView* alert = self.alertNoResult;
        alert.message = NSLocalizedString( @"Une erreur réseau a eu lieu", @"" );
        [alert show];
    } else if ( self.realtimeDirections && [self.realtimeDirections count] == 0) {
        // noresult
        UIAlertView* alert = self.alertNoResult;
        alert.message = NSLocalizedString( @"Il n'y a pas de bus à venir", @"" );
        [alert show];
    } else {
        APIStopTime* ref = [[self.realtimeStoptimes objectForKey:[self.realtimeDirections objectAtIndex:0]] objectAtIndex:0];
        self.time_formatter.ref_date = ref.remoteReferenceTime;
    }
    [self reloadData];
}

- (void)exchangeButton:(UIBarButtonItem*)current with:(UIBarButtonItem*)other{
    NSMutableArray *toolbarButtons = [self.toolbarItems mutableCopy];

    [toolbarButtons replaceObjectAtIndex:0 withObject:other];
    [self setToolbarItems:toolbarButtons animated:YES];
}

-(void)refreshRealtime:(id)sender {
    [self.activity startAnimating];
    [self performSelectorInBackground:@selector(loadRealTimeData) withObject:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch ( buttonIndex ) {
        case 0:
            // cancelled
            break;
        case 1:
            if ( realtime ) {
                realtime = NO;
                self.realtimeDirections = nil;
                self.realtimeStoptimes = nil;
                self.time_formatter.ref_date = viewedDate_;
                [self exchangeButton:self.refreshItem with:self.dateChangeItem];
                [self reloadData];
            } else {
                realtime = YES;
                if ( formatter_mode > 2 ) {
                    formatter_mode -= 2;
                }
                [self exchangeButton:self.dateChangeItem with:self.refreshItem];
                self.activity.hidden = NO;
                [self.activity startAnimating];
                [self reloadData];
                [self performSelectorInBackground:@selector(loadRealTimeData) withObject:nil];
            }
            break;
        case 2:
        {
            PoiViewController* poiViewController = [[PoiViewController alloc] initWithNibName:@"PoiViewController" bundle:nil];
            poiViewController.stop = self.stop;
            [self.navigationController pushViewController:poiViewController animated:YES];
            [poiViewController release];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [alertNoResult_ release];
    [viewedDate_ release];
    [super dealloc];
}


@end

