//
//  MatchesController.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PfService.h"

@interface MatchesController : UITableViewController <PfServiceDelegate>
{
	PfService *pfService;
}

@property (nonatomic, retain) NSArray *matchData;

-(id)initWithSeries:(int)series team:(int)team;

@end
