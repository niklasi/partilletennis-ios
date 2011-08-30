//
//  TemplateMessageService.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateMessageService.h"

@implementation TemplateMessageService

@synthesize templateText = _templateText, defaultTemplateText = _defaultTemplateText;

-(id)init
{
	if (self = [super init]) {
		self.templateText = [NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(@"messageTemplate")];
		_defaultTemplateText = @"Hej, vi har tennismatch den {datum} kl {tid}.\nKan ni spela då?\n\nMvh\n{lag}";
		if (self.templateText == nil) {
			self.templateText = self.defaultTemplateText;
		}
	}
	return self;
}

-(void)saveTemplate
{
	[NSKeyedArchiver archiveRootObject:self.templateText toFile:pathInDocumentDirectory(@"messageTemplate")];
}

-(NSString *)confirmMessage:(Match *)match team:(Team *)team
{
	NSString *message = self.templateText;
	
	message = [message stringByReplacingOccurrencesOfString:@"{datum}" withString:match.date];
	message = [message stringByReplacingOccurrencesOfString:@"{tid}" withString:match.time];
	message = [message stringByReplacingOccurrencesOfString:@"{lag}" withString:team.name];
	
	return message;
}
@end
