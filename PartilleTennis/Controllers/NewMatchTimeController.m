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


#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (self.match.postponedToDate != nil) {
		self.timePicker.date = self.match.postponedToDate;
	}
}


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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
