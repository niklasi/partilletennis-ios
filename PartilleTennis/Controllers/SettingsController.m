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
-(void)restoreMessageTemplate;
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

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [self setMessageTemplateCell:nil];
    [super viewDidUnload];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) return @"Ditt lag";
	
	if (section == 1) return @"Bekräfta match";
    
    return @"Synka med kalender";
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

    if (indexPath.section == 1) {
        static NSString *cellIdentifier = @"confirmMessageTemplateTableCell";
        ConfirmMessageTemplateTableViewCell *cell = (ConfirmMessageTemplateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ConfirmMessageTemplateTableCellView" owner:self options:nil];
            cell = self.messageTemplateCell;
            UIToolbar *boolbar = [UIToolbar new];
            boolbar.barStyle = UIBarStyleBlack;
            [boolbar sizeToFit];
            
            
            UIBarButtonItem *restoreButton =[[UIBarButtonItem alloc] initWithTitle:@"Återställ" style:UIBarButtonItemStyleBordered target:self action:@selector(restoreMessageTemplate)];
            
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            UIBarButtonItem *cancelButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditingMessageTemplate)];
            UIBarButtonItem *saveButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEditingMessageTemplate)];
            
            NSArray *array = [NSArray arrayWithObjects:restoreButton, space, cancelButton, saveButton, nil];
            
            [boolbar setItems:array];
            cell.messageTemplateTextView.inputAccessoryView = boolbar;
        }
        
        cell.messageTemplateTextView.text = self.templateMessageService.templateText;
        
        return cell;
    }
    
    static NSString *cellIdentifier = @"syncWithCalendarCell";
    ConfirmMessageTemplateTableViewCell *cell = (ConfirmMessageTemplateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SyncWithCalendarTableViewCell" owner:self options:nil];
        cell = self.messageTemplateCell;
    }
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

-(void)restoreMessageTemplate
{
	self.messageTemplateCell.messageTemplateTextView.text = self.templateMessageService.defaultTemplateText;
}

-(void)saveEditingMessageTemplate
{
	UITextView *template = self.messageTemplateCell.messageTemplateTextView;
	self.templateMessageService.templateText = template.text;
	[self.templateMessageService saveTemplate];
	[template resignFirstResponder];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	TeamPickerController *teamPicker = [[TeamPickerController alloc] initWithNibName:@"TeamPickerView" bundle:nil];
    
	[self.navigationController pushViewController:teamPicker animated:YES];
    
    
}

@end
