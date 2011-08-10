//
//  Match.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Match.h"

@implementation Match

@synthesize teamName = _teamName, date = _date, time = _time, lanes = _lanes, 
contact = _contact, homeMatch = _homeMatch, result = _result;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
	Match *match = [[Match alloc] init];
	match.teamName = self.teamName;
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
	if (self.date != tmp.date) return false;
	if (self.time != tmp.time) return false;
	
	return true;
}

-(NSUInteger)hash
{
	NSString *hashString = [NSString stringWithFormat:@"%@-%d-%d", self.teamName, self.date, self.time];
	return [hashString hash];
}

@end
