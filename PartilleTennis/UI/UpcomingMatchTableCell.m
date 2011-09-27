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
	self.teamLabel.text = self.match.teamName;
	if (value.postponed && value.postponedToDate == nil) {
		self.dateLabel.text = @"";
		self.timeLabel.text = @"";
		self.detailsLabel.text = [NSString stringWithFormat:@"Matchen är uppskjuten tills vidare"];
	}
	else {
		if (value.postponed) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"]];
			[formatter setDateFormat:@"MMMM"];
			NSString *month = [[[formatter stringFromDate:value.postponedToDate] substringToIndex:3] lowercaseString];
			[formatter setDateFormat:@"d"];
			NSString *day = [formatter stringFromDate:value.postponedToDate];
			
			self.dateLabel.text = [NSString stringWithFormat:@"%@ %@", day, month];
			[formatter setDateFormat:@"HH"];
			self.timeLabel.text = [NSString stringWithFormat:@"kl %@", [formatter stringFromDate:value.postponedToDate]];
			self.detailsLabel.text = [NSString stringWithFormat:@"Flyttad match, %@", 
																self.match.homeMatch ? @"Hemmamatch" : @"Bortamatch"];
		}
		else {
			self.dateLabel.text = self.match.date;
			self.timeLabel.text = [NSString stringWithFormat:@"kl %@", self.match.time];
			self.detailsLabel.text = [NSString stringWithFormat:@"Banor: %@, %@", 
														self.match.lanes,
														self.match.homeMatch ? @"Hemmamatch" : @"Bortamatch"];
		}
	}
}


@end
