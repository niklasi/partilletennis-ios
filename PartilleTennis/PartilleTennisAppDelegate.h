//
//  PartilleTennisAppDelegate.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartilleTennisAppDelegate : UIResponder <UIApplicationDelegate, TeamDelegateProtocol, SaveProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) UINavigationController *matchesController;
@property (nonatomic, strong) UINavigationController *settingsController;
@property (nonatomic, strong) Team *myTeam;
@property (nonatomic, strong) NSArray *allTeams;
@end
