//
//  PfService.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PfService.h"
#import "Match.h"
#import "SeriesTable.h"

@interface PfService(private)

- (void)parseMatches:(NSArray *)array;
- (void)parseSeriesTable:(NSArray *)array;

@end

@implementation PfService

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
			// We don't want *all* the individual messages from the
			// SBJsonStreamParser, just the top-level objects. The stream
			// parser adapter exists for this purpose.
			adapter = [[SBJsonStreamParserAdapter alloc] init];
			
			adapter.delegate = self;
			
			parser = [[SBJsonStreamParser alloc] init];
			
			parser.delegate = adapter;
			
			// Normally it's an error if JSON is followed by anything but
			// whitespace. Setting this means that the parser will be
			// expecting the stream to contain multiple whitespace-separated
			// JSON documents.
			parser.supportMultipleDocuments = NO;
    }
    
    return self;
}

-(void)loadMatches:(int)series team:(int)team
{
	if ([delegate respondsToSelector:@selector(loadedMatches:)]) {
		
		NSString *url = [NSString stringWithFormat:@"http://sharp-robot-596.heroku.com/teams/matches/%d/%d?output=json", series, team];
		
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
																							cachePolicy:NSURLRequestUseProtocolCachePolicy
																					timeoutInterval:60.0];
		
		[NSURLConnection connectionWithRequest:theRequest delegate:self];
		NSLog(@"Load matches");
	}
}

-(void)loadSeriesTable:(int)series
{

	if ([delegate respondsToSelector:@selector(loadedSeriesTable:)]) {
		
		NSString *url = [NSString stringWithFormat:@"http://sharp-robot-596.heroku.com/series/%d?output=json", series];
		
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
																							cachePolicy:NSURLRequestUseProtocolCachePolicy
																					timeoutInterval:60.0];		
		[NSURLConnection connectionWithRequest:theRequest delegate:self];
		NSLog(@"Load series");
	}
}


- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
	
	NSLog(@"Parser...");
	if (array.count == 0) return;
	
	NSDictionary *data = (NSDictionary *)[array objectAtIndex:0]; 
	if ([data objectForKey:@"lanes"] /*Match-data*/) {
		[self parseMatches:array];
	}
	else if([data objectForKey:@"match_points"])
	{
		[self parseSeriesTable:array];
	}
}

- (void)parser:(SBJsonStreamParser*)parser foundObject:(NSDictionary*)dict
{
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Connection didReceiveResponse: %@ - %@", response, [response MIMEType]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"Connection didReceiveAuthenticationChallenge: %@", challenge);
	
	/*NSURLCredential *credential = [NSURLCredential credentialWithUser:username.text
	 password:password.text
	 persistence:NSURLCredentialPersistenceForSession];
	 
	 [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];*/
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"Connection didReceiveData of length: %u", data.length);
	
	// Parse the new chunk of data. The parser will append it to
	// its internal buffer, then parse from where it left off in
	// the last chunk.
	SBJsonStreamParserStatus status = [parser parse:data];
	
	if (status == SBJsonStreamParserError) {
		//tweet.text = [NSString stringWithFormat: @"The parser encountered an error: %@", parser.error];
		NSLog(@"Parser error: %@", parser.error);
		
	} else if (status == SBJsonStreamParserWaitingForData) {
		NSLog(@"Parser waiting for more data");
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed! Error - %@ %@",
				[error localizedDescription],
				[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
}


- (void)parseMatches:(NSArray *)array
{
	if ([delegate respondsToSelector:@selector(loadedMatches:)]) {
		NSMutableArray *loadedMatches = [[NSMutableArray alloc] init];
	
		for (int i = 0; i < [array count]; i++) {
			NSDictionary *matchData = (NSDictionary *)[array objectAtIndex:i];
			NSDictionary *opponentData = (NSDictionary *)[matchData objectForKey:@"opponent"];
			Match *match = [[Match alloc] init];
			match.teamName = [opponentData objectForKey:@"team_name"];
			match.date = [matchData objectForKey:@"date"];
			match.time = [matchData objectForKey:@"time"];
			match.lanes = [matchData objectForKey:@"lanes"];
			match.homeMatch = [[matchData objectForKey:@"home_match"] boolValue];
			NSLog(@"Hemma match: %d", match.homeMatch);
			Contact *contact = [[Contact alloc] init];
			contact.name = [opponentData objectForKey:@"contact"];
			contact.phone = [opponentData objectForKey:@"phone"];
			contact.email = [opponentData objectForKey:@"email"];
			match.contact = contact;
			[loadedMatches addObject:match];
		}
		
		[delegate loadedMatches:loadedMatches];
	}
}

- (void)parseSeriesTable:(NSArray *)array
{
	if ([delegate respondsToSelector:@selector(loadedSeriesTable:)]) {
		NSMutableArray *loadedSeriesTable = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < [array count]; i++) {
			NSDictionary *seriesData = (NSDictionary *)[array objectAtIndex:i];
			SeriesTable *seriesTable = [[SeriesTable alloc] init];
			seriesTable.currentRank = [NSString stringWithFormat:@"%@", [seriesData objectForKey:@"currentRank"]];
			seriesTable.teamName = [seriesData objectForKey:@"team"];
			seriesTable.matches = [seriesData objectForKey:@"matches"];
			seriesTable.matchPoints = [seriesData objectForKey:@"match_points"];
			seriesTable.teamPoints = [seriesData objectForKey:@"team_points"];
			[loadedSeriesTable addObject:seriesTable];
		}
		
		[delegate loadedSeriesTable:loadedSeriesTable];
	}
}

@end
