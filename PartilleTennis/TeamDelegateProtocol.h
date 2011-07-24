//
//  TeamDelegateProtocol.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TeamDelegateProtocol <NSObject>

-(Team *) myTeam;
-(void) setMyTeam:(Team *)value;

@end
