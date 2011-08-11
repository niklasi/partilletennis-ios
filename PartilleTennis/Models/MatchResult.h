//
//  MatchResult.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MatchResult : NSObject <NSCoding>

@property (nonatomic, readonly) BOOL completeResult;
@property (nonatomic, strong) NSMutableArray *doubleSets;
@property (nonatomic, strong) NSMutableArray *single1Sets;
@property (nonatomic, strong) NSMutableArray *single2Sets;

-(int)calculateTotalMatchPoints;
-(int)calculateMatchPoints:(NSArray*) sets;
@end
