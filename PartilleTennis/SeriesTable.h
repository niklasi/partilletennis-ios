//
//  SeriesTable.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeriesTable : NSObject
{
}

@property (nonatomic, strong) NSString *currentRank;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *matches;
@property (nonatomic, strong) NSString *matchPoints;
@property (nonatomic, strong) NSString *teamPoints;

@end
