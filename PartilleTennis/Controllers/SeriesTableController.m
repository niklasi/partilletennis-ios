//
//  DivisionTable.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SeriesTableController.h"
#import "SeriesTable.h"
#import "DSActivityView.h"

@implementation SeriesTableController

@synthesize division, tableData, seriesTableCell;

- (id)init
{
    //self = [super initWithStyle:UITableViewStylePlain];
  self = [super initWithNibName:@"SeriesTableView" bundle:nil];  
	if (self) {
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
	[self setTitle:[NSString stringWithFormat:@"Division %ld", (long)self.division]];
	if (self.tableData.count == 0) {
		[DSActivityView newActivityViewForView:self.view withLabel:@"Laddar..."].showNetworkActivityIndicator = YES;
		[pfService loadSeriesTable:self.division];
	}
}


- (void)loadedSeriesTable:(NSArray *)seriesTable
{
	self.tableData = seriesTable;
	[self.tableView reloadData];
	[DSActivityView removeView];
}

- (void)PfServiceFailedWithError:(NSError *)error
{
	[DSActivityView removeView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
	return [self.tableData count];
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 61.0;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SeriesTableCellView";
    
    SeriesTableCell *cell = (SeriesTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
			//cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
			[[NSBundle mainBundle] loadNibNamed:@"SeriesTableCellView" owner:self options:nil];
			cell = seriesTableCell;
    }
    
	if (indexPath.row % 2 != 0) {
		cell.backgroundView = cell.alternateBackgroundView;
	}
	SeriesTable *seriesTable = (SeriesTable *)[[self tableData] objectAtIndex:[indexPath row]]; 

	cell.seriesTable = seriesTable;
	
	/*[cell textLabel].Text = seriesTable.teamName;
	[cell detailTextLabel].text = [NSString stringWithFormat:@"Matcher: %@, Matchp: %@, Lagpoäng: %@", 
																 seriesTable.matches,
																 seriesTable.matchPoints,
																 seriesTable.teamPoints];*/
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


@end
