//
//  MatchResult.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MatchResult.h"
#import "Set.h"


@implementation MatchResult

@synthesize doubleSets = _doubleSets, single1Sets = _single1Sets, single2Sets = _single2Sets;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	
	self.doubleSets = [aDecoder decodeObjectForKey:@"doubleSets"];
	self.single1Sets = [aDecoder decodeObjectForKey:@"single1Sets"];
	self.single2Sets = [aDecoder decodeObjectForKey:@"single2Sets"];
	return self;
	
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.doubleSets forKey:@"doubleSets"];
	[aCoder encodeObject:self.single1Sets forKey:@"single1Sets"];
	[aCoder encodeObject:self.single2Sets forKey:@"single2Sets"];
}

-(Result)result
{
	int totalMatchPoints = [self calculateMatchPoint:self.doubleSets];
	totalMatchPoints += [self calculateMatchPoint:self.single1Sets];
	totalMatchPoints += [self calculateMatchPoint:self.single2Sets];
	
	if (totalMatchPoints > 3) return Won;
	if (totalMatchPoints < 3) return Lost;
	
	return Draw;
}

-(int)calculateMatchPoint:(NSArray*) sets
{
	const int MATCH_POINTS_WON = 2;
	const int MATCH_POINTS_DRAW = 1;
	const int MATCH_POINTS_LOST = 0;
	
	int numberOfSetsWon = 0;
	int numberOfSetsLost = 0;
	
	Set *unfinnishedSet;
	
	for (Set *set in sets) {
		BOOL finnished = NO;
		if (set.myTeam == 4) {
			numberOfSetsWon += 1;
			finnished = YES;
		}
		
		if (set.opponent == 4) {
			numberOfSetsLost += 1;
			finnished = YES;
		}
		
		if (finnished == NO) {
			unfinnishedSet = set;
		}
	}
	
	if (numberOfSetsWon > numberOfSetsLost) return MATCH_POINTS_WON;
	if (numberOfSetsWon < numberOfSetsLost) return MATCH_POINTS_LOST;
	
	if (unfinnishedSet == nil) return MATCH_POINTS_DRAW;
	
	int gameDiff = unfinnishedSet.myTeam - unfinnishedSet.opponent;
	
	if (gameDiff >= 2 ) return MATCH_POINTS_WON;
	if (gameDiff <= -2) return MATCH_POINTS_LOST;
	
	return MATCH_POINTS_DRAW;

	
}

@end
