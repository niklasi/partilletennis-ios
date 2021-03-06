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

@property (nonatomic, strong) NSArray *matchResultTitles;
- (NSString *)matchResult:(NSArray *)sets;


@end

@implementation MatchDetailController

@synthesize match = _match, contactTableCell = _contactTableCell, myTeam = _myTeam;

- (id)init
{
	self = [super initWithNibName:@"MatchDetailView" bundle:nil];
    if (self)
    {
        self.matchResultTitles = @[@"Dubbel", @"1:a singel", @"2:a singel"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.title = self.match.teamName;
	[self.tableView reloadData];
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
	if (section == 0) return 3;
  if (section == 2) return 1;

	return self.match.postponed ? 4 : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	if (section == 0) {
		return @"Resultat";
	}
	
	if (section == 1) {
		return @"Skjut upp match";
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
				cell.detailTextLabel.text = [self matchResult:self.match.result.doubleSets];
			break;
		case 1:
				cell.detailTextLabel.text = [self matchResult:self.match.result.single1Sets];
			break;
		case 2:
				cell.detailTextLabel.text = [self matchResult:self.match.result.single2Sets];
			break;
		default:
			break;
		}
        
        cell.textLabel.text = self.matchResultTitles[indexPath.row];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
			cell.textLabel.text = @"Uppskjuten";
			if (self.match.postponed) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = [NSString stringWithFormat:@"Av %@", self.myTeam.name];
			if (!self.match.postponedByOpponent) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
		else if (indexPath.row == 2) {
			cell.textLabel.text = [NSString stringWithFormat:@"Av %@", self.match.teamName];
			if (self.match.postponedByOpponent) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
		else if (indexPath.row == 3) {
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
		[[NSBundle mainBundle] loadNibNamed:@"ContactTableCellView" owner:self options:nil];
		contactCell = self.contactTableCell;
	}
	
	contactCell.contact = self.match.contact;
	return contactCell;
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

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
		resultsController.title = self.matchResultTitles[indexPath.row];
		[self.navigationController pushViewController:resultsController animated:YES];
	}
	
	if (indexPath.section	 == 1) {
		if (indexPath.row != 3) {
			if (indexPath.row == 0) {
				self.match.postponed = !self.match.postponed;
			}
			else if (indexPath.row == 1) {
				self.match.postponedByOpponent = NO;
			}
			else if (indexPath.row == 2) {
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
        [self presentViewController:smsController animated:YES completion:nil];
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
        [self presentViewController:mailController animated:YES completion:nil];
	}
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
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
