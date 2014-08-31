//
//  NewMatchTimeController.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-09-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMatchTimeController.h"

@implementation NewMatchTimeController
@synthesize timePickerSegment = _timePickerSegment;
@synthesize timePicker = _timePicker, match = _match;


- (id)init
{
    self = [super initWithNibName:@"NewMatchTimeView" bundle:nil];
    if (self) {
        self.title = @"Uppskjuten match";
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

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (self.match.postponedToDate != nil) {
		self.timePicker.date = self.match.postponedToDate;
	}
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	if (self.timePickerSegment.selectedSegmentIndex == 0) {
		self.match.postponedToDate = [self.timePicker date];
	}
	else {
		self.match.postponedToDate = nil;
	}
}

- (void)viewDidUnload
{
	[self setTimePicker:nil];
	[self setTimePickerSegment:nil];
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
