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
#import "Team.h"

@interface PfService()

@property (nonatomic, strong) SBJsonStreamParser *parser;
@property (nonatomic, strong) SBJsonStreamParserAdapter *adapter;
@property (nonatomic, readonly) BOOL useLocalFile;

- (void)parseTeams:(NSArray *)array;
- (void)parseMatches:(NSArray *)array;
- (void)parseSeriesTable:(NSArray *)array;

@end

@implementation PfService

@synthesize delegate, parser = _parser, adapter = _adapter;

- (id)init
{
    self = [super init];
    if (self) {
			// We don't want *all* the individual messages from the
			// SBJsonStreamParser, just the top-level objects. The stream
			// parser adapter exists for this purpose.
			self.adapter = [[SBJsonStreamParserAdapter alloc] init];
			
			self.adapter.delegate = self;
			
			self.parser = [[SBJsonStreamParser alloc] init];
			
			self.parser.delegate = self.adapter;
			
			// Normally it's an error if JSON is followed by anything but
			// whitespace. Setting this means that the parser will be
			// expecting the stream to contain multiple whitespace-separated
			// JSON documents.
			self.parser.supportMultipleDocuments = YES;
    }
    
    return self;
}

-(BOOL)useLocalFile
{
	return [[[[NSProcessInfo processInfo] environment] objectForKey:@"NO_NETWORK"] intValue] == 1;
}

-(void)loadAllTeams
{
	if ([delegate respondsToSelector:@selector(loadedTeams:)]) {
		
		NSURLRequest *theRequest;
		
		if (self.useLocalFile == YES) {
			theRequest=[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"allTeams" ofType:@"json"]isDirectory:NO]];	
		}
		else {
			NSString *url = @"http://sharp-robot-596.heroku.com/teams/all?output=json";
		
			theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
																							cachePolicy:NSURLRequestUseProtocolCachePolicy
																					timeoutInterval:60.0];
		}
		
		[NSURLConnection connectionWithRequest:theRequest delegate:self];
		NSLog(@"Load teams");
	}
}

-(void)loadMatches:(int)series team:(int)team
{
	if ([delegate respondsToSelector:@selector(loadedMatches:)]) {
		
		NSURLRequest *theRequest;
	
		if (self.useLocalFile == YES) {
			theRequest=[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"matches" ofType:@"json"]isDirectory:NO]];	
		}
		else {
			NSString *url = [NSString stringWithFormat:@"http://sharp-robot-596.heroku.com/teams/matches/%d/%d?output=json", series, team];
			
			theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
																							cachePolicy:NSURLRequestUseProtocolCachePolicy
																				timeoutInterval:60.0];
		}
		
		
		[NSURLConnection connectionWithRequest:theRequest delegate:self];
		NSLog(@"Load matches");
	}
}

-(void)loadSeriesTable:(int)series
{

	if ([delegate respondsToSelector:@selector(loadedSeriesTable:)]) {
		
		NSURLRequest *theRequest;
		
		if (self.useLocalFile == YES) {
			theRequest=[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"series%d", series] ofType:@"json"]isDirectory:NO]];	
		}
		else {
		NSString *url = [NSString stringWithFormat:@"http://sharp-robot-596.heroku.com/series/%d?output=json", series];
		
			theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
																							cachePolicy:NSURLRequestUseProtocolCachePolicy
																					timeoutInterval:60.0];		
		}
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
	else if ([data objectForKey:@"division"])
	{
		[self parseTeams:array];
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
	SBJsonStreamParserStatus status = [self.parser parse:data];
	
	if (status == SBJsonStreamParserError) {
		//tweet.text = [NSString stringWithFormat: @"The parser encountered an error: %@", parser.error];
		NSLog(@"Parser error: %@", self.parser.error);
		
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

- (void)parseTeams:(NSArray *)array
{
	if ([delegate respondsToSelector:@selector(loadedTeams:)]) {
		NSMutableArray *loadedTeams = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < [array count]; i++) {
			NSDictionary *teamData = (NSDictionary *)[array objectAtIndex:i];
			Team *team = [[Team alloc] init];
			team.name = [teamData objectForKey:@"team_name"];
			team.division =  [[teamData objectForKey:@"division"] intValue];
			team.ranking = [[teamData objectForKey:@"team_ranking"] intValue];
			
			[loadedTeams addObject:team];
		}
		
		[delegate loadedTeams:loadedTeams];
	}
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
