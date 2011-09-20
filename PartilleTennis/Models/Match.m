//
//  Match.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Match.h"

@implementation Match

@synthesize teamName = _teamName, season = _season, year = _year, date = _date, time = _time, lanes = _lanes, 
contact = _contact, homeMatch = _homeMatch, result = _result, changedWithTeamName = _changedWithTeamName;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	
	self.teamName = [aDecoder decodeObjectForKey:@"teamName"];
	self.season = [aDecoder decodeObjectForKey:@"season"];
	if (self.season == nil) {
		self.season = @"fall";
	}
	self.year = [aDecoder decodeIntForKey:@"year"];
	if (self.year == 0) {
		self.year = 2011;
	}
	self.date = [aDecoder decodeObjectForKey:@"date"];
	self.time = [aDecoder decodeObjectForKey:@"time"];
	self.lanes = [aDecoder decodeObjectForKey:@"lanes"];
	self.contact = [aDecoder decodeObjectForKey:@"contact"];
	self.homeMatch = [aDecoder decodeIntForKey:@"homeMatch"] == 1 ? YES : NO;
	self.result = [aDecoder decodeObjectForKey:@"result"];
	self.changedWithTeamName = [aDecoder decodeObjectForKey:@"changedWithTeamName"];
	return self;
	
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.teamName forKey:@"teamName"];
	[aCoder encodeObject:self.season forKey:@"season"];
	[aCoder encodeInt:self.year forKey:@"year"];
	[aCoder encodeObject:self.date forKey:@"date"];
	[aCoder encodeObject:self.time forKey:@"time"];
	[aCoder encodeObject:self.lanes forKey:@"lanes"];
	[aCoder encodeObject:self.contact forKey:@"contact"];
	[aCoder encodeInt:self.homeMatch == YES ? 1 : 0 forKey:@"homeMatch"];
	[aCoder encodeObject:self.result forKey:@"result"];
	[aCoder encodeObject:self.changedWithTeamName forKey:@"changedWithTeamName"];
}

-(id)copyWithZone:(NSZone *)zone
{
	Match *match = [[Match alloc] init];
	match.teamName = self.teamName;
	match.season = self.season;
	match.year = self.year;
	match.date = self.date;
	match.time = self.time;
	match.lanes = self.lanes;
	match.contact = self.contact;
	match.homeMatch = self.homeMatch;
	match.result = self.result;
	match.changedWithTeamName = self.changedWithTeamName;
	return match;
}

-(BOOL)isEqual:(id)object
{
	if ([object class] != self.class) return false;
	Match *tmp = (Match *)object;
	if (![self.teamName isEqualToString:tmp.teamName]) return false;
	if (![self.season isEqualToString:tmp.season]) return false;
	if (!(self.year == tmp.year)) return false;
	if (![self.date isEqualToString:tmp.date]) return false;
	if (![self.time isEqualToString:tmp.time]) return false;
	
	return true;
}

-(NSUInteger)hash
{
	NSString *hashString = [NSString stringWithFormat:@"%@-%@-%d-%@-%@", self.teamName, self.season, self.year, self.date, self.time];
	return [hashString hash];
}

@end
