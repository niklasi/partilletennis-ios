//
//  MatchDetailController.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface MatchDetailController : UITableViewController
{
	Contact *contact;
}

@property (nonatomic, retain) Contact *contact;
@end
