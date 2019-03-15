//
//  Globals.m
//  AdNote
//
//  Created by TwinkleStar on 12/3/15.
//  Copyright © 2015 TwinkleStar. All rights reserved.
//

#import "Globals.h"

//NSString *c_baseUrl = @"http://192.168.1.101:8088/service/";
//NSString *c_imageUrl = @"http://192.168.1.101:8088/";

NSString *c_baseUrl = @"http://demo.fitcard.fi/service/";
NSString *c_baseUrl1 = @"http://demo.fitcard.fi/";
NSString *c_imageUrl = @"http://demo.fitcard.fi/";

NSString *c_featuredUrl = @"serviceFeaturedGym";
NSString *c_gymlistUrl = @"serviceLoadGym";
NSString *c_searchGymUrl = @"serviceSearchGym";
NSString *c_searchClassUrl = @"searchClass";
NSString *c_loadReviewGym = @"serviceLoadReviewForGym";
NSString *c_loadReviewClass = @"serviceLoadReviewForClass";
NSString *c_loginUser = @"api/v1/consumer/api-login";
NSString *c_profileUser = @"api/v1/consumer/get-data";
NSString *c_registerUser = @"api/v1/consumer/register";
NSString *c_loadPlan = @"serviceLoadPlan";
NSString *c_chargeFund = @"api/v1/payment/create_charge/";
NSString *c_fundCheck = @"api/v1/payment/check_successful";
NSString *c_updateCredit = @"serviceAfterPayment";
NSString *c_uploadLogo = @"serviceUploadLogo";
NSString *c_uploadProfile = @"serviceUpdateProfile";
NSString *c_bookGym = @"serviceBookGym";
NSString *c_bookClass = @"serviceBookClass";
NSString *c_loadBooks = @"serviceLoadBooks";
NSString *c_lastVisitGym = @"serviceLastVisitGym";
NSString *c_lastVisitClass = @"serviceLastVisitClass";
NSString *c_cancelBookGym = @"serviceDeleteGym";
NSString *c_cancelBookClass = @"serviceDeleteClass";
NSString *c_loadOverReview = @"serviceLoadOverBooks";
NSString *c_reviewGym = @"serviceReviewGym";
NSString *c_reviewClass = @"serviceReviewClass";
NSString *c_couponCode = @"serviceCouponCode";
NSString *c_contactUs = @"serviceContactUs";
NSString *c_forgetCode = @"serviceGetCode";
NSString *c_resetPassword = @"serviceUpdatePassword";
NSString *c_cleanCard = @"serviceCleanCard";
NSString *c_chargeToken	 = @"api/v1/payment/pay_with_token";

NSString *mUpcomingDate;

NSString *mLastVisitGym;
NSString *gymId = @"-1";



NSArray *c_startHoursField;
NSArray *c_endHoursField;
NSArray *c_closeField;
NSArray *c_days;

NSMutableArray *lstCitys;
NSMutableArray *lstLocations;
NSMutableArray *lstAmenity;
NSMutableArray *lstActivity;
NSMutableArray *lstStudio;
NSMutableArray *lstClasses;
NSMutableArray *lstCategory;
NSMutableArray *lstReview;

GymModel *currentGym;
ClassModel *currentClass;

UserModel *mAccount;

//CLLocationManager *locationManager;
CLLocation *currentLocation;


NSMutableArray *lstFeaturedGym;
NSMutableArray *lstPlans;
NSMutableArray *lstGyms;


int isLogin = 0;
int currentPlan;
int mBookClass;



@implementation Globals

NSMutableArray *lstNotes;

+(Globals*)sharedInstance{
    static dispatch_once_t onceToken;
    static Globals* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Globals alloc] init];
    });
    return instance;
}
+(NSString *) getCurrentDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *result = [dateFormatter stringFromDate:[NSDate date]];
    return result;
}
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(void) showErrorDialog:(NSString *)msg
{
    UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:msg message:@""delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [errDlg show];
}
+ (void)addActivityIndicator :(WNAActivityIndicator*) activityIndicator :(UIView *) parentView
{
    if (activityIndicator == nil) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        activityIndicator = [[WNAActivityIndicator alloc] initWithFrame:screenRect];
        [activityIndicator setHidden:NO];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (![activityIndicator isDescendantOfView:parentView]) {
        [parentView addSubview:activityIndicator];
    }
}

+ (void)removeActivityIndicator :(WNAActivityIndicator*) activityIndicator :(UIView *) parentView
{
    [activityIndicator setHidden:YES];
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
+(void) saveUserInfo
{
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    [preference setObject:mAccount.mId forKey:@"id"];
    [preference setObject:mAccount.mName forKey:@"name"];
    if (![mAccount.mImage isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mImage forKey:@"image"];
    if (![mAccount.mAddress isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mAddress forKey:@"address"];
    if (![mAccount.mPhone isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mPhone forKey:@"phone"];
    if (![mAccount.mCity isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mCity forKey:@"city"];
    if (![mAccount.mCredit isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mCredit forKey:@"credit"];
    if (![mAccount.mPlan isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mPlan forKey:@"plan"];
    [preference setObject:mAccount.mEmail forKey:@"email"];
    if (![mAccount.mInvoiceEnd isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mInvoiceEnd forKey:@"invoiceend"];
    if (![mAccount.mInvoiceStart isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mInvoiceStart forKey:@"invoicestart"];
    [preference setObject:mAccount.mToken forKey:@"token"];
    if (![mAccount.mHasToken isKindOfClass:[NSNull class]])
        [preference setObject:mAccount.mHasToken forKey:@"hasToken"];
    
    [preference synchronize];
}
+(void) setRatingView:(double) rating:(UIImageView *) star1:(UIImageView*) star2:(UIImageView *) star3:(UIImageView *) star4:(UIImageView *) star5
{
    if (rating >= 4.5)
    {
        star1.image = [UIImage imageNamed:@"big_star_active.png"];
        star2.image = [UIImage imageNamed:@"big_star_active.png"];
        star3.image = [UIImage imageNamed:@"big_star_active.png"];
        star4.image = [UIImage imageNamed:@"big_star_active.png"];
        star5.image = [UIImage imageNamed:@"big_star_active.png"];
    }
    else if (rating >= 3.5)
    {
        star1.image = [UIImage imageNamed:@"big_star_active.png"];
        star2.image = [UIImage imageNamed:@"big_star_active.png"];
        star3.image = [UIImage imageNamed:@"big_star_active.png"];
        star4.image = [UIImage imageNamed:@"big_star_active.png"];
        star5.image = [UIImage imageNamed:@"big_star_normal.png"];
    }
    else if (rating >= 2.5)
    {
        star1.image = [UIImage imageNamed:@"big_star_active.png"];
        star2.image = [UIImage imageNamed:@"big_star_active.png"];
        star3.image = [UIImage imageNamed:@"big_star_active.png"];
        star4.image = [UIImage imageNamed:@"big_star_normal.png"];
        star5.image = [UIImage imageNamed:@"big_star_normal.png"];
    }
    else if (rating >= 1.5)
    {
        star1.image = [UIImage imageNamed:@"big_star_active.png"];
        star2.image = [UIImage imageNamed:@"big_star_active.png"];
        star3.image = [UIImage imageNamed:@"big_star_normal.png"];
        star4.image = [UIImage imageNamed:@"big_star_normal.png"];
        star5.image = [UIImage imageNamed:@"big_star_normal.png"];
    }
    else if (rating >= 0.5)
    {
        star1.image = [UIImage imageNamed:@"big_star_active.png"];
        star2.image = [UIImage imageNamed:@"big_star_normal.png"];
        star3.image = [UIImage imageNamed:@"big_star_normal.png"];
        star4.image = [UIImage imageNamed:@"big_star_normal.png"];
        star5.image = [UIImage imageNamed:@"big_star_normal.png"];
    }
    else
    {
        star1.image = [UIImage imageNamed:@"big_star_normal.png"];
        star2.image = [UIImage imageNamed:@"big_star_normal.png"];
        star3.image = [UIImage imageNamed:@"big_star_normal.png"];
        star4.image = [UIImage imageNamed:@"big_star_normal.png"];
        star5.image = [UIImage imageNamed:@"big_star_normal.png"];
    }
}
@end
