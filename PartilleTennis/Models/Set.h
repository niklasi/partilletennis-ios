//
//  SetResult.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Set : NSObject <NSCoding>

@property (nonatomic) NSInteger myTeam;
@property (nonatomic) NSInteger	opponent;

-(id)initWithSets:(NSInteger)myTeam opponent:(NSInteger)opponent;
-(NSString *)asText;
@end
