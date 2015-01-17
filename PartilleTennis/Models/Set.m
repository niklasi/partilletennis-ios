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

-(id)initWithSets:(NSInteger)myTeam opponent:(NSInteger)opponent
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
	[aCoder encodeInteger:self.myTeam forKey:@"myTeam"];
	[aCoder encodeInteger:self.opponent forKey:@"opponent"];
}

-(NSString *)asText
{
	return [NSString stringWithFormat:@"%ld-%ld", self.myTeam, self.opponent];
}
@end
