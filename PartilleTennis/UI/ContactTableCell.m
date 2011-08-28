//
//  ContactTableCell.m
//  PartilleTennis
//
//  Created by Niklas Ingholt on 2011-08-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactTableCell.h"

@interface ContactTableCell() {
}
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation ContactTableCell
@synthesize nameLabel = _nameLabel, phoneNumberLabel = _phoneNumberLabel, emailLabel = _emailLabel, contact = _contact;

-(void)setContact:(Contact *)value
{
	_contact = value;
	self.nameLabel.text = value.name;
	self.phoneNumberLabel.text = value.phone;
	self.emailLabel.text = value.email;
}

@end
