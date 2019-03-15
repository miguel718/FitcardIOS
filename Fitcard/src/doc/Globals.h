//
//  Globals.h
//  AdNote
//
//  Created by TwinkleStar on 12/3/15.
//  Copyright © 2015 TwinkleStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WNAActivityIndicator.h"
#import "UserModel.h"
#import "GymModel.h"
#import "ClassModel.h"
#import <CoreLocation/CoreLocation.h>


extern NSString *c_baseUrl;
extern NSString *c_imageUrl;
extern NSString *c_baseUrl1;

extern NSString *c_featuredUrl;
extern NSString *c_gymlistUrl;
extern NSString *c_searchGymUrl;
extern NSString *c_searchClassUrl;
extern NSString *c_loadReviewGym;
extern NSString *c_loadReviewClass;
extern NSString *c_loginUser;
extern NSString *c_registerUser;
extern NSString *c_profileUser;
extern NSString *c_loadPlan;
extern NSString *c_chargeFund;
extern NSString *c_fundCheck;
extern NSString *c_updateCredit;
extern NSString *c_uploadLogo;
extern NSString *c_uploadProfile;
extern NSString *c_bookGym;
extern NSString *c_bookClass;
extern NSString *c_loadBooks;
extern NSString *c_lastVisitGym;
extern NSString *c_lastVisitClass;
extern NSString *c_cancelBookGym;
extern NSString *c_cancelBookClass;
extern NSString *c_loadOverReview;
extern NSString *c_reviewGym;
extern NSString *c_reviewClass;
extern NSString *c_couponCode;
extern NSString *c_contactUs;
extern NSString *c_forgetCode;
extern NSString *c_resetPassword;

extern NSArray *c_startHoursField;
extern NSArray *c_endHoursField;
extern NSArray *c_closeField;
extern NSArray *c_days;
extern NSString *c_cleanCard;
extern NSString *c_chargeToken;

extern NSMutableArray *lstFeaturedGym;
extern NSMutableArray *lstPlans;
extern NSMutableArray *lstGyms;
extern NSMutableArray *lstClasses;

extern NSMutableArray *lstCitys;
extern NSMutableArray *lstLocations;
extern NSMutableArray *lstAmenity;
extern NSMutableArray *lstActivity;
extern NSMutableArray *lstStudio;
extern NSMutableArray *lstCategory;
extern NSMutableArray *lstReview;

extern NSString *gymId;


extern UserModel *mAccount;
extern GymModel *currentGym;
extern ClassModel *currentClass;

extern int isLogin;
extern int currentPlan;
extern int mBookClass;

extern NSString *mUpcomingDate;
extern NSString *mLastVisitGym;

//extern CLLocationManager *locationManager;
extern CLLocation *currentLocation;


@interface Globals : NSObject

+(Globals *) sharedInstance;
+(void) saveUserInfo;
+(NSString *) getCurrentDateTime;
+(UIColor*)colorWithHexString:(NSString*)hex;
+ (UIImage *)imageWithColor:(UIColor *)color ;
+(void) showErrorDialog:(NSString *)msg;
+ (void)removeActivityIndicator :(WNAActivityIndicator*) activityIndicator :(UIView *) parentView;
+ (void)addActivityIndicator :(WNAActivityIndicator*) activityIndicator :(UIView *) parentView;
+(void) setRatingView:(double) rating:(UIImageView *) star1:(UIImageView*) star2:(UIImageView *) star3:(UIImageView *) star4:(UIImageView *) star5;
@end
