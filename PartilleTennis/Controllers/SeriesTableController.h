//
//  DivisionTable.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PfService.h"
#import "SeriesTableCell.h"

@interface SeriesTableController : UITableViewController <PfServiceDelegate>
{
	PfService *pfService;
}

@property (nonatomic) NSInteger division;
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, assign) IBOutlet SeriesTableCell *seriesTableCell;

@end
