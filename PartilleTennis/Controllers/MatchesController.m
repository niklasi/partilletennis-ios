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
#import <EventKit/EventKit.h>

@interface MatchesController() {
}

@property (nonatomic, strong) Team *currentTeam;
@property (nonatomic, readonly) int year;
@property (nonatomic, readonly, strong) NSString *season;
@property (nonatomic, readonly, strong) NSString *filename;
@property (nonatomic, strong) EKEventStore *eventStore;

- (void)observeForNewMatchTimes;
- (void)addToCalendar: (Match *)match;

@end

@implementation MatchesController

- (void)addToCalendar:(Match *)match {
    
}

- (void)observeForNewMatchTimes {
    for (Match *match in self.matches) {
        [match addObserver:self forKeyPath:@"postponedToDate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        [match addObserver:self forKeyPath:@"postponed" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   
    if ([change objectForKey:NSKeyValueChangeOldKey] != [change objectForKey:NSKeyValueChangeNewKey]) {
        self.matches = [self.matches sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = ((Match*)a).playDate;
            NSDate *second = ((Match*)b).playDate;
            return [first compare:second];
        }];
    
        NSLog(@"Changed...");
    }
    
    NSLog(@"New play date %@", ((Match *)object).playDate);
}

-(id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"Matcher";
        pfService = [[PfService alloc] init];
        pfService.delegate = self;
        self.eventStore = [[EKEventStore alloc] init];
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

-(void)save
{
	if (self.matches.count == 0) return;
	
	[NSKeyedArchiver archiveRootObject:self.matches toFile:pathInDocumentDirectory(self.filename)];
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
            [self observeForNewMatchTimes];
			[self.tableView reloadData];
		}
	}
	else {
		[self.tableView reloadData];
	}
}

- (void)loadedMatches:(NSArray *)matches
{
	[DSActivityView removeView];
	
	self.matches = matches;
    [self observeForNewMatchTimes];
	[self.tableView reloadData];
}

- (void)PfServiceFailedWithError:(NSError *)error
{
	[DSActivityView removeView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Match *match = (Match *)[self.matches objectAtIndex:[indexPath row]];
		
	NSString *cellIdentifier = @"UpcomingMatchCell";
	NSString *nib = @"UpcomingMatchTableCellView";	
	
	if (match.result.completeResult || (match.postponed && match.postponedToDate == nil)) {
		cellIdentifier = @"CompletedMatchCell";
		nib = @"CompletedMatchTableCellView";
	}
	
	MatchTableCell *cell = (MatchTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		
		[[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
		cell = self.matchTableCell;
	}
    
	cell.match = match;
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MatchDetailController *matchDetailController = [[MatchDetailController alloc] init];
	Match *match = (Match *)[self.matches objectAtIndex:indexPath.row];
	[matchDetailController setMatch:match];
	matchDetailController.myTeam = self.currentTeam;
	[self.navigationController pushViewController:matchDetailController animated:YES];
}

@end
