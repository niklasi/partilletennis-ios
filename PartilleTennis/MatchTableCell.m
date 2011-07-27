//
//  MatchTableCell.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MatchTableCell.h"

@interface MatchTableCell() {
	
}
@property (nonatomic, strong) IBOutlet UILabel *teamLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation MatchTableCell

@synthesize match = _match, teamLabel = _teamLabel, detailsLabel = _detailsLabel, dateLabel = _dateLabel, timeLabel	= _timeLabel;


-(void)setMatch:(Match *)value
{
	_match = value;
	self.teamLabel.text = self.match.teamName;
	self.dateLabel.text = self.match.date;
	self.timeLabel.text = [NSString stringWithFormat:@"kl %@", self.match.time];
	self.detailsLabel.text = [NSString stringWithFormat:@"Banor: %@, %@", 
														self.match.lanes,
														self.match.homeMatch ? @"Hemmamatch" : @"Bortamatch"];
}


@end
