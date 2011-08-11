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
@property (nonatomic, strong) NSMutableDictionary *matchResults;
@end

@implementation MatchesController

@synthesize matchData = _matchData, matchTableCell = _matchTableCell, 
currentTeam = _currentTeam, matchResults = _matchResults;

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSLog(@"View load...");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	id<TeamDelegateProtocol> teamDelegate = (id<TeamDelegateProtocol>) [UIApplication sharedApplication].delegate;
	Team *myTeam = teamDelegate.myTeam;

	if (self.matchData.count == 0 || ![myTeam isEqual: self.currentTeam]) {
		self.currentTeam = myTeam;
		[DSActivityView newActivityViewForView:self.view withLabel:@"Laddar..."].showNetworkActivityIndicator = YES;
		NSLog(@"Division: %d, Team: %d", myTeam.division, myTeam.ranking);
		[pfService loadMatches:myTeam.division team:myTeam.ranking];
		self.matchResults = [NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(@"matchResults")];
	}
	else {
		[self.tableView reloadData];
	}
}

- (void)loadedMatches:(NSArray *)matches
{
	[DSActivityView removeView];
	
	for (Match *match in matches) {
    match.result = [self.matchResults objectForKey:match];
	}
	
	self.matchData = matches;
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	self.matchResults = [[NSMutableDictionary alloc] init];
	for (Match *match in self.matchData) {
		if (match.result != nil) {
			[self.matchResults setObject:match.result forKey:match];
		}
	}
	[NSKeyedArchiver archiveRootObject:self.matchResults toFile:pathInDocumentDirectory(@"matchResults")];
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
    return self.matchData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Match *match = (Match *)[[self matchData] objectAtIndex:[indexPath row]];
		
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
	Match *match = (Match *)[self.matchData objectAtIndex:indexPath.row];
	[matchDetailController setMatch:match];
	
	[self.navigationController pushViewController:matchDetailController animated:YES];
	
}

@end
