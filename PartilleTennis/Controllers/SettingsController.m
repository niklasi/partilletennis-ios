//
//  SettingsController.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"
#import "TeamPickerController.h"
#import "ConfirmMessageTemplateTableViewCell.h"
#import "TemplateMessageService.h"

@interface SettingsController(){

}
@property (strong, nonatomic) IBOutlet ConfirmMessageTemplateTableViewCell *messageTemplateCell;
@property (strong, nonatomic) TemplateMessageService *templateMessageService;

-(void)cancelEditingMessageTemplate;
-(void)saveEditingMessageTemplate;
@end

@implementation SettingsController
@synthesize messageTemplateCell = _messageTemplateCell, templateMessageService = _templateMessageService;

- (id)init
{
	self = [super initWithNibName:@"SettingsView" bundle:nil];
    if (self) {
			self.title = @"Inställningar";
			self.templateMessageService = [[TemplateMessageService alloc] init];
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
    [self setMessageTemplateCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
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
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) return @"Ditt lag";
	
	return @"Bekräfta match";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) return 110;
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
		id<TeamDelegateProtocol> teamDelegate = (id<TeamDelegateProtocol>) [UIApplication sharedApplication].delegate;
		Team *myTeam = teamDelegate.myTeam;
		cell.textLabel.text = @"Välj lag";
		cell.detailTextLabel.text = myTeam.name;
	
		return cell;
	}

	static NSString *cellIdentifier = @"confirmMessageTemplateTableCell";
	ConfirmMessageTemplateTableViewCell *cell = (ConfirmMessageTemplateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		//cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		[[NSBundle mainBundle] loadNibNamed:@"ConfirmMessageTemplateTableCellView" owner:self options:nil];
		cell = self.messageTemplateCell;
		UIToolbar *boolbar = [UIToolbar new];
		boolbar.barStyle = UIBarStyleBlack;
		[boolbar sizeToFit];
		
		
		UIBarButtonItem *saveButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEditingMessageTemplate)];
		UIBarButtonItem *cancelButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditingMessageTemplate)];
		UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		NSArray *array = [NSArray arrayWithObjects:space, cancelButton, saveButton, nil];
		
		[boolbar setItems:array];
		cell.messageTemplateTextView.inputAccessoryView = boolbar;
	}

	cell.messageTemplateTextView.text = self.templateMessageService.templateText;
	
	return cell;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

-(void)cancelEditingMessageTemplate
{
	[self.messageTemplateCell.messageTemplateTextView resignFirstResponder];
}

-(void)saveEditingMessageTemplate
{
	UITextView *template = self.messageTemplateCell.messageTemplateTextView;
	self.templateMessageService.templateText = template.text;
	[self.templateMessageService saveTemplate];
	[template resignFirstResponder];
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
	TeamPickerController *teamPicker = [[TeamPickerController alloc] initWithNibName:@"TeamPickerView" bundle:nil];
    
	[self.navigationController pushViewController:teamPicker animated:YES];
    
    
}

@end
