//
//  DetailGymViewController.h
//  Fitcard
//
//  Created by BoHuang on 8/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNAActivityIndicator.h"

@interface DetailGymViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIScrollView *scrDetailGym;
@property (weak, nonatomic) IBOutlet UIView *vwDetailGymContent;
@property (weak, nonatomic) IBOutlet UILabel *lblOpenHourGym;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationGym;
@property (weak, nonatomic) IBOutlet UIView *vwDetailGymInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnVisitGym;
@property (weak, nonatomic) IBOutlet UILabel *lblGymName;
@property (weak, nonatomic) IBOutlet UITextView *txtGymDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgDetailGymStar1;
@property (weak, nonatomic) IBOutlet UIImageView *imgDetailGymStar2;
@property (weak, nonatomic) IBOutlet UIImageView *imgDetailGymStar3;
@property (weak, nonatomic) IBOutlet UIImageView *imgDetailGymStar4;
@property (weak, nonatomic) IBOutlet UIImageView *imgDetailGymStar5;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailGymReview;
@property (weak, nonatomic) IBOutlet UIView *vwReviewContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgDetailGym;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnUpcoming;

@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightView;
@property (weak, nonatomic) IBOutlet UILabel *lblUpcoming;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightDetailView;
@property (weak, nonatomic) IBOutlet UILabel *lblClasses;

@property (strong, nonatomic)  UINavigationController *navController;
@property (weak, nonatomic) IBOutlet UIButton *btnDateBack;
@property (weak, nonatomic) IBOutlet UILabel *lblDate1;
@property (weak, nonatomic) IBOutlet UIButton *btnDate1;
@property (weak, nonatomic) IBOutlet UILabel *lblDate2;
@property (weak, nonatomic) IBOutlet UIButton *btnDate2;
@property (weak, nonatomic) IBOutlet UILabel *lblDate3;
@property (weak, nonatomic) IBOutlet UIButton *btnDate3;
@property (weak, nonatomic) IBOutlet UILabel *lblDate4;
@property (weak, nonatomic) IBOutlet UIButton *btnDate4;
@property (weak, nonatomic) IBOutlet UILabel *lblDate5;
@property (weak, nonatomic) IBOutlet UIButton *btnDate5;
@property (weak, nonatomic) IBOutlet UILabel *lblDate6;
@property (weak, nonatomic) IBOutlet UIButton *btnDate6;
@property (weak, nonatomic) IBOutlet UILabel *lblDate7;
@property (weak, nonatomic) IBOutlet UIButton *btnDate7;
@property (weak, nonatomic) IBOutlet UIButton *btnDateNext;

-(void) loadClass;

@end
