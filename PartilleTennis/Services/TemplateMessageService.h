//
//  TemplateMessageService.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"

@interface TemplateMessageService : NSObject

@property (nonatomic, strong) NSString *templateText;
@property (readonly, strong) NSString *defaultTemplateText;

-(void)saveTemplate;
-(NSString *)confirmMessage:(Match *)match team:(Team *)team;
@end
