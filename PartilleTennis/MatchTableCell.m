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
@property (nonatomic, strong) IBOutlet UILabel *currentRankLabel;

@end

@implementation MatchTableCell

@synthesize match = _match, teamLabel = _teamLabel, detailsLabel = _detailsLabel, currentRankLabel = _currentRankLabel;


-(void)setMatch:(Match *)value
{
	_match = value;
	self.teamLabel.text = [NSString stringWithFormat:@"%@ - %@ kl %@", 
												 self.match.teamName,
												 self.match.date,
												 self.match.time];
	self.detailsLabel.text = [NSString stringWithFormat:@"Banor: %@, %@", 
														self.match.lanes,
														self.match.homeMatch ? @"Hemmamatch" : @"Bortamatch"];
	self.currentRankLabel.text = @"";
}


@end
