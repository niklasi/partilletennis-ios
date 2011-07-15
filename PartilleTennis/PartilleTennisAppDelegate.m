//
//  PartilleTennisAppDelegate.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PartilleTennisAppDelegate.h"
#import "SeriesController.h"
#import "MatchesController.h"
#import "SettingsController.h"

@implementation PartilleTennisAppDelegate

@synthesize window = _window, navController, matchesController, settingsController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	UIViewController *seriesController = [[SeriesController alloc] init];
	self.navController = [[UINavigationController alloc] initWithRootViewController:seriesController];
	self.navController.navigationBar.barStyle = UIBarStyleBlackOpaque;

	self.matchesController = [[UINavigationController	alloc] initWithRootViewController:
														[[MatchesController alloc] init]];
	self.matchesController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	self.settingsController = [[UINavigationController alloc] initWithRootViewController:
																														[[SettingsController alloc] init]];
	self.settingsController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	NSArray *viewControllers = [NSArray arrayWithObjects:self.navController, self.matchesController, self.settingsController, nil];
	
	[tabBarController setViewControllers:viewControllers];
	UITabBarItem *seriesTableItem = [tabBarController.tabBar.items objectAtIndex:0];
	seriesTableItem.image = [UIImage imageNamed:@"104-index-cards.png"]; 
	UITabBarItem *matchesItem = [tabBarController.tabBar.items objectAtIndex:1];
	matchesItem.image = [UIImage imageNamed:@"83-calendar.png"]; 
	UITabBarItem *settingsItem = [tabBarController.tabBar.items objectAtIndex:2];
	settingsItem.image = [UIImage imageNamed:@"19-gear.png"]; 
  [_window setRootViewController:tabBarController];
	
	// Add the navigation controller's view to the window and display.
	[_window addSubview:tabBarController.view];

	
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

@end
