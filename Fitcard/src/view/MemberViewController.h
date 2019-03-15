//
//  MemberViewController.h
//  Fitcard
//
//  Created by BoHuang on 7/28/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNAActivityIndicator.h"

@interface MemberViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UITextField *editCouponCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanName1;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanPrice1;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanCredits1;
@property (weak, nonatomic) IBOutlet UIButton *btnPlanSelect1;
@property (weak, nonatomic) IBOutlet UIView *vwPlan1;
@property (weak, nonatomic) IBOutlet UIView *vwPlan2;
@property (weak, nonatomic) IBOutlet UIView *vwPlan3;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanName2;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanPrice2;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanCredit2;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanName3;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanPrice3;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanCredit3;
@property (weak, nonatomic) IBOutlet UIButton *btnPlanSelect3;
@property (weak, nonatomic) IBOutlet UIButton *btnPlanSelect2;


@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;

@end
