//
//  CompletedMatchTableCell.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CompletedMatchTableCell.h"

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
	self.teamLabel.text = self.match.teamName;

	self.resultLabel.text = @"Vinst: 4-2";
}

@end
