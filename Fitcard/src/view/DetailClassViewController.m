//
//  DetailClassViewController.m
//  Fitcard
//
//  Created by BoHuang on 8/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "DetailClassViewController.h"
#import "Globals.h"
#import "AFNetworking.h"
#import "ReviewModel.h"
#import "MemberViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailClassViewController ()

@end

@implementation DetailClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.btnBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBookClass addTarget:self action:@selector(actionBookClass) forControlEvents:UIControlEventTouchUpInside];
    [self setData];
    [self serviceLoadReview:currentClass.mId];
    self.lblDescription.editable = NO;
    [self.lblDescription resignFirstResponder];
    self.vwReview.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) setData
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDay = [components weekday] - 1;
    
    self.lblClassName.text = currentClass.mName;
    self.lblGymName.text = currentClass.mGymName;
    self.lblLocation.text = currentClass.mCity;
    NSString *imgUrl = [c_imageUrl stringByAppendingString:currentClass.mImage];
    //NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgUrl]];
    //self.imgClass.image= [UIImage imageWithData: imageData];
    [self.imgClass sd_setImageWithURL:[NSURL URLWithString:imgUrl]
              placeholderImage:[UIImage imageNamed:@""]];
    NSRange range = NSMakeRange(0, 5);
    NSString *startHour = @"";
    if (currentClass.mStartHour.length > 5)
        startHour =[currentClass.mStartHour substringWithRange:range];
    NSString *endHour  = @"";
    if (currentClass.mEndHour.length > 5)
        endHour = [currentClass.mEndHour substringWithRange:range];
    NSString *openHour = [[startHour stringByAppendingString:@"-"] stringByAppendingString: endHour];
    self.lblClassOpenHour.text = openHour;
    self.lblDescription.text = currentClass.mDescription;
    if ([currentClass.mCategory isKindOfClass:[NSNull class]])
        self.lblCategory.text = @"";
    else self.lblCategory.text = currentClass.mCategory;
    self.lblAddress.text = [[currentClass.mCity stringByAppendingString:@" "] stringByAppendingString:currentClass.mAddress];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM"];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateClass = [dateFormatter1 dateFromString:currentClass.mDate];
    NSString* hours = [[[dateFormatter stringFromDate:dateClass] stringByAppendingString:@" "] stringByAppendingString:openHour];
    self.lblDate.text = hours;
    
}
-(void) closeScreen
{
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (self.gymController != nil)
         {
             [self.gymController loadClass];
         }
         
     }];
    
}
-(void) buyCredit
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (self.navController != nil)
         {
             MemberViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberViewController"];
             [self.navController pushViewController:viewController animated:YES];
         }
         
     }];
}
-(void) actionBookClass
{
    NSNumber *credit = (NSNumber *)(mAccount.mCredit);
    if ([credit longLongValue] > 0)
    {
        [self serviceBookClass];
    }
    else
    {
        UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", @"") message:NSLocalizedString(@"buyCredit", @"")delegate:self cancelButtonTitle:NSLocalizedString(@"closebutton", @"") otherButtonTitles:NSLocalizedString(@"goMember", @""), nil];
        [errDlg show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
            NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
            
            NSArray *objectsToShare = @[textToShare, myWebsite];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                           UIActivityTypePrint,
                                           UIActivityTypeAssignToContact,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList,
                                           UIActivityTypePostToFlickr,
                                           UIActivityTypePostToVimeo];
            
            activityVC.excludedActivityTypes = excludeActivities;
            
            [self presentViewController:activityVC animated:YES completion:nil];
        }
        return;
    }
    if (buttonIndex == 1){
        [self buyCredit];
    }
}
-(void) serviceBookClass
{
    NSString *serverurl = [[[[[c_baseUrl stringByAppendingString:c_bookClass] stringByAppendingString:@"/" ] stringByAppendingString:[(NSNumber*)(mAccount.mId) stringValue]] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)(currentClass.mId) stringValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSString* result = [receivedData objectForKey:@"result"];
         if ([result longLongValue] == 1)
         {
             [self setBookButtonName];
         }
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) setBookButtonName
{
    long credit = [mAccount.mCredit longLongValue] - 1;
    mAccount.mCredit  = [NSString stringWithFormat:@"%ld", credit];
    [Globals saveUserInfo];
    [self.btnBookClass setTitle:NSLocalizedString(@"booked", @"") forState:UIControlStateNormal];
    [self.btnBookClass addTarget:NULL action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.btnBookClass setEnabled:false];
    UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"success", @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"closebutton", @"") otherButtonTitles:NSLocalizedString(@"shareFacebook", @""), nil];
    errDlg.tag = 1;
    UITextField* myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    [errDlg addSubview:myTextField];
    [errDlg show];
    
}
-(void) serviceLoadReview:(NSNumber*) gid
{
    NSString *serverurl = [[[ c_baseUrl stringByAppendingString:c_loadReviewClass] stringByAppendingString:@"/"] stringByAppendingString:[gid stringValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSArray *reviewArray = [receivedData objectForKey:@"reviews"];
         lstReview = [[NSMutableArray alloc] init];
         for (int i = 0;i < reviewArray.count;i++)
         {
             NSDictionary *reviewObject = [reviewArray objectAtIndex:i];
             NSDictionary *consumerObject = [reviewObject objectForKey:@"consumer"];
             ReviewModel *rModel = [[ReviewModel alloc] init];
             rModel.mName = [consumerObject objectForKey:@"name"];
             rModel.mRating = [reviewObject objectForKey:@"star"];
             rModel.mImage = [consumerObject objectForKey:@"image"];
             rModel.mDate = [reviewObject objectForKey:@"date"];
             rModel.mContent = [reviewObject objectForKey:@"description"];
             [lstReview addObject:rModel];
             
         }
         [self addReview];
         if (isLogin == 1)
         {
             [self serviceLastVisitClass];
         }
         if ([currentClass.mAvailable longLongValue] > 0)
         {
             [self.btnBookClass setTitle:NSLocalizedString(@"book", @"") forState:UIControlStateNormal];
             [self.btnBookClass setEnabled:true];
         }
         else
         {
             [self.btnBookClass	 setTitle:NSLocalizedString(@"full", @"") forState:UIControlStateNormal];
             [self.btnBookClass setEnabled:false];
         }
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) serviceLastVisitClass
{
    NSString *serverurl = [[[[[c_baseUrl stringByAppendingString:c_lastVisitClass] stringByAppendingString:@"/" ] stringByAppendingString:[(NSNumber*)(mAccount.mId) stringValue]] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)(currentClass.mId) stringValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         mBookClass = 0;
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSString* bb= [receivedData objectForKey:@"book"];
         mBookClass = [bb longLongValue];
         [self afterLastVisit];
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) afterLastVisit
{
    if (mBookClass > 0)
    {
        [self.btnBookClass setTitle:NSLocalizedString(@"booked", @"") forState:UIControlStateNormal];
        [self.btnBookClass addTarget:NULL action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.btnBookClass setEnabled:false];
    }
    else
    {
        if ([currentClass.mAvailable longLongValue] > 0)
        {
            [self.btnBookClass setTitle:NSLocalizedString(@"book", @"") forState:UIControlStateNormal];
            [self.btnBookClass addTarget:self action:@selector(actionBookClass) forControlEvents:UIControlEventTouchUpInside];
            [self.btnBookClass setEnabled:true];
        }
        else
        {
            [self.btnBookClass	 setTitle:NSLocalizedString(@"full", @"") forState:UIControlStateNormal];
            [self.btnBookClass addTarget:NULL action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.btnBookClass setEnabled:false];
        }
    }
}
-(void) addReview
{
    int rating = 0;
    for (int i = 0;i  < lstReview.count;i++)
    {
        //[self addReviewItem:[lstReview objectAtIndex:i] :80 * i];
        ReviewModel *model = [lstReview objectAtIndex:i];
        rating = rating + [model.mRating intValue];
    }
    if (lstReview.count == 0)
        self.lblReviewField.hidden = true;
    else self.lblReviewField.hidden = false;
    if (rating > 0)
    {
        rating = rating / lstReview.count;
    }
    
    [Globals setRatingView:rating :self.imgStar1 :self.imgStar2 :self.imgStar3 :self.imgStar4 :self.imgStar5];
    NSString *reviews = [[[@"(" stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)lstReview.count]] stringByAppendingString:@") "] stringByAppendingString:NSLocalizedString(@"reviews", @"")];
    [self.lblReviews setText:reviews];
    //double height = 365 + 80 * lstReview.count;
    //[self.scrClassDetail setContentSize:CGSizeMake(self.scrClassDetail.contentSize.width, height)];
}
-(void) addReviewItem:(ReviewModel *) model :(double) top
{
    double width = self.view.bounds.size.width;
    UIView *reviewView = [[UIView alloc] initWithFrame:CGRectMake(8,top + 30, width - 35, 80)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = reviewView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[Globals colorWithHexString:@"E7E7E7"] CGColor], nil];
    [reviewView.layer insertSublayer:gradient atIndex:0];
    reviewView.layer.cornerRadius = 10;
    
    UILabel *lblConsumer = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 150, 20)];
    lblConsumer.text = model.mName;
    lblConsumer.textColor = [Globals colorWithHexString:@"2798c6"];
    
    UITextView *lblDescription = [[UITextView alloc] initWithFrame:CGRectMake(5, 30, width - 130, 40)];
    [lblDescription setBackgroundColor:[UIColor clearColor]];
    lblDescription.text = model.mContent;
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(width-147, 52, 100, 20)];
    lblDate.text = model.mDate;
    [lblDate setFont:[UIFont systemFontOfSize:13]];
    lblDate.textAlignment = NSTextAlignmentRight;
    
    UIImageView *imgStar1 = [[UIImageView alloc] initWithFrame:CGRectMake(width-38 - 16 * 5 - 3 * 4, 8, 16, 15)];
    UIImageView *imgStar2 = [[UIImageView alloc] initWithFrame:CGRectMake(width-38 - 16 * 4 - 3 * 3, 8, 16, 15)];
    UIImageView *imgStar3 = [[UIImageView alloc] initWithFrame:CGRectMake(width-38 - 16 * 3 - 3 * 2, 8, 16, 15)];
    UIImageView *imgStar4 = [[UIImageView alloc] initWithFrame:CGRectMake(width-38 - 16 * 2 - 3 * 1, 8, 16, 15)];
    UIImageView *imgStar5 = [[UIImageView alloc] initWithFrame:CGRectMake(width-38 - 16 * 1 - 3 * 0, 8, 16, 15)];
    
    [Globals setRatingView:[model.mRating doubleValue] :imgStar1 :imgStar2 :imgStar3 :imgStar4 :imgStar5];
    [reviewView addSubview:imgStar1];
    [reviewView addSubview:imgStar2];
    [reviewView addSubview:imgStar3];
    [reviewView addSubview:imgStar4];
    [reviewView addSubview:imgStar5];
    [reviewView addSubview:lblConsumer];
    [reviewView addSubview:lblDate];
    [reviewView addSubview:lblDescription];
    [self.vwReview addSubview:reviewView];
}
- (void)addActivityIndicator
{
    if (self.activityIndicator == nil) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.activityIndicator = [[WNAActivityIndicator alloc] initWithFrame:screenRect];
        [self.activityIndicator setHidden:NO];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (![self.activityIndicator isDescendantOfView:self.view]) {
        [self.view addSubview:self.activityIndicator];
        
        
    }
}@end
