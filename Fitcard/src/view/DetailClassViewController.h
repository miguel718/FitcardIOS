//
//  DetailClassViewController.h
//  Fitcard
//
//  Created by BoHuang on 8/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNAActivityIndicator.h"
#import "DetailGymViewController.h"


@interface DetailClassViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgClass;
@property (weak, nonatomic) IBOutlet UIScrollView *scrClassDetail;
@property (weak, nonatomic) IBOutlet UIView *vwDetailClassContent;
@property (weak, nonatomic) IBOutlet UILabel *lblClassOpenHour;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIView *vwReview;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar1;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar2;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar3;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar4;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar5;
@property (weak, nonatomic) IBOutlet UILabel *lblReviews;
@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UIButton *btnBookClass;
@property (weak, nonatomic) IBOutlet UILabel *lblGymName;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UITextView *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblReviewField;

@property (strong, nonatomic)  UINavigationController *navController;

@property (strong, nonatomic)  DetailGymViewController *gymController;


@end
