//
//  EditMatchResultController.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditMatchResultController.h"
#import "Set.h"

@interface EditMatchResultController() {
}

-(void)selectSetNumbers;
-(void)hideSetControls;

@end

@implementation EditMatchResultController

@synthesize sets = _sets;

- (id)init
{
    self = [super initWithNibName:@"EditMatchResultView" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%ld", (long)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	long index = pickerView.tag - 100;
	Set *set;
	
	if (index < self.sets.count) {
		set = [self.sets objectAtIndex:index];
	}
	
	if (!set) {
		set = [[Set alloc] init];
		[self.sets addObject:set];
	}
	
	if (component == 0) {
		set.myTeam = row;
	}
	else {
		set.opponent = row;
	}
	
	if (set.myTeam == 4 || set.opponent == 4) {
		[[self.view viewWithTag:pickerView.tag + 1] setHidden:NO];
		[[self.view viewWithTag:pickerView.tag + 101] setHidden:NO];
	}

}

-(void)selectSetNumbers
{
	for (int index = 0; index < self.sets.count; index++) {
		UIPickerView *picker = (UIPickerView *)[self.view viewWithTag:index + 100];	
		Set *set = [self.sets objectAtIndex:index];
		[picker selectRow:set.myTeam inComponent:0 animated:NO];
		[picker selectRow:set.opponent inComponent:1 animated:NO];
	}
}

-(void)hideSetControls
{
	long setCount = self.sets.count;
	
	int offset = 0;
	if (setCount == 0) {
		offset = 1;
	}
	else {
		Set *lastSet = [self.sets objectAtIndex:setCount - 1];
		if (lastSet.myTeam == 4 || lastSet.opponent == 4) {
			offset = 1;
		}
	}
	
	for (int index = 6; index >= setCount + offset; index--) {
		UIPickerView *picker = (UIPickerView *)[self.view viewWithTag:index + 100];	
		[picker selectRow:0 inComponent:0 animated:NO];
		[picker selectRow:0 inComponent:1 animated:NO];
		[picker setHidden:YES];
		[[self.view viewWithTag:index + 200] setHidden:YES];
	}
}

#pragma mark - View lifecycle

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

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self selectSetNumbers];
	[self hideSetControls];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	NSMutableArray *forDelete = [[NSMutableArray alloc] initWithCapacity:self.sets.count];
	
	for (Set *set in self.sets) {
    if (set.myTeam == 0 && set.opponent == 0) {
			[forDelete addObject:set];
		}
	}
	
	[self.sets removeObjectsInArray:forDelete];
}

- (void)viewDidUnload
{
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
