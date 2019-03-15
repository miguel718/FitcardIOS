//
//  ProfileViewController.h
//  Fitcard
//
//  Created by BoHuang on 8/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNAActivityIndicator.h"

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblCredits;
@property (weak, nonatomic) IBOutlet UITextField *editName;
@property (weak, nonatomic) IBOutlet UITextField *editEmail;
@property (weak, nonatomic) IBOutlet UITextField *editPhone;
@property (weak, nonatomic) IBOutlet UITextField *editAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateProfile;
@property (weak, nonatomic) IBOutlet UITextField *editCity;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIView *vwImage;

@property (weak, nonatomic) IBOutlet UIButton *btnCleanCard;

@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;
@end
