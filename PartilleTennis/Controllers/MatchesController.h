//
//  MatchesController.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PfService.h"
#import "MatchTableCell.h"

@interface MatchesController : UITableViewController <PfServiceDelegate, SaveProtocol>
{
	PfService *pfService;
}

@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) IBOutlet MatchTableCell *matchTableCell;

@end
