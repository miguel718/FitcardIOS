//
//  ForgetViewController.h
//  Fitcard
//
//  Created by BoHuang on 8/9/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *editEmail;
@property (weak, nonatomic) IBOutlet UITextField *editCode;
@property (weak, nonatomic) IBOutlet UITextField *editPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnResetPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSetPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIView *vwPassword;

@end
