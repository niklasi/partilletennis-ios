//
//  PfService.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@class SBJsonStreamParser;
@class SBJsonStreamParserAdapter;

@protocol PfServiceDelegate <NSObject>

@optional
- (void)loadedMatches:(NSArray *)matches;
- (void)loadedSeriesTable:(NSArray *)seriesTable;
@end

@interface PfService : NSObject <SBJsonStreamParserAdapterDelegate, PfServiceDelegate>
{
	__unsafe_unretained id<PfServiceDelegate> delegate;
	@private
	SBJsonStreamParser *parser;
	SBJsonStreamParserAdapter *adapter;
}

@property (nonatomic, assign) id<PfServiceDelegate> delegate;

-(void)loadMatches:(int)series team:(int)team;
-(void)loadSeriesTable:(int)series;

@end