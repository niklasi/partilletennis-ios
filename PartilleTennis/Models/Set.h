//
//  SetResult.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Set : NSObject <NSCoding>

@property (nonatomic) int myTeam;
@property (nonatomic) int	opponent;

-(id)initWithSets:(int)myTeam opponent:(int)opponent;
-(NSString *)asText;
@end
