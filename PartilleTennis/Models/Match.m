//
//  Match.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Match.h"

@interface Match()

@end

@implementation Match

- (NSDate *)playDate {
    if (self.postponed) {
        return self.postponedToDate;
    }
    NSArray *months = @[@"jan", @"feb", @"mar", @"apr", @"maj", @"jun", @"jul", @"aug", @"sep", @"okt", @"nov", @"dec"];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = [self.date substringToIndex:2].intValue;
    
    comps.month = [months indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [self.date rangeOfString:((NSString *)obj)].location != NSNotFound;
    }] + 1;
    
    comps.year = self.year;
    comps.hour = self.time.intValue;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}

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
	self.postponed = [aDecoder decodeBoolForKey:@"postponed"];
	self.postponedByOpponent = [aDecoder decodeBoolForKey:@"postponedByOpponent"];
	self.postponedToDate = [aDecoder decodeObjectForKey:@"postponedToDate"];

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
	[aCoder encodeBool:self.postponed forKey:@"postponed"];
	[aCoder encodeBool:self.postponedByOpponent forKey:@"postponedByOpponent"];
	[aCoder encodeObject:self.postponedToDate forKey:@"postponedToDate"];
}
/*
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
}*/

@end
