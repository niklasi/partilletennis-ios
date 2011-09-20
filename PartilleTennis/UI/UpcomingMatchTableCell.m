//
//  UpcomingMatchTableCell.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UpcomingMatchTableCell.h"

@interface UpcomingMatchTableCell() {
	
}
@property (nonatomic, strong) IBOutlet UILabel *teamLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation UpcomingMatchTableCell

@synthesize teamLabel = _teamLabel, detailsLabel = _detailsLabel, dateLabel = _dateLabel, timeLabel	= _timeLabel;

-(void)setMatch:(Match *)value
{
	[super setMatch:value];
	self.teamLabel.text = self.match.changedWithTeamName != nil ? self.match.changedWithTeamName : self.match.teamName;
	self.dateLabel.text = self.match.date;
	self.timeLabel.text = [NSString stringWithFormat:@"kl %@", self.match.time];
	self.detailsLabel.text = [NSString stringWithFormat:@"Banor: %@, %@", 
														self.match.lanes,
														self.match.homeMatch ? @"Hemmamatch" : @"Bortamatch"];
}


@end
