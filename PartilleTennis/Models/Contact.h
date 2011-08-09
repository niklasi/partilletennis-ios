//
//  Opponent.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
{
	NSString *name;
	NSString *phone;
	NSString *email;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@end
