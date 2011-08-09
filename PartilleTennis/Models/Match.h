//
//  Match.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface Match : NSObject
{	
}

@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *lanes;
@property (nonatomic) BOOL homeMatch;
@property (nonatomic, retain) Contact *contact;
@end
