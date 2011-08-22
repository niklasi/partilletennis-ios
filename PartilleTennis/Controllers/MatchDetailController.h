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

@interface MatchDetailController : UITableViewController <MFMessageComposeViewControllerDelegate>
{
}

@property (nonatomic, retain) Match *match;
@end
