//
//  SeriesTableCell.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeriesTable.h"

@interface SeriesTableCell : UITableViewCell {
}

@property (nonatomic, assign) IBOutlet UIView *alternateBackgroundView;
@property (nonatomic, strong) SeriesTable *seriesTable;

@end
