//
//  MatchDetailController.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MatchDetailController.h"
#import "EditMatchResultController.h"
#import "Set.h"
#import "TemplateMessageService.h"
#import "NewMatchTimeController.h"

@interface MatchDetailController() {
}

-(NSString *)matchResult:(NSArray *)sets;

@end

@implementation MatchDetailController

@synthesize match = _match, contactTableCell = _contactTableCell, myTeam = _myTeam;

- (id)init
{
	self = [super initWithNibName:@"MatchDetailView" bundle:nil];
    if (self) {
			//[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
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
	self.title = self.match.teamName;
	[self.tableView reloadData];
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
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 2) return 1;

	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	if (section == 0) {
		return @"Resultat";
	}
	
	if (section == 1) {
		return @"Uppskjuten match";
	}
	
	return @"Kontakt";
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 2) return 96;
	
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
	switch (indexPath.row) {
		case 0:
				cell.textLabel.text = @"Dubbel";
				cell.detailTextLabel.text = [self matchResult:self.match.result.doubleSets];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 1:
				cell.textLabel.text = @"1:a singel";
				cell.detailTextLabel.text = [self matchResult:self.match.result.single1Sets];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 2:
				cell.textLabel.text = @"2:a singel";
				cell.detailTextLabel.text = [self matchResult:self.match.result.single2Sets];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		default:
			break;
		}
		
		return cell;
	}
	
	if (indexPath.section == 1) {
		static NSString *CellIdentifier = @"MoveMatch";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
		cell.accessoryType = UITableViewCellAccessoryNone;
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Oss själva";
			if (!self.match.postponedByOpponent) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = [NSString stringWithFormat:@"%@", self.match.teamName];
			if (self.match.postponedByOpponent) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
			cell.textLabel.text = @"Ny tid";
			cell.detailTextLabel.text = @"Ingen ny tid än";
			if (self.match.postponedToDate != nil) {
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat: @"yyyy-MM-dd HH:mm"];
				cell.detailTextLabel.text = [formatter stringFromDate:self.match.postponedToDate];
			}
		}
		return cell;
	}
	
	
	ContactTableCell *contactCell = (ContactTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactTableCellView"];
	if (contactCell == nil) {
		//cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		[[NSBundle mainBundle] loadNibNamed:@"ContactTableCellView" owner:self options:nil];
		contactCell = self.contactTableCell;
	}
	
	contactCell.contact = self.match.contact;
	return contactCell;
	
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
	//if (indexPath.section == 1) return NO;
	//return YES;
}


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
    return NO;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		
		EditMatchResultController *resultsController = [[EditMatchResultController alloc] init];
    if (!self.match.result) {
			self.match.result = [[MatchResult alloc] init];
		}
			
		switch (indexPath.row) {
			case 0:
				if (!self.match.result.doubleSets) {
					self.match.result.doubleSets = [[NSMutableArray alloc] init];
				}
				resultsController.sets = self.match.result.doubleSets;
				break;
			case 1:
				if (!self.match.result.single1Sets) {
					self.match.result.single1Sets = [[NSMutableArray alloc] init];
				}
				resultsController.sets = self.match.result.single1Sets;
				break;
			case 2:
				if (!self.match.result.single2Sets) {
					self.match.result.single2Sets = [[NSMutableArray alloc] init];
				}
				resultsController.sets = self.match.result.single2Sets;
				break;
			default:
				break;
		}
		
		[self.navigationController pushViewController:resultsController animated:YES];
	}
	
	if (indexPath.section	 == 1) {
		if (indexPath.row != 2) {
			
		if (indexPath.row == 0) {
			self.match.postponedByOpponent = NO;
		}
		else if (indexPath.row == 1) {
			self.match.postponedByOpponent = YES;
		}
		[self.tableView reloadData];
		}
		else {
			NewMatchTimeController *timeController = [[NewMatchTimeController alloc] init];
			timeController.match = self.match;
			[self.navigationController pushViewController:timeController animated:YES];
		}
	}
}

-(IBAction)dial:(id)sender
{
	NSURL *phoneURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@", self.match.contact.phone]];
	[[UIApplication sharedApplication] openURL:phoneURL];
}

-(IBAction)sendSms:(id)sender
{
	if ([MFMessageComposeViewController canSendText]) {
		MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
		smsController.recipients = [[NSArray alloc] initWithObjects:self.match.contact.phone, nil];
		smsController.body = [[[TemplateMessageService alloc] init] confirmMessage:self.match team:self.myTeam];
		smsController.messageComposeDelegate = self;
		[self presentModalViewController:smsController animated:YES];
	}
}

-(IBAction)sendEmail:(id)sender
{
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		[mailController setToRecipients: [[NSArray alloc] initWithObjects:self.match.contact.email, nil]];
		[mailController setSubject: @"Tennismatch"];
		[mailController setMessageBody: [[[TemplateMessageService alloc] init] confirmMessage:self.match team:self.myTeam] isHTML:NO];
		mailController.mailComposeDelegate = self;
		[self presentModalViewController:mailController animated:YES];
	}
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];	
}

-(NSString *)matchResult:(NSArray *)sets
{
	if (sets.count == 0) return @"";
	NSString *resultText = [NSString stringWithFormat: @"%@", [(Set *)[sets objectAtIndex:0] asText]];
	
	for (int count = 1; count < sets.count; count++) {
		Set *set = [sets objectAtIndex:count];
		resultText = [resultText stringByAppendingString:[NSString stringWithFormat:@", %@", [set asText]]];
	}
	
	return resultText;
}
@end
