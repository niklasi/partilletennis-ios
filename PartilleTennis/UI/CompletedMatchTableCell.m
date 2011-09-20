//
//  CompletedMatchTableCell.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CompletedMatchTableCell.h"
#import "MatchResult.h"

@interface CompletedMatchTableCell() {

}
@property (strong, nonatomic) IBOutlet UILabel *teamLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation CompletedMatchTableCell

@synthesize teamLabel = _teamLabel, resultLabel = _resultLabel;


-(void)setMatch:(Match *)value
{
	[super setMatch:value];
	self.teamLabel.text = self.match.changedWithTeamName != nil ? self.match.changedWithTeamName : self.match.teamName;;
	
	NSString *resultText;
	int matchPoints = [value.result calculateTotalMatchPoints];
	UIImage *resultIcon;
	if (matchPoints > 3) {
		resultText = @"Vinst";
		resultIcon = [UIImage imageNamed:@"won.png"];
	}
	else if (matchPoints == 3) {
		resultText = @"Oavgjort";
		resultIcon = [UIImage imageNamed:@"draw.png"];
	}
	else {
		resultText = @"Förlust";
		resultIcon = [UIImage imageNamed:@"lost.png"];
	}
	
	self.resultLabel.text = [NSString stringWithFormat:@"%@: %d-%d", resultText, matchPoints, 6 - matchPoints];
	self.imageView.image = resultIcon;
	
}

@end
