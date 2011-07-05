//
//  PfService.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PfService.h"
#import "Match.h"

@interface PfService(private)

- (void)parseMatches:(NSArray *)array;

@end

@implementation PfService

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)loadMatches:(int)series team:(int)team
{
	if ([delegate respondsToSelector:@selector(loadedMatches:)]) {
		
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
		
		NSString *url = [NSString stringWithFormat:@"http://sharp-robot-596.heroku.com/matches/%d/%d?output=json", series, team];
		
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
																							cachePolicy:NSURLRequestUseProtocolCachePolicy
																					timeoutInterval:60.0];
		
		theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
		NSLog(@"Load matches");
	}
}

- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
	
	NSLog(@"Parser...");
	if (array.count == 0) return;
	
	NSDictionary *data = (NSDictionary *)[array objectAtIndex:0]; 
	if ([data objectForKey:@"lanes"] /*Match-data*/) {
		[self parseMatches:array];
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
			match.teamName = [opponentData objectForKey:@"teamName"];
			match.date = [matchData objectForKey:@"date"];
			match.time = [matchData objectForKey:@"time"];
			match.lanes = [matchData objectForKey:@"lanes"];
			[loadedMatches addObject:match];
		}
		
		[delegate loadedMatches:loadedMatches];
	}
}

@end
