//
//  MatchResult.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"

typedef enum {
	Won,
	Lost,
	Draw
} Result;

@interface MatchResult : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray *doubleSets;
@property (nonatomic, strong) NSMutableArray *single1Sets;
@property (nonatomic, strong) NSMutableArray *single2Sets;
@property (nonatomic, readonly) Result result;

-(int)calculateMatchPoint:(NSArray*) sets;
@end
