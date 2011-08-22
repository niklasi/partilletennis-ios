//
//  MatchDetailController.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"
#import <MessageUI/MessageUI.h>
#import "ContactTableCell.h"

@interface MatchDetailController : UITableViewController <MFMessageComposeViewControllerDelegate>
{
}

@property (nonatomic, strong) Match *match;
@property (nonatomic, strong) IBOutlet ContactTableCell *contactTableCell;

-(IBAction)sendSms:(id)sender;
@end
