//
//  PartilleTennisAppDelegate.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartilleTennisAppDelegate : UIResponder <UIApplicationDelegate, TeamDelegateProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) UINavigationController *matchesController;
@property (nonatomic, retain) UINavigationController *settingsController;
@property (nonatomic, strong) Team *myTeam;
@property (nonatomic, strong) NSArray *allTeams;
@end
