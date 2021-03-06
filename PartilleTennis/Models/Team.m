//
//  Team.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Team.h"

@implementation Team

@synthesize name, division, ranking;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.division	= [aDecoder decodeIntForKey:@"division"];
	self.ranking = [aDecoder decodeIntForKey:@"ranking"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeInt:self.division forKey:@"division"];
	[aCoder encodeInt:self.ranking forKey:@"ranking"];
}

-(BOOL)isEqual:(id)object
{
	if ([object class] != self.class) return false;
	Team *tmp = (Team *)object;
	if (![self.name isEqualToString:tmp.name]) return false;
	if (self.division != tmp.division) return false;

	return true;
}

-(NSUInteger)hash
{
	NSString *hashString = [NSString stringWithFormat:@"%@-%d", self.name, self.division];
	return [hashString hash];
}

@end
