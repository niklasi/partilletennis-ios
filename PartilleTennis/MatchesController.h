//
//  MatchesController.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@class SBJsonStreamParser;
@class SBJsonStreamParserAdapter;

@interface MatchesController : UITableViewController <SBJsonStreamParserAdapterDelegate>
{
	NSURLConnection *theConnection;
	SBJsonStreamParser *parser;
	SBJsonStreamParserAdapter *adapter;
}

@property (nonatomic, retain) NSArray *matchData;

- (IBAction)go;

@end
