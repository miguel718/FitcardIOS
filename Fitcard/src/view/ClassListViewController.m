//
//  ClassListViewController.m
//  Fitcard
//
//  Created by BoHuang on 7/29/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "ClassListViewController.h"
#import "SWRevealViewController.h"
#import "ClassCellTableViewCell.h"
#import "Globals.h"
#import "ClassModel.h"
#import "AFNetworking.h"
#import "Searchmodel.h"
#import "DetailClassViewController.h"

@interface ClassListViewController ()

@end

@implementation ClassListViewController
NSMutableArray *classDates;
NSMutableArray *classLabels;

NSMutableArray *arrayClassLocationIds;
NSMutableArray *arrayClassCategoryIds;


NSString *currentDate;
NSString *searchDate;

NSMutableArray *arrayFilterClassLocation;
NSMutableArray *arrayFilterClassCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    classDates = [[NSMutableArray alloc] init];
    classLabels = [[NSMutableArray alloc] init];
    self.tblClasses.dataSource =self;
    self.tblClasses.delegate = self;
    self.lblUpcoming.hidden = YES;
    self.btnUpcoming.hidden = YES;
    self.vwSearchDialog.hidden = YES;
    lstClasses = [[NSMutableArray alloc] init];
    
    [classDates addObject:self.btnDate1];
    [classDates addObject:self.btnDate2];
    [classDates addObject:self.btnDate3];
    [classDates addObject:self.btnDate4];
    [classDates addObject:self.btnDate5];
    [classDates addObject:self.btnDate6];
    [classDates addObject:self.btnDate7];
    
    [classLabels addObject:self.lblDate1];
    [classLabels addObject:self.lblDate2];
    [classLabels addObject:self.lblDate3];
    [classLabels addObject:self.lblDate4];
    [classLabels addObject:self.lblDate5];
    [classLabels addObject:self.lblDate6];
    [classLabels addObject:self.lblDate7];
    
    [self.btnDateBack addTarget:self action:@selector(backDate) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDateNext addTarget:self action:@selector(nextDate) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSearch addTarget:self action:@selector(openSearchDialog) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDialogSearch addTarget:self action:@selector(dialogSearch) forControlEvents:UIControlEventTouchUpInside];
    
    [self customSetup];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //Optionally for time zone conversions
    currentDate = [formatter stringFromDate:[NSDate date]];
    
    [self updateCalendar];
    self.btnDate1.tag = 0;
    [self clickDate:self.btnDate1];
    [self loadClass];
    // Do any additional setup afte	r loading the view.
}
-(void) dialogSearch
{
    [self openSearchDialog];
    [self loadClass];
}
-(void) openSearchDialog
{
    if (self.vwSearchDialog.hidden == true)
    {
        [UIView transitionWithView:self.vwSearchDialog
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.vwSearchDialog.hidden = false;
                        }
                        completion:NULL];
    }
    else
    {
        [UIView transitionWithView:self.vwSearchDialog
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.vwSearchDialog.hidden = true;
                        }
                        completion:NULL];
    }
}

-(bool) isFilter:(ClassModel*)gModel
{
    if (arrayClassLocationIds.count == 0 && arrayClassCategoryIds.count == 0)
        return true;
    if ([arrayClassLocationIds containsObject:gModel.mCity])
    {
        return true;
    }
    else if ([arrayClassCategoryIds containsObject:gModel.mCategory])
    {
            return true;
    }
    return false;
}


-(void) loadClass
{
    NSString *request = [[[searchDate stringByAppendingString:@"/"] stringByAppendingString:gymId] stringByAppendingString:@"/"];
    /*if ([self.editDialogCity.text isEqualToString:@""] || [self.editDialogCity.text isEqualToString:NSLocalizedString(@"any", @"")])
    {
        request = [request stringByAppendingString:@"-1"];
    }
    else
        request = [request stringByAppendingString:self.editDialogCity.text];*/
    
    request = [request stringByAppendingString:@"-1"];
    
    /*if ([self.editDialogCategory.text isEqualToString:@""] || [self.editDialogCategory.text isEqualToString:NSLocalizedString(@"any", @"")])
    {
        request = [[request stringByAppendingString:@"/" ] stringByAppendingString:@"-1"];
    }
    else
    {
        request = [[request stringByAppendingString:@"/" ] stringByAppendingString:self.editDialogCategory.text];
    }*/
    request = [[request stringByAppendingString:@"/" ] stringByAppendingString:@"-1"];
    if ([self.editDialogKeyword.text isEqualToString:@""])
    {
        request = [[request stringByAppendingString:@"/" ] stringByAppendingString:@"-1"];
    }
    else
    {
        request = [[request stringByAppendingString:@"/" ] stringByAppendingString:self.editDialogKeyword.text];
    }
    arrayClassLocationIds = [[NSMutableArray alloc] init];
    arrayClassCategoryIds = [[NSMutableArray alloc] init];
    for (int i = 0;i < arrayFilterClassCategory.count;i++)
    {
        UIButton *filterButton = [arrayFilterClassCategory objectAtIndex:i];
        if (filterButton.isSelected)
        {
            SearchModel *sModel = [lstCategory objectAtIndex:i];
            [arrayClassCategoryIds addObject:sModel.mName];
        }
    }
    for (int i = 0;i < arrayFilterClassLocation.count;i++)
    {
        UIButton *filterButton = [arrayFilterClassLocation objectAtIndex:i];
        if (filterButton.isSelected)
        {
            SearchModel *sModel = [lstCitys objectAtIndex:i];
            [arrayClassLocationIds addObject:sModel.mName];
        }
    }
    
    
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
             nModel.mDescription = [classObject objectForKey:@"description"];
             nModel.mIsBook = [bookArray objectAtIndex:i];
             nModel.mCity = [gymObject objectForKey:@"city"];
             nModel.mAddress = [gymObject objectForKey:@"address"];
             
             nModel.mCategory = [classObject objectForKey:@"category"];
             nModel.mId = [classObject objectForKey:@"id"];
             if (![categoryObject isKindOfClass:[NSNull class]])
             {
                 nModel.mCategory = [categoryObject objectForKey:@"category"];
             }
             else nModel.mCategory = @"";
             
             if ([self isFilter:nModel])
                 [lstClasses addObject:nModel];
             
             
             
         }
         lstCitys = [[NSMutableArray alloc] init];
         NSArray *cityList = [receivedData objectForKey:@"cityList"];
         for (int i = 0;i < cityList.count;i++)
         {
             NSDictionary *cityObject = [cityList objectAtIndex:i];
             SearchModel *nModel = [[SearchModel alloc] init];
             nModel.mName = [cityObject objectForKey:@"city_name"];
             nModel.mId = [cityObject objectForKey:@"id"];
             nModel.mLat = [cityObject objectForKey:@"lat"];
             nModel.mLon = [cityObject objectForKey:@"lon"];
             [lstCitys addObject:nModel];
         }
         
         lstCategory = [[NSMutableArray alloc] init];
         NSArray *categoryList = [receivedData objectForKey:@"category"];
         for (int i = 0;i < categoryList.count;i++)
         {
             NSDictionary *categoryObject = [categoryList objectAtIndex:i];
             SearchModel *nModel = [[SearchModel alloc] init];
             nModel.mName = [categoryObject objectForKey:@"category"];
             nModel.mId = [categoryObject objectForKey:@"id"];
             [lstCategory addObject:nModel];
         }
         
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
         [self setData];
         [self inflateSearchDialog];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) setData
{
    if (lstClasses.count > 0)
    {
        [lstClasses sortUsingSelector:@selector(compareDate:)];
        [self.tblClasses reloadData];
        self.btnUpcoming.hidden = YES;
        self.lblUpcoming.hidden = YES;
        self.tblClasses.hidden = NO;
    }
    else
    {
        self.tblClasses.hidden = YES;
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
    /*[lstClasses sortUsingSelector:@selector(compareDate:)];
    
    [self.tblClasses reloadData];
    self.btnUpcoming.hidden = NO;
    //self.lblUpcoming.hidden = YES;
    self.tblClasses.hidden = NO;
    if (lstClasses.count == 0)
    {
        self.lblUpcoming.hidden = NO;
        self.lblUpcoming.text = NSLocalizedString(@"noClassToday", @"");
    }
    else
    {
        self.lblUpcoming.hidden = YES;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat1 setDateFormat:@"dd/MM"];
    NSDate *now = [dateFormat dateFromString:mUpcomingDate];
    
    NSString *upcomingDate = [NSLocalizedString(@"upcomingDate", @"") stringByAppendingString:[dateFormat1 stringFromDate:now]];
    [self.btnUpcoming setTitle:upcomingDate forState:UIControlStateNormal];
    [self.btnUpcoming addTarget:self action:@selector(clickUpcomingDate:) forControlEvents:UIControlEventTouchUpInside];*/
    
    
    NSMutableArray * arrayCity = [[NSMutableArray alloc] init];
    NSMutableArray *arrayCategory = [[NSMutableArray alloc] init];
    [arrayCity addObject:NSLocalizedString(@"any", @"")];
    [arrayCategory addObject:NSLocalizedString(@"any", @"")];
    for (int i = 0;i < lstCitys.count;i++)
    {
        [arrayCity addObject:[(SearchModel*)[lstCitys objectAtIndex:i] mName]];
    }
    for (int j = 0; j < lstCategory.count;j++)
    {
        [arrayCategory addObject:[(SearchModel*)[lstCategory objectAtIndex:j] mName]];
    }
    self.pickerCity = [[DownPicker alloc] initWithTextField:self.editDialogCity withData:arrayCity];
    self.pickerCategory = [[DownPicker alloc] initWithTextField:self.editDialogCategory withData:arrayCategory];
    self.pickerCity.selectedIndex = 0;
    self.pickerCategory.selectedIndex = 0;
}
-(void) clickUpcomingDate:(id) sender
{
    if (![mUpcomingDate isEqualToString:@""])
    {
        currentDate = mUpcomingDate;
        searchDate = mUpcomingDate;
        [self updateCalendar];
        [self loadClass];
        [self selectFirstDate];
    }
}
-(void) backDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormat dateFromString:currentDate];
    NSDate *iDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
    currentDate = [dateFormat stringFromDate:iDaysAgo];
    searchDate = currentDate;
    [self updateCalendar];
    [self loadClass];
    [self selectFirstDate];
}
-(void) nextDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormat dateFromString:currentDate];
    NSDate *iDaysAgo = [now dateByAddingTimeInterval:+7*24*60*60];
    currentDate = [dateFormat stringFromDate:iDaysAgo];
    searchDate = currentDate;
    [self updateCalendar];
    [self loadClass];
    [self selectFirstDate];
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
-(void)updateCalendar
{
    for (int i = 0;i < 7;i++)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *now = [dateFormat dateFromString:currentDate];
        NSDate *iDaysAgo = [now dateByAddingTimeInterval:+i*24*60*60];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |NSCalendarUnitWeekday| NSCalendarUnitMonth | NSCalendarUnitYear fromDate:iDaysAgo];
        NSString *date = [NSString stringWithFormat:@"%ld",(long)[components day]];
        [((UIButton*)[classDates objectAtIndex:i]) setTitle:date forState:UIControlStateNormal];
        UIButton *button = (UIButton*)[classDates objectAtIndex:i];
        button.tag = i;
        [button addTarget:self action:@selector(clickDate:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lblDate = (UILabel *) [classLabels objectAtIndex:i];
        lblDate.text = [c_days objectAtIndex:[components weekday] - 1];
        
    }

}
-(void) clickDate:(id) sender
{
    NSInteger tag = [sender tag];
    for (int i = 0;i < 7;i++)
    {
        UIButton *dateButton = (UIButton*)[classDates objectAtIndex:i];
        dateButton.layer.borderWidth = 0;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormat dateFromString:currentDate];
    NSDate *iDaysAgo = [now dateByAddingTimeInterval:+tag*24*60*60];
    
    
    UIButton *selectDate = (UIButton*)[classDates objectAtIndex: tag];
    selectDate.layer.borderWidth = 1;
    selectDate.layer.cornerRadius = 12;
    selectDate.layer.borderColor = [[Globals colorWithHexString:@"45A99D"] CGColor];
    searchDate = [dateFormat stringFromDate:iDaysAgo];
    [self loadClass];
}
-(void) selectFirstDate
{
    for (int i = 0;i < 7;i++)
    {
        UIButton *dateButton = (UIButton*)[classDates objectAtIndex:i];
        dateButton.layer.borderWidth = 0;
    }
    
    UIButton *selectDate = (UIButton*)[classDates objectAtIndex: 0];
    selectDate.layer.borderWidth = 1;
    selectDate.layer.cornerRadius = 12;
    selectDate.layer.borderColor = [[Globals colorWithHexString:@"45A99D"] CGColor];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lstClasses.count;
    
}
- (void)filterClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected; // toggle the selected property, just a simple BOOL
}
-(void) inflateSearchDialog
{
    
    arrayFilterClassCategory = [[NSMutableArray alloc] init];
    arrayFilterClassLocation = [[NSMutableArray alloc] init];
    
    
    double baseTop = 120;
    
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, baseTop, 150, 30)];
    lblLocation.text = NSLocalizedString(@"location", @"");
    lblLocation.font = [UIFont systemFontOfSize:14.0];
    [self.vwScrollContent addSubview:lblLocation];
    baseTop = baseTop + 30;
    for (int j = 0;j < lstCitys.count;j++)
    {
        SearchModel *sModel = [lstCitys objectAtIndex:j];
        baseTop = [self addFilterItem:baseTop :arrayFilterClassLocation :sModel.mName];
    }
    
    UILabel *lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(10, baseTop, 150, 30)];
    lblCategory.text = NSLocalizedString(@"category", @"");
    lblCategory.font = [UIFont systemFontOfSize:14.0];
    [self.vwScrollContent addSubview:lblCategory];
    baseTop = baseTop + 30;
    for (int j = 0;j < lstCategory.count;j++)
    {
        SearchModel *sModel = [lstCategory objectAtIndex:j];
        baseTop = [self addFilterItem:baseTop :arrayFilterClassCategory :sModel.mName];
    }
    
    CGSize size = self.scrSearch.contentSize;
    //self.constraintContentHeight.constant = 1000;
    
    //[self.vwScrollContent setNeedsUpdateConstraints];
    //[self.vwScrollContent layoutIfNeeded];
    
    //[self.vwContentView setBackgroundColor:[UIColor redColor]];
    self.constraintHeight.constant = 1000;
    
    [_vwScrollContent setNeedsUpdateConstraints];
    [_vwScrollContent layoutIfNeeded];
    
    [self.scrSearch setContentSize:CGSizeMake(size.width, baseTop)];
}

-(double) addFilterItem:(double) baseTop:(NSMutableArray*) arrayView:(NSString*) name
{
    UIButton *activityButton = [[UIButton alloc] initWithFrame:CGRectMake(17,baseTop, 150, 30)];
    [activityButton setImage:[UIImage imageNamed:@"btn_check_active.png"] forState:UIControlStateSelected];
    [activityButton setImage:[UIImage imageNamed:@"btn_check_normal.png"] forState:UIControlStateNormal];
    [activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [activityButton setTitle:name forState:UIControlStateNormal];
    activityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [activityButton addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
    activityButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [arrayView addObject:activityButton];
    [self.vwScrollContent addSubview:activityButton];
    return baseTop + 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ClassCellTableViewCell";
    ClassCellTableViewCell *cell;
    NSInteger row = indexPath.row;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //Optionally for time zone conversions
    NSDate *dateGym = [formatter dateFromString:currentDate];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:dateGym];
    NSInteger currentDay = [components weekday] - 1;
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[ClassCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    ClassModel *model = [lstClasses objectAtIndex:row];
    cell.lblClassName.text = model.mName;
    cell.lblDuration.text = [[model.mGymName stringByAppendingString:@" "] stringByAppendingString:model.mCity];
    if ([model.mCategory isKindOfClass:[NSNull class]])
        model.mCategory = @"";
    cell.lblGym.text = [[[model.mCategory stringByAppendingString:[@" (" stringByAppendingString:[[(NSNumber *)(model.mDuration) stringValue] stringByAppendingString:@" "]]] stringByAppendingString:NSLocalizedString(@"min", @"")] stringByAppendingString:@")"];
    NSString *imgUrl = [c_imageUrl stringByAppendingString:model.mImage];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgUrl]];
    cell.imageClass.image= [UIImage imageWithData: imageData];
    NSRange range = NSMakeRange(0, 5);
    NSString *startHour = @"";
    if (model.mStartHour.length > 5)
        startHour =[model.mStartHour substringWithRange:range];
    NSString *endHour  = @"";
    if (model.mEndHour.length > 5)
        endHour = [model.mEndHour substringWithRange:range];
    NSString *openHour = [[startHour stringByAppendingString:@"-"] stringByAppendingString: endHour];
    cell.lblOpenHour.text = openHour;
    if (isLogin == 1)
    {
        if (model.mIsBook != nil && [model.mIsBook longLongValue] > 0)
        {
            cell.lblSpot.text = NSLocalizedString(@"booked", @"");
            cell.selectionStyle = UITableViewStylePlain;
            return cell;

        }
    }
    if ([model.mAvailable longLongValue] == 0)
    {
        cell.lblSpot.text = NSLocalizedString(@"full", @"");
    }
    else{
        cell.lblSpot.text = [NSLocalizedString(@"spotsAvailable", @"") stringByAppendingString:[(NSNumber*) (model.mAvailable) stringValue]];
    }
    cell.selectionStyle = UITableViewStylePlain;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentClass = [lstClasses objectAtIndex:indexPath.row];
    DetailClassViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailClassViewController"];
    viewController.navController = self.navigationController;
    [self presentViewController:viewController animated:YES completion:nil];
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
