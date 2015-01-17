//
//  TeamPickerController.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TeamPickerController.h"
#import "DSActivityView.h"

@interface TeamPickerController() {

}
@property (nonatomic, assign) id<TeamDelegateProtocol> teamDelegate;
@property (nonatomic, strong) PfService *pfService;
@property (strong, nonatomic) IBOutlet UIPickerView *teamPicker;
-(void)selectTeam;
@end

@implementation TeamPickerController
@synthesize teamPicker = _teamPicker, pfService = _pfService, teamDelegate = _teamDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
			self.pfService = [[PfService alloc] init];
			self.pfService.delegate = self;
			self.teamDelegate = (id<TeamDelegateProtocol>) [UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)PfServiceFailedWithError:(NSError *)error
{
	[DSActivityView removeView];
}

- (void)loadedTeams:(NSArray *)teams
{
	self.teamDelegate.allTeams = teams;
	[self.teamPicker reloadAllComponents];
	[self selectTeam];
	
	[DSActivityView removeView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSLog(@"Antal: %lu", (unsigned long)self.teamDelegate.allTeams.count);
	return self.teamDelegate.allTeams.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	Team *team = [self.teamDelegate.allTeams objectAtIndex:row];
	return team.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	Team *team = [self.teamDelegate.allTeams objectAtIndex:row];
	self.teamDelegate.myTeam = team;
}

-(void)selectTeam
{
	if (self.teamDelegate.myTeam != nil) {
		long index = [self.teamDelegate.allTeams indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            Team *team = (Team*)obj;
            if ([team.name isEqualToString:self.teamDelegate.myTeam.name]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
                     
		[self.teamPicker selectRow:index inComponent:0 animated:NO];
	}
	else {
		self.teamDelegate.myTeam = [self.teamDelegate.allTeams objectAtIndex:0];;
	}
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	if (self.teamDelegate.allTeams.count == 0) {
		[DSActivityView newActivityViewForView:self.view withLabel:@"Laddar..."].showNetworkActivityIndicator = YES;
		[self.pfService loadAllTeams];
	}
	else {
		[self selectTeam];
	}

}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setTeamPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
