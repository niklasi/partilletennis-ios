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
#import "TeamPickerController.h"

@interface PartilleTennisAppDelegate() {
}

-(void)teamPickerDidFinnish:(TeamPickerController *)teamPickerController;
@end

@implementation PartilleTennisAppDelegate

@synthesize window = _window, navController, matchesController, settingsController, myTeam, allTeams;

-(id)init
{
	self.myTeam = [NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(@"myTeam")];
	return [super init];
}

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
	seriesTableItem.image = [UIImage imageNamed:@"table-series.png"]; 
	UITabBarItem *matchesItem = [tabBarController.tabBar.items objectAtIndex:1];
	matchesItem.image = [UIImage imageNamed:@"matches.png"]; 
	UITabBarItem *settingsItem = [tabBarController.tabBar.items objectAtIndex:2];
	settingsItem.image = [UIImage imageNamed:@"settings.png"]; 
  [_window setRootViewController:tabBarController];
		
	// Add the navigation controller's view to the window and display.
	[_window addSubview:tabBarController.view];
	[self.window makeKeyAndVisible];
	
	if (self.myTeam == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Välj lag" message:@"Du måste välja vilket lag du tillhör." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];

		TeamPickerController *picker = [[TeamPickerController alloc] initWithNibName:@"TeamPickerView" bundle:nil];

		picker.navigationItem.title = @"Välj ditt lag";
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																																							target:self 
																																							action:@selector(teamPickerDidFinnish:)];
		picker.navigationItem.rightBarButtonItem = doneButton;

		UINavigationController *tmp = [[UINavigationController alloc] initWithRootViewController:picker];
		tmp.navigationBar.barStyle = UIBarStyleBlackOpaque;

		[tabBarController presentViewController:tmp animated:NO completion:nil];
	}
	
	return YES;
}

-(void)teamPickerDidFinnish:(TeamPickerController *)teamPickerController
{
	[self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
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
	NSLog(@"Background...");
	[self save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@"Enter foreground...");
	self.myTeam = [NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(@"myTeam")];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"Terminate...");
	[self save];
}

-(void)save
{
	[NSKeyedArchiver archiveRootObject:self.myTeam toFile:pathInDocumentDirectory(@"myTeam")];
	UIViewController *controller = [self.matchesController.viewControllers objectAtIndex:0];; 
		
	if ([controller conformsToProtocol:@protocol(SaveProtocol)]) {
		NSLog(@"Sparar..");
		id<SaveProtocol> tmp = (id <SaveProtocol>)controller;
		[tmp save];
	}
	
	[NSKeyedArchiver archiveRootObject:self.myTeam toFile:pathInDocumentDirectory(@"myTeam")];
	self.myTeam = nil;
	self.allTeams = nil;
}

@end
