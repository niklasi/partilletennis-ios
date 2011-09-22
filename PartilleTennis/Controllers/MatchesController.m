//
//  MatchesController.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MatchesController.h"
#import "Match.h"
#import "DSActivityView.h"
#import "MatchDetailController.h"
#import "Set.h"

@interface MatchesController() {
}

@property (nonatomic, strong) Team *currentTeam;
@property (nonatomic, readonly) int year;
@property (nonatomic, readonly, strong) NSString *season;
@property (nonatomic, readonly, strong) NSString *filename;
@end

@implementation MatchesController

@synthesize matches = _matches, matchTableCell = _matchTableCell, 
currentTeam = _currentTeam;

-(id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
			self.title = @"Matcher";
			pfService = [[PfService alloc] init];
			pfService.delegate = self;			
    }
    return self;
}

-(int)year
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"YYYY"];
	return [[formatter stringFromDate:[NSDate date]] intValue];
}

-(NSString *)season
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM"];
	int month = [[formatter stringFromDate:[NSDate date]] intValue];
	
	if (month < 7) {
		return @"spring";
	}
	return @"fall";
}

-(NSString *)filename {
	return [NSString stringWithFormat:@"matches-%@-%@-%d", self.currentTeam.name, self.season, self.year];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)save
{
	if (self.matches.count == 0) return;
	
//	self.matchResults = [[NSMutableDictionary alloc] init];
//	for (Match *match in self.matchData) {
//		if (match.result != nil) {
//			[self.matchResults setObject:match.result forKey:match];
//		}
//	}
	[NSKeyedArchiver archiveRootObject:self.matches toFile:pathInDocumentDirectory(self.filename)];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSLog(@"Matches view load...");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	NSLog(@"Matches view did unload...");
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	id<TeamDelegateProtocol> teamDelegate = (id<TeamDelegateProtocol>) [UIApplication sharedApplication].delegate;
	Team *myTeam = teamDelegate.myTeam;

	if (self.matches.count == 0 || ![myTeam isEqual: self.currentTeam]) {
		self.currentTeam = myTeam;
		self.matches = [NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(self.filename)];
		if (self.matches.count == 0) {
			[DSActivityView newActivityViewForView:self.view withLabel:@"Laddar..."].showNetworkActivityIndicator = YES;
			[pfService loadMatches:myTeam.name season:self.season year:self.year];
		}
		else {
			[self.tableView reloadData];
		}
	}
	else {
		[self.tableView reloadData];
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	NSLog(@"Matches view will disappear...");
}

- (void)loadedMatches:(NSArray *)matches
{
	[DSActivityView removeView];
	
	/*for (Match *match in matches) {
    match.result = [self.matchResults objectForKey:match];
	}*/
	
	self.matches = matches;
	[self.tableView reloadData];
}

- (void)PfServiceFailedWithError:(NSError *)error
{
	[DSActivityView removeView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Match *match = (Match *)[self.matches objectAtIndex:[indexPath row]];
		
//	match.result = [self.matchResults objectForKey:match];
	
	NSString *cellIdentifier = @"UpcomingMatchCell";
	NSString *nib = @"UpcomingMatchTableCellView";	
	
	if (match.result.completeResult) {
		cellIdentifier = @"CompletedMatchCell";
		nib = @"CompletedMatchTableCellView";
	}
	
	MatchTableCell *cell = (MatchTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		//cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		[[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
		cell = self.matchTableCell;
	}
    
	cell.match = match;
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	MatchDetailController *matchDetailController = [[MatchDetailController alloc] init];
	Match *match = (Match *)[self.matches objectAtIndex:indexPath.row];
	[matchDetailController setMatch:match];
	matchDetailController.myTeam = self.currentTeam;
	[self.navigationController pushViewController:matchDetailController animated:YES];
}

@end
