//
//  ChargeViewController.h
//  Fitcard
//
//  Created by BoHuang on 7/28/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"
#import "WNAActivityIndicator.h"

@interface ChargeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnChargeBack;
@property (weak, nonatomic) IBOutlet UITextField *editCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *editMonth;
@property (weak, nonatomic) IBOutlet UITextField *editYear;
@property (weak, nonatomic) IBOutlet UITextField *editCvv;
@property (weak, nonatomic) IBOutlet UITextField *editAmount;
@property (weak, nonatomic) IBOutlet UIButton *editPay;

@property (strong, nonatomic)  DownPicker *pickerMonth;
@property (strong, nonatomic)  DownPicker *pickerYear;


@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;

@property (strong, nonatomic)  UINavigationController *navController;


@end
