//
//  SeriesTable.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SeriesTable.h"

@implementation SeriesTable

@synthesize teamName = _teamName, matches = _matches, matchPoints = _matchPoints, teamPoints = _teamPoints, currentRank = _currentRank;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
