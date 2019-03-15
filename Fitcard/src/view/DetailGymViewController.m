//
//  DetailGymViewController.m
//  Fitcard
//
//  Created by BoHuang on 8/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "DetailGymViewController.h"
#import "Globals.h"
#import "AFNetworking.h"
#import "ReviewModel.h"
#import "MemberViewController.h"
#import "ClassListViewController.h"
#import "DetailClassViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailGymViewController ()

@end

@implementation DetailGymViewController
NSString *mVisitAmount;
NSString *mVisitCode;
NSMutableArray *classGymDates;
NSMutableArray *classGymLabels;
NSString *currentGymDate;
NSString *searchGymDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    classGymDates = [[NSMutableArray alloc] init];
    classGymLabels = [[NSMutableArray alloc] init];
    self.lblUpcoming.hidden = YES;
    self.btnUpcoming.hidden = YES;
    self.lblClasses.text = NSLocalizedString(@"classes1", @"");
    
    [classGymDates addObject:self.btnDate1];
    [classGymDates addObject:self.btnDate2];
    [classGymDates addObject:self.btnDate3];
    [classGymDates addObject:self.btnDate4];
    [classGymDates addObject:self.btnDate5];
    [classGymDates addObject:self.btnDate6];
    [classGymDates addObject:self.btnDate7];
    
    [classGymLabels addObject:self.lblDate1];
    [classGymLabels addObject:self.lblDate2];
    [classGymLabels addObject:self.lblDate3];
    [classGymLabels addObject:self.lblDate4];
    [classGymLabels addObject:self.lblDate5];
    [classGymLabels addObject:self.lblDate6];
    [classGymLabels addObject:self.lblDate7];

    // Do any additional setup after loading the view.
    
    [self.btnDateBack addTarget:self action:@selector(backDate) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDateNext addTarget:self action:@selector(nextDate) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.btnBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.btnVisitGym addTarget:self action:@selector(actionVisitGym) forControlEvents:UIControlEventTouchUpInside];
    self.txtGymDescription.editable = NO;
    [self.txtGymDescription resignFirstResponder];
    self.txtGymDescription.scrollEnabled = NO;
    
    [self setData];
    if ([self isCloseGym])
    {
        [self.btnVisitGym setTitle:NSLocalizedString(@"close", @"") forState:UIControlStateNormal];
        //[self.btnVisitGym setBounds:CGRectMake(self.btnVisitGym.bounds.origin.x, self.view.bounds.size.width - 100, 78, self.btnVisitGym.bounds.size.height)];
        [self.btnVisitGym setEnabled:false];
    }
    else
    {
        [self.btnVisitGym setTitle:NSLocalizedString(@"visit", @"") forState:UIControlStateNormal];
        //[self.btnVisitGym setBounds:CGRectMake(self.btnVisitGym.bounds.origin.x, self.view.bounds.size.width - 100, 78, self.btnVisitGym.bounds.size.height)];
        [self.btnVisitGym setEnabled:true];
    }
    [self serviceLoadReview:currentGym.mId];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //Optionally for time zone conversions
    currentGymDate = [formatter stringFromDate:[NSDate date]];
    
    [self updateCalendar];
    self.btnDate1.tag = 0;
    [self clickDate:self.btnDate1];
    [self loadClass];
    
    
}
-(void) backDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormat dateFromString:currentGymDate];
    NSDate *iDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
    currentGymDate = [dateFormat stringFromDate:iDaysAgo];
    searchGymDate = currentGymDate;
    [self updateCalendar];
    [self loadClass];
    [self selectFirstDate];
}
-(void) nextDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormat dateFromString:currentGymDate];
    NSDate *iDaysAgo = [now dateByAddingTimeInterval:+7*24*60*60];
    currentGymDate = [dateFormat stringFromDate:iDaysAgo];
    searchGymDate = currentGymDate;
    [self updateCalendar];
    [self loadClass];
    [self selectFirstDate];
}
-(void) clickDate:(id) sender
{
    NSInteger tag = [sender tag];
    for (int i = 0;i < 7;i++)
    {
        UIButton *dateButton = (UIButton*)[classGymDates objectAtIndex:i];
        dateButton.layer.borderWidth = 0;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormat dateFromString:currentGymDate];
    NSDate *iDaysAgo = [now dateByAddingTimeInterval:+tag*24*60*60];
    
    
    UIButton *selectDate = (UIButton*)[classGymDates objectAtIndex: tag];
    selectDate.layer.borderWidth = 1;
    selectDate.layer.cornerRadius = 12;
    selectDate.layer.borderColor = [[Globals colorWithHexString:@"45A99D"] CGColor];
    searchGymDate = [dateFormat stringFromDate:iDaysAgo];
    [self loadClass];
}
-(void) loadClass
{
    NSString *request = [[[searchGymDate stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)currentGym.mId stringValue]] stringByAppendingString:@"/"];
    request = [request stringByAppendingString:@"-1"];
    request = [[request stringByAppendingString:@"/" ] stringByAppendingString:@"-1"];
    request = [[request stringByAppendingString:@"/" ] stringByAppendingString:@"-1"];
    [self serviceSearchClass:request];
}
-(void) serviceSearchClass:(NSString *) request
{
    NSString *serverurl = [[[ c_baseUrl stringByAppendingString:c_searchClassUrl] stringByAppendingString:@"/"] stringByAppendingString:request];
    if (isLogin == 1)
    {
        serverurl  = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)mAccount.mId stringValue]];
    }
    else
        serverurl  = [[serverurl stringByAppendingString:@"/"] stringByAppendingString:@"-1"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         lstClasses = [[NSMutableArray alloc] init];
         NSArray *classList = [receivedData objectForKey:@"classes"];
         NSArray *durationList = [receivedData objectForKey:@"duration"];
         NSArray *availableArray = [receivedData objectForKey:@"available"];
         NSArray *bookArray = [receivedData objectForKey:@"bookArray"];
         NSString * upcomingDate = [receivedData objectForKey:@"upcoming"];
         mUpcomingDate = upcomingDate;
         for (int i = 0;i < classList.count;i++)
         {
             NSDictionary *classObject = [classList objectAtIndex:i];
             ClassModel *nModel = [[ClassModel alloc] init];
             NSDictionary* categoryObject = [classObject objectForKey:@"category"];
             nModel.mName = [classObject objectForKey:@"name"];
             nModel.mDate = [classObject objectForKey:@"date"];
             nModel.mEndDate = [classObject objectForKey:@"enddate"];
             nModel.mEndHour = [classObject objectForKey:@"endhour"];
             nModel.mStartHour = [classObject objectForKey:@"starthour"];
             
             NSDictionary* gymObject = [classObject objectForKey:@"gym_info"];
             nModel.mImage = [gymObject objectForKey:@"image"];
             nModel.mGymName = [gymObject objectForKey:@"name"];
             nModel.mDuration = [durationList objectAtIndex:i];
             nModel.mAvailable = [availableArray objectAtIndex:i];
             nModel.mDescription = [gymObject objectForKey:@"description"];
             nModel.mIsBook = [bookArray objectAtIndex:i];
             nModel.mCity = [gymObject objectForKey:@"city"];
             nModel.mAddress = [gymObject objectForKey:@"address"];
             
             nModel.mCategory = [classObject objectForKey:@"category"];
             nModel.mId = [classObject objectForKey:@"id"];
             if (![categoryObject isKindOfClass:[NSNull class]])
             {
                 nModel.mCategory = [categoryObject objectForKey:@"category"];
             }
             
             [lstClasses addObject:nModel];
             
             
             
         }
         lstCitys = [[NSMutableArray alloc] init];
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
         //[self inflateSearchDialog];
         [self setClassData];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) setClassData
{
    if (lstClasses.count > 0)
    {
        [self.vwReviewContent.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        self.btnUpcoming.hidden = YES;
        self.lblUpcoming.hidden = YES;
        
    }
    else
    {
        [self.vwReviewContent.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        self.lblUpcoming.hidden = NO;
        if ([mUpcomingDate isEqualToString:@""])
        {
            self.lblUpcoming.text = NSLocalizedString(@"noClasses", @"");
            self.btnUpcoming.hidden = YES;
        }
        else
        {
            self.btnUpcoming.hidden = NO;
            self.lblUpcoming.text = NSLocalizedString(@"noClassToday", @"");
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat1 setDateFormat:@"dd/MM"];
            NSDate *now = [dateFormat dateFromString:mUpcomingDate];
            
            NSString *upcomingDate = [NSLocalizedString(@"upcomingDate", @"") stringByAppendingString:[dateFormat1 stringFromDate:now]];
            [self.btnUpcoming setTitle:upcomingDate forState:UIControlStateNormal];
            [self.btnUpcoming addTarget:self action:@selector(clickUpcomingDate:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self addClasses];
}
-(void) clickUpcomingDate:(id) sender
{
    if (![mUpcomingDate isEqualToString:@""])
    {
        currentGymDate = mUpcomingDate;
        searchGymDate = mUpcomingDate;
        [self updateCalendar];
        [self loadClass];
        [self selectFirstDate];
    }
}
-(void) addClasses
{
    
    for (int i = 0;i  < lstClasses.count;i++)
    {
        [self addClassItem:[lstClasses objectAtIndex:i] :120 * i:i];
    }
    double height = self.constraintHeightView.constant + 280 + 120 * lstClasses.count;
    self.constraintHeightDetailView.constant = height;
    [self.vwDetailGymContent setNeedsUpdateConstraints];
    [self.vwDetailGymContent layoutIfNeeded];
    [self.scrDetailGym setContentSize:CGSizeMake(self.scrDetailGym.contentSize.width, height)];
}
-(void) addClassItem:(ClassModel *) model :(double) top:(int) index
{
    double width = self.view.bounds.size.width;
    UIView *reviewView = [[UIView alloc] initWithFrame:CGRectMake(8,top, width - 35, 120)];
    UIImageView *imgGym = [[UIImageView alloc] initWithFrame:CGRectMake(8, top + 8, 102, 107)];
    NSString *imgUrl = [c_imageUrl stringByAppendingString:model.mImage];
    //NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgUrl]];
    //imgGym.image= [UIImage imageWithData: imageData];
    [imgGym sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                   placeholderImage:[UIImage imageNamed:@""]];
    
    
    UILabel *lblClassName = [[UILabel alloc] initWithFrame:CGRectMake(120, top + 10 , 200, 21)];
    lblClassName.text = model.mName;
    lblClassName.textColor = [Globals colorWithHexString:@"2798c6"];
    
    UILabel *lblGymName = [[UILabel alloc] initWithFrame:CGRectMake(120, top + 36 , 200, 21)];
    lblGymName.text = [[model.mGymName stringByAppendingString:@" "] stringByAppendingString:model.mCity];
    lblGymName.textColor = [Globals colorWithHexString:@"aaaaaa"];
    
    if ([model.mCategory isKindOfClass:[NSNull class]])
        model.mCategory = @"";
    UILabel *lblDuration = [[UILabel alloc] initWithFrame:CGRectMake(120, top + 62 , 200, 21)];
    lblDuration.text = [[[model.mCategory stringByAppendingString:[@" (" stringByAppendingString:[[(NSNumber *)(model.mDuration) stringValue] stringByAppendingString:@" "]]] stringByAppendingString:NSLocalizedString(@"min", @"")] stringByAppendingString:@")"];
    lblDuration.textColor = [Globals colorWithHexString:@"aaaaaa"];
    
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(120, top + 88 , 200, 21)];
    
    
    lblStatus.textColor = [Globals colorWithHexString:@"aaaaaa"];
    
    if (isLogin == 1)
    {
        if (model.mIsBook != nil && [model.mIsBook longLongValue] > 0)
        {
            lblStatus.text = NSLocalizedString(@"booked", @"");
        }
        else
        {
            if ([model.mAvailable longLongValue] == 0)
            {
                lblStatus.text = NSLocalizedString(@"full", @"");
            }
            else{
                lblStatus.text = [NSLocalizedString(@"spotsAvailable", @"") stringByAppendingString:[(NSNumber*) (model.mAvailable) stringValue]];
            }
        }
    }
    else
    {
        
        if ([model.mAvailable longLongValue] == 0)
        {
            lblStatus.text = NSLocalizedString(@"full", @"");
        }
        else{
            lblStatus.text = [NSLocalizedString(@"spotsAvailable", @"") stringByAppendingString:[(NSNumber*) (model.mAvailable) stringValue]];
        }
    }
    UILabel *lblOpenHour = [[UILabel alloc] initWithFrame:CGRectMake(8, top + 88 , 100, 21)];
    lblOpenHour.backgroundColor = [[Globals colorWithHexString:@"000000"] colorWithAlphaComponent:0.8];
    
    NSRange range = NSMakeRange(0, 5);
    NSString *startHour = @"";
    if (model.mStartHour.length > 5)
        startHour =[model.mStartHour substringWithRange:range];
    NSString *endHour  = @"";
    if (model.mEndHour.length > 5)
        endHour = [model.mEndHour substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateGym = [formatter dateFromString:currentGymDate];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:dateGym];
    NSInteger currentDay = [components weekday] - 1;
    NSString *openHour = [[[[[c_days objectAtIndex:currentDay] stringByAppendingString:@" "] stringByAppendingString:startHour] stringByAppendingString:@"-"] stringByAppendingString: endHour];   
    
    lblOpenHour.textColor = [Globals colorWithHexString:@"ffffff"];
    lblOpenHour.textAlignment = NSTextAlignmentCenter;
    [lblOpenHour setFont:[UIFont systemFontOfSize:11]];
    lblOpenHour.text = openHour;
    
    
    [reviewView addSubview:imgGym];
    [reviewView addSubview:lblClassName];
    [reviewView addSubview:lblGymName];
    [reviewView addSubview:lblDuration];
    [reviewView addSubview:lblStatus];
    [reviewView addSubview:lblOpenHour];
    reviewView.tag = index;
    UITapGestureRecognizer *imageclimgClickView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClass:)];
    [reviewView addGestureRecognizer:imageclimgClickView];
    
    
    [self.vwReviewContent addSubview:reviewView];
}
-(void)clickClass:(id) sender
{
    UITapGestureRecognizer*t = sender;
    int tag = [t.view tag];
    currentClass = [lstClasses objectAtIndex:tag];
    DetailClassViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailClassViewController"];
    viewController.gymController = self;
    viewController.navController = self.navigationController;
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void) selectFirstDate
{
    for (int i = 0;i < 7;i++)
    {
        UIButton *dateButton = (UIButton*)[classGymDates objectAtIndex:i];
        dateButton.layer.borderWidth = 0;
    }
    
    UIButton *selectDate = (UIButton*)[classGymDates objectAtIndex: 0];
    selectDate.layer.borderWidth = 1;
    selectDate.layer.cornerRadius = 12;
    selectDate.layer.borderColor = [[Globals colorWithHexString:@"45A99D"] CGColor];
}
-(void) closeScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)updateCalendar
{
    for (int i = 0;i < 7;i++)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *now = [dateFormat dateFromString:currentGymDate];
        NSDate *iDaysAgo = [now dateByAddingTimeInterval:+i*24*60*60];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |NSCalendarUnitWeekday| NSCalendarUnitMonth | NSCalendarUnitYear fromDate:iDaysAgo];
        NSString *date = [NSString stringWithFormat:@"%ld",(long)[components day]];
        [((UIButton*)[classGymDates objectAtIndex:i]) setTitle:date forState:UIControlStateNormal];
        UIButton *button = (UIButton*)[classGymDates objectAtIndex:i];
        button.tag = i;
        [button addTarget:self action:@selector(clickDate:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lblDate = (UILabel *) [classGymLabels objectAtIndex:i];
        lblDate.text = [c_days objectAtIndex:[components weekday] - 1];
        
    }
    
}

-(void) actionSchedule
{
    gymId = [(NSNumber*)currentGym.mId stringValue];
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (self.navController != nil)
         {
             ClassListViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClassListViewController"];
             [self.navController pushViewController:viewController animated:YES];
         }
         
     }];

}
-(void) serviceLastVisitGym
{
    NSString *serverurl = [[[[[c_baseUrl stringByAppendingString:c_lastVisitGym] stringByAppendingString:@"/" ] stringByAppendingString:[(NSNumber*)(mAccount.mId) stringValue]] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)(currentGym.mId) stringValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         mLastVisitGym = @"";
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSString*bookTime = [receivedData objectForKey:@"booktime"];
         mVisitAmount = [receivedData objectForKey:@"count"];
         NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
         [dateFormatter1 setDateFormat:@"dd/MM HH:mm"];
         NSDate* bookDate = [dateFormatter dateFromString:bookTime];
         if (![bookTime isEqualToString:@""])
         {
             NSTimeInterval secondsInEightHours = 3 * 60 * 60;
             NSDate *dateEightHoursAhead = [bookDate dateByAddingTimeInterval:secondsInEightHours];
             long timeStamp = [dateEightHoursAhead timeIntervalSince1970];
             long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
             if (timeStamp > currentTimeStamp)
             {
                 mLastVisitGym = [dateFormatter1 stringFromDate:bookDate];
             }
         }
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
    if (mLastVisitGym == nil || [mLastVisitGym isEqualToString:@""])
    {
        if ([self isCloseGym])
        {
            [self.btnVisitGym setTitle:NSLocalizedString(@"close", @"") forState:UIControlStateNormal];
            //[self.btnVisitGym setBounds:CGRectMake(self.btnVisitGym.bounds.origin.x, self.view.bounds.size.width - 100, 78, self.btnVisitGym.bounds.size.height)];
            [self.btnVisitGym setEnabled:false];
        }
        else
        {
            if ([currentGym.mUsuability longLongValue] > [mVisitAmount longLongValue])
            {
                [self.btnVisitGym setTitle:NSLocalizedString(@"visit", @"") forState:UIControlStateNormal];
                //[self.btnVisitGym setBounds:CGRectMake(self.btnVisitGym.bounds.origin.x, self.view.bounds.size.width - 100, 78, self.btnVisitGym.bounds.size.height)];
                [self.btnVisitGym setEnabled:true];
            }
            else
            {
                [self.btnVisitGym setTitle:NSLocalizedString(@"full", @"") forState:UIControlStateNormal];
                //[self.btnVisitGym setBounds:CGRectMake(self.btnVisitGym.bounds.origin.x, self.view.bounds.size.width - 100, 78, self.btnVisitGym.bounds.size.height)];
                [self.btnVisitGym setEnabled:false];
            }
        }
    }
    else
    {
        NSString* buttonName = [NSLocalizedString(@"activeUntil", @"") stringByAppendingString:mLastVisitGym];
        [self.btnVisitGym setTitle:buttonName forState:UIControlStateNormal];
        [self.btnVisitGym setEnabled:false];
        //[self.btnVisitGym setBounds:CGRectMake(self.btnVisitGym.bounds.origin.x, self.btnVisitGym.bounds.origin.y, 128, self.btnVisitGym.bounds.size.height)];
    }
}
-(void) actionVisitGym
{
    NSNumber *credit = (NSNumber *)(mAccount.mCredit);
    if ([credit longLongValue] > 0)
    {
        [self serviceBookGym];
    }
    else
    {
        UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", @"") message:NSLocalizedString(@"buyCredit", @"")delegate:self cancelButtonTitle:NSLocalizedString(@"closebutton", @"") otherButtonTitles:NSLocalizedString(@"goMember", @""), nil];
        [errDlg show];
    }
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
-(void) serviceBookGym
{
    NSString *serverurl = [[[[[c_baseUrl stringByAppendingString:c_bookGym] stringByAppendingString:@"/" ] stringByAppendingString:[(NSNumber*)(mAccount.mId) stringValue]] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)(currentGym.mId) stringValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSString* result = [receivedData objectForKey:@"result"];
         mVisitCode = [receivedData objectForKey:@"code"];
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
-(Boolean) isCloseGym
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDay = [components weekday] - 1;
    NSRange range = NSMakeRange(0, 5);
    NSString *endHour =[[currentGym.mEndHours objectAtIndex:currentDay] substringWithRange:range];
    NSString* currentDate = [dateFormatter1 stringFromDate:[NSDate date]];
    NSString *currentHour = [[currentDate stringByAppendingString:@" "] stringByAppendingString:endHour];
    NSDate *dateEnd = [NSDate date];
    dateEnd = [dateFormatter dateFromString:currentHour];
    long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    long endTimeStamp = [dateEnd timeIntervalSince1970];
    if (currentTimeStamp > endTimeStamp)
    {
        return true;
        
    }
    return false;
}
-(void) setBookButtonName
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM HH:mm"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSTimeInterval secondsInEightHours = 3 * 60 * 60;
    NSDate *dateEightHoursAhead = [[NSDate date] dateByAddingTimeInterval:secondsInEightHours];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    long credit = [mAccount.mCredit longLongValue] - 1;
    NSString* buttonName = [NSLocalizedString(@"activeUntil", @"") stringByAppendingString:[dateFormatter stringFromDate:dateEightHoursAhead]];
    [self.btnVisitGym setTitle:buttonName forState:UIControlStateNormal];
    [self.btnVisitGym setEnabled:false];
    //[self.btnVisitGym setBounds:CGRectMake(self.btnVisitGym.bounds.origin.x, self.btnVisitGym.bounds.origin.y, 128, self.btnVisitGym.bounds.size.height)];
    
    mAccount.mCredit  = [NSString stringWithFormat:@"%ld", credit];
    [Globals saveUserInfo];
    NSString *strSuccess =[[[[NSLocalizedString(@"success", @"") stringByAppendingString:@"\n"] stringByAppendingString:NSLocalizedString(@"code", @"")] stringByAppendingString:@":"] stringByAppendingString:[(NSNumber*)mVisitCode stringValue]];
    if (mVisitCode == nil || [mVisitCode longLongValue] == 0)
        strSuccess =NSLocalizedString(@"success", @"");
    UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:strSuccess message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"closebutton", @"") otherButtonTitles:NSLocalizedString(@"shareFacebook", @""), nil];
    
    errDlg.tag = 1;
    UITextField* myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    [errDlg addSubview:myTextField];
    [errDlg show];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) serviceLoadReview:(NSNumber*) gid
{
    NSString *serverurl = [[[ c_baseUrl stringByAppendingString:c_loadReviewGym] stringByAppendingString:@"/"] stringByAppendingString:[gid stringValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSArray *reviewArray = [receivedData objectForKey:NSLocalizedString(@"reviews", @"")];
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
         //[self addReview];
         if (isLogin == 1) {
             [self serviceLastVisitGym];
         };
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) addReview
{
    for (int i = 0;i  < lstReview.count;i++)
    {
        [self addReviewItem:[lstReview objectAtIndex:i] :80 * i];
    }
    double height = self.vwDetailGymInfo.bounds.size.height + 176 + 80 * lstReview.count;
    [self.scrDetailGym setContentSize:CGSizeMake(self.scrDetailGym.contentSize.width, height)];
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
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(width-147, 52, 105, 20)];
    
    NSString *dateStr = model.mDate;
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    lblDate.text = [dateFormat1 stringFromDate:date];
    
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
    [self.vwReviewContent addSubview:reviewView];
}
-(void) setData
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDay = [components weekday] - 1;
    
    
    self.lblGymName.text = currentGym.mName;
    self.lblLocationGym.text = [[currentGym.mAddress stringByAppendingString:@" "] stringByAppendingString:currentGym.mCity];
    self.lblDetailGymReview.text = [[[[@"(" stringByAppendingString:[(NSNumber*)currentGym.mReview stringValue]] stringByAppendingString:@" "] stringByAppendingString:NSLocalizedString(@"reviews", @"")] stringByAppendingString:@")"];
    NSString *imgUrl = [c_imageUrl stringByAppendingString:currentGym.mImage];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgUrl]];
    self.imgDetailGym.image= [UIImage imageWithData: imageData];
    NSRange range = NSMakeRange(0, 5);
    NSString *startHour =[[currentGym.mStartHours objectAtIndex:currentDay] substringWithRange:range];
    NSString *endHour = [[currentGym.mEndHours objectAtIndex:currentDay] substringWithRange:range];
    NSString *openHour = [[startHour stringByAppendingString:@"-"] stringByAppendingString: endHour];
    double rating = [currentGym.mRating doubleValue];
    [Globals setRatingView:rating:self.imgDetailGymStar1 :self.imgDetailGymStar2  :self.imgDetailGymStar3  :self.imgDetailGymStar4  :self.imgDetailGymStar5 ];
    self.lblOpenHourGym.text = openHour;
    self.txtGymDescription.text = currentGym.mDescripton;
    CGSize textViewSize = [currentGym.mDescripton sizeWithFont:self.txtGymDescription.font
                           constrainedToSize:CGSizeMake(self.txtGymDescription.bounds.size.width, FLT_MAX)
                               lineBreakMode:UILineBreakModeTailTruncation];
    self.constraintHeight.constant = textViewSize.height + 5;
    self.constraintHeightView.constant = 201 + textViewSize.height;
    [self.txtGymDescription setNeedsUpdateConstraints];
    [self.txtGymDescription layoutIfNeeded];
    [self.vwDetailGymInfo setNeedsUpdateConstraints];
    [self.vwDetailGymInfo layoutIfNeeded];
    

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
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
