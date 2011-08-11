//
//  SetResult.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Set.h"

@implementation Set

@synthesize myTeam = _myTeam, opponent = _opponent;

-(id)initWithSets:(int)myTeam opponent:(int)opponent
{
	self = [super init];
	if (self) {
		self.myTeam = myTeam;
		self.opponent = opponent;
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.myTeam = [aDecoder decodeIntForKey:@"myTeam"];
	self.opponent = [aDecoder decodeIntForKey:@"opponent"];
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:self.myTeam forKey:@"myTeam"];
	[aCoder encodeInt:self.opponent forKey:@"opponent"];
}

-(NSString *)asText
{
	return [NSString stringWithFormat:@"%d-%d", self.myTeam, self.opponent];
}
@end
