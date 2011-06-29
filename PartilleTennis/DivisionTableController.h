//
//  DivisionTable.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@class SBJsonStreamParser;
@class SBJsonStreamParserAdapter;

@interface DivisionTableController : UITableViewController <SBJsonStreamParserAdapterDelegate>
{
	NSURLConnection *theConnection;
	SBJsonStreamParser *parser;
	SBJsonStreamParserAdapter *adapter;
}

@property (nonatomic) int division;
@property (nonatomic, retain) NSArray *tableData;

- (IBAction)go;
@end
