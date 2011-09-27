//
//  NewMatchTimeController.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-09-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

@interface NewMatchTimeController : UIViewController

@property (nonatomic, strong) Match *match;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *timePickerSegment;

@end
