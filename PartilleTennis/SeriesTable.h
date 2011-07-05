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
	NSString *teamName;
	NSString *matches;
	NSString *matchPoints;
	NSString *teamPoints;
}

@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *matches;
@property (nonatomic, retain) NSString *matchPoints;
@property (nonatomic, retain) NSString *teamPoints;

@end
