//
//  BooksViewController.m
//  Fitcard
//
//  Created by BoHuang on 8/8/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "BooksViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "Globals.h"
#import "BookGym.h"
#import "BookClass.h"

@interface BooksViewController ()

@end

@implementation BooksViewController
int bookMode = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblGyms.delegate = self;
    self.tblGyms.dataSource = self;
    [self setMode];
    [self serviceLoadBooks];
    [self customSetup];
    lstClasses = [[NSMutableArray alloc] init];
    lstGyms = [[NSMutableArray alloc] init];
    
    [self.btnTabGym addTarget:self action:@selector(clickTabGym) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTabClass addTarget:self action:@selector(clickTabClass) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) clickTabClass
{
    bookMode = 1;
    [self setMode];
}
-(void) clickTabGym
{
    bookMode = 0;
    [self setMode];
}
-(void) serviceLoadBooks
{
    NSString *serverurl = [[[ c_baseUrl stringByAppendingString:c_loadBooks] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber *)mAccount.mId stringValue]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         lstGyms = [[NSMutableArray alloc] init];
         lstClasses = [[NSMutableArray alloc] init];
         NSArray *gymList = [receivedData objectForKey:@"gyms"];
         for (int i = 0;i < gymList	.count;i++)
         {
             NSDictionary *bookObject = [gymList objectAtIndex:i];
             NSDictionary *gymObject = [bookObject objectForKey:@"gym"];
             GymModel *nModel = [[GymModel alloc] init];
             nModel.mName = [gymObject objectForKey:@"name"];
             nModel.mBookDate = [bookObject objectForKey:@"date"];
             nModel.mBookId = [bookObject objectForKey:@"id"];
             nModel.mRating = [gymObject objectForKey:@"rating"];
             nModel.mImage = [gymObject objectForKey:@"image"];
             nModel.mReview = [gymObject objectForKey:@"reviews"];
             nModel.mCountry = [gymObject objectForKey:@"country"];
             nModel.mCity = [gymObject objectForKey:@"city"];
             nModel.mAddress = [gymObject objectForKey:@"address"];
             nModel.mLat = [gymObject objectForKey:@"lat"];
             nModel.mLon = [gymObject objectForKey:@"lon"];
             nModel.mDescripton = [gymObject objectForKey:@"description"];
             nModel.mId = [gymObject objectForKey:@"id"];
             nModel.mUsuability = [gymObject objectForKey:@"usability"];
             nModel.mStartHours = [[NSMutableArray alloc] init];
             nModel.mEndHours = [[NSMutableArray alloc] init];
             
             for (int j =0;j < c_startHoursField.count;j++)
             {
                 NSString *startHour = [gymObject objectForKey:[c_startHoursField objectAtIndex:j]];
                 NSString *endHour = [gymObject objectForKey:[c_endHoursField objectAtIndex:j]];
                 [nModel.mStartHours addObject:startHour];
                 [nModel.mEndHours addObject:endHour];
             }
             [lstGyms addObject:nModel];
             
         }
         NSArray *classArray = [receivedData objectForKey:@"classes"];
         NSArray *durationArray = [receivedData objectForKey:@"duration"];
         NSArray *availableArray = [receivedData objectForKey:@"available"];
         for (int i = 0;i < classArray.count;i++)
         {
             NSDictionary *bookObject = [classArray objectAtIndex:i];
             NSDictionary *classObject = [bookObject objectForKey:@"class_model"];
             ClassModel *nModel = [[ClassModel alloc] init];
             NSDictionary* categoryObject = [classObject objectForKey:@"category"];
             nModel.mBookDate = [bookObject objectForKey:@"date"];
             nModel.mBookId = [bookObject objectForKey:@"id"];
             nModel.mName = [classObject objectForKey:@"name"];
             nModel.mDate = [classObject objectForKey:@"date"];
             nModel.mEndDate = [classObject objectForKey:@"enddate"];
             nModel.mEndHour = [classObject objectForKey:@"endhour"];
             nModel.mStartHour = [classObject objectForKey:@"starthour"];
             
             NSDictionary* gymObject = [classObject objectForKey:@"gym_info"];
             nModel.mImage = [gymObject objectForKey:@"image"];
             nModel.mGymName = [gymObject objectForKey:@"name"];
             nModel.mDuration = [durationArray objectAtIndex:i];
             nModel.mAvailable = [availableArray objectAtIndex:i];
             nModel.mDescription = [gymObject objectForKey:@"description"];
             nModel.mCity = [gymObject objectForKey:@"city"];
             nModel.mAddress = [gymObject objectForKey:@"address"];
             nModel.mCategory = [classObject objectForKey:@"category"];
             nModel.mId = [classObject objectForKey:@"id"];
             NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd"];
             if (![nModel.mDate isEqualToString:@""])
             {
                 NSDate* bookDate = [dateFormatter dateFromString:nModel.mDate];
                 NSDate* currentDate = [NSDate date];
                 if  ([bookDate timeIntervalSince1970] <= [currentDate timeIntervalSince1970])
                 {
                     continue;
                 }
             }
             [lstClasses addObject:nModel];
             
         }
         [lstClasses sortUsingSelector:@selector(compareDate:)];
         [self.tblGyms reloadData];
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) setMode
{
    if (bookMode == 0)
    {
        [self.btnTabGym setTitleColor:[Globals colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [self.btnTabClass setTitleColor:[Globals colorWithHexString:@"828282"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnTabClass setTitleColor:[Globals colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [self.btnTabGym setTitleColor:[Globals colorWithHexString:@"828282"] forState:UIControlStateNormal];
    }
    [self.tblGyms reloadData];
}
- (void)customSetup
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController panGestureRecognizer];
    [revealViewController tapGestureRecognizer];
    if ( revealViewController )
    {
        [self.btnMenu addTarget:revealViewController action:@selector( revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (bookMode == 0)
        return lstGyms.count;
    else
        return lstClasses.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"BookClass";
    if (bookMode == 0)
        cellIdentifier = @"BookGym";
    BookClass *classCell;
    BookGym *gymCell;
    NSInteger row = indexPath.row;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDay = [components weekday] - 1;
    
    if (bookMode == 0)
        gymCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    else
        classCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (bookMode == 0 && gymCell == nil)
        gymCell = [[BookGym alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    else if (bookMode == 1 && classCell == nil)
        classCell = [[BookClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (bookMode == 1)
    {
        ClassModel *model = [lstClasses objectAtIndex:row];
        classCell.lblClassName.text = model.mName;
        classCell.lblGymName.text = [model.mGymName stringByAppendingString:@" "];
        if (model.mDuration == nil)
            classCell.lblDuration.text = [[@"(0 " stringByAppendingString:NSLocalizedString(@"min", @"")] stringByAppendingString:@")"];
        else classCell.lblDuration.text = [[[@"(" stringByAppendingString:[[(NSNumber *)(model.mDuration) stringValue] stringByAppendingString:@" "]] stringByAppendingString:NSLocalizedString(@"min", @"")] stringByAppendingString:@")"];
        NSString *imgUrl = [c_imageUrl stringByAppendingString:model.mImage];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgUrl]];
        classCell.imgClass.image= [UIImage imageWithData: imageData];
        NSRange range = NSMakeRange(0, 5);
        NSString *startHour = @"";
        if (model.mStartHour.length > 5)
        startHour =[model.mStartHour substringWithRange:range];
        NSString *endHour  = @"";
        if (model.mEndHour.length > 5)
        endHour = [model.mEndHour substringWithRange:range];
        NSString *openHour = [[[[[c_days objectAtIndex:currentDay] stringByAppendingString:@" "] stringByAppendingString:startHour] stringByAppendingString:@"-"] stringByAppendingString: endHour];
        classCell.lblOpenHour.text = openHour;
        classCell.lblOpenHour.hidden = true;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd/MM"];
        NSDate* bookDate = [dateFormatter dateFromString:model.mDate];
        classCell.lblBookDate.text = [[[[[NSLocalizedString(@"date", @"") stringByAppendingString:[dateFormatter1 stringFromDate:bookDate]] stringByAppendingString:@" "] stringByAppendingString:[model.mStartHour substringWithRange:range]] stringByAppendingString:@"-"] stringByAppendingString:[model.mEndHour substringWithRange:range]];
        classCell.btnCancelBook.tag = row;
        [classCell.btnCancelBook addTarget:self action:@selector(clickCancelClass:) forControlEvents:UIControlEventTouchUpInside];
        NSDateFormatter *dFormat1=[[NSDateFormatter alloc] init];
        [dFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *mDt = [[[[model.mDate stringByAppendingString:@" "] stringByAppendingString:[model.mStartHour substringWithRange:range]] stringByAppendingString:@"-"] stringByAppendingString: [model.mEndHour substringWithRange:range]];
        NSDate* eventDate = [dateFormatter dateFromString:mDt];
        NSTimeInterval secondsInEightHours = 24 * 60 * 60;
        NSDate *dateEightHoursAhead = [eventDate dateByAddingTimeInterval:secondsInEightHours];
        long timeStamp = [dateEightHoursAhead timeIntervalSince1970];
        long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
        if (timeStamp > currentTimeStamp)
        {
            classCell.btnCancelBook.hidden = true;
        }
        else classCell.btnCancelBook.hidden = false;
        
        classCell.selectionStyle = UITableViewStylePlain;
        return classCell;
    }
    else
    {
        GymModel *model = [lstGyms objectAtIndex:row];
        gymCell.lblGymName.text = model.mName;
        NSString *imgUrl = [c_imageUrl stringByAppendingString:model.mImage];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgUrl]];
        gymCell.imgGym.image= [UIImage imageWithData: imageData];
        NSRange range = NSMakeRange(0, 5);
        NSString *startHour =[[model.mStartHours objectAtIndex:currentDay] substringWithRange:range];
        NSString *endHour = [[model.mEndHours objectAtIndex:currentDay] substringWithRange:range];
        NSString *openHour = [[[[[c_days objectAtIndex:currentDay] stringByAppendingString:@" "] stringByAppendingString:startHour] stringByAppendingString:@"-"] stringByAppendingString: endHour];
        gymCell.lblGymHour.text = openHour;
        
        NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"dd/MM"];
        NSDateFormatter *dateFormatter3=[[NSDateFormatter alloc] init];
        [dateFormatter3 setDateFormat:@"HH:mm"];
        NSDate* bDate = [dateFormatter1 dateFromString:model.mBookDate];
        NSTimeInterval secondsInEightHours = 3 * 60 * 60;
        NSDate *dateEightHoursAhead = [bDate dateByAddingTimeInterval:secondsInEightHours];
        gymCell.lblBookDate.text = [[[[[dateFormatter2 stringFromDate:bDate] stringByAppendingString:NSLocalizedString(@"at", @"") ] stringByAppendingString:[dateFormatter3 stringFromDate:bDate]] stringByAppendingString:@"-"] stringByAppendingString:[dateFormatter3 stringFromDate:dateEightHoursAhead]];
        
        gymCell.selectionStyle = UITableViewStylePlain;
        return gymCell;
    }
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        int* tag = [alertView tag];
        ClassModel *model = [lstClasses objectAtIndex:tag];
        if ([model.mBookId isKindOfClass:[NSNumber class]])
            [self serviceCancelClass:[(NSNumber*)model.mBookId stringValue]];
        else [self serviceCancelClass:model.mBookId];
        [lstClasses removeObjectAtIndex:tag];
        mAccount.mCredit = [NSString stringWithFormat:@"%lld",[mAccount.mCredit longLongValue] + 1];
        [Globals saveUserInfo];
        [self.tblGyms reloadData];
    }
    return;
}
-(void) clickCancelClass:(id) sender
{
    
    UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"cancelBook", @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"no", @"") otherButtonTitles:NSLocalizedString(@"yes", @""), nil];
    errDlg.tag = [sender tag];
    [errDlg show];
}

-(void) serviceCancelClass:(NSString*) cid
{
    NSString *serverurl = [[[[[ c_baseUrl stringByAppendingString:c_cancelBookClass] stringByAppendingString:@"/"] stringByAppendingString:cid] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)mAccount.mId stringValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
