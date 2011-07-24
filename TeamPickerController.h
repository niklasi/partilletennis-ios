//
//  TeamPickerController.h
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamPickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *TeamPicker;
}


@property (strong, nonatomic) IBOutlet UIPickerView *TeamPicker;
@end
