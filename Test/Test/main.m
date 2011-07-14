//
//  main.m
//  Test
//
//  Created by Niklas Ingholt on 2011-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TestAppDelegate.h"

int main(int argc, char *argv[])
{
	int retVal = 0;
	@autoreleasepool {
	    retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([TestAppDelegate class]));
	}
	return retVal;
}
