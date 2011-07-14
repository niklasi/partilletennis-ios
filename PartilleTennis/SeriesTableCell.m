//
//  SeriesTableCell.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SeriesTableCell.h"

@interface SeriesTableCell() {

}
@property (nonatomic, strong) IBOutlet UILabel *teamLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailsLabel;

@end

@implementation SeriesTableCell

@synthesize seriesTable = _seriesTable, alternateBackgroundView = _alternateBackgroundView, 
teamLabel = _teamLabel, detailsLabel = _detailsLabel;


-(void)setSeriesTable:(SeriesTable *)value
{
	_seriesTable = value;
	self.teamLabel.text = self.seriesTable.teamName;
	self.detailsLabel.text = [NSString stringWithFormat:@"Matcher: %@, Matchp: %@, Lagpoäng: %@", 
	 self.seriesTable.matches,
	 self.seriesTable.matchPoints,
	 self.seriesTable.teamPoints];
//	self.CurrentRankingLabel.text = self.seriesTable.
}

@end
