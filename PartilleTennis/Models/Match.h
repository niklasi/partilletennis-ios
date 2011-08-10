//
//  Match.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"
#import "MatchResult.h"

@interface Match : NSObject <NSCopying>
{	
}

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *lanes;
@property (nonatomic) BOOL homeMatch;
@property (nonatomic, strong) Contact *contact;
@property (nonatomic, strong) MatchResult *result;
@end
