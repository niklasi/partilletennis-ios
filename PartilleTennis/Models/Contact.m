//
//  Opponent.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize name, phone, email;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.phone = [aDecoder decodeObjectForKey:@"phone"];
	self.email = [aDecoder decodeObjectForKey:@"email"];

	return self;
	
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.phone forKey:@"phone"];
	[aCoder encodeObject:self.email forKey:@"email"];
}

@end
