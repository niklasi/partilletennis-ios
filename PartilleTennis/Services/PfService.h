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
- (void)PfServiceFailedWithError:(NSError *)error;
@optional
- (void)loadedTeams:(NSArray *)teams;
- (void)loadedMatches:(NSArray *)matches;
- (void)loadedSeriesTable:(NSArray *)seriesTable;
@end

@interface PfService : NSObject <SBJsonStreamParserAdapterDelegate>
{
}

@property (nonatomic, assign) id<PfServiceDelegate> delegate;

-(void)loadAllTeams;
-(void)loadMatches:(NSString *)team season:(NSString *)season year:(int)year;
-(void)loadSeriesTable:(NSInteger)series;

@end
