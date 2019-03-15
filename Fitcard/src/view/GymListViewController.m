//
//  GymListViewController.m
//  Fitcard
//
//  Created by BoHuang on 7/29/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//
#import "GymListViewController.h"
#import "SWRevealViewController.h"
#import "Globals.h"
#import "AFNetworking.h"
#import "GymModel.h"
#import "SearchModel.h"
#import "GymCell.h"
#import "DetailGymViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GymListViewController ()

@end

@implementation GymListViewController
int viewMode = 0;
NSMutableArray *arrayFilterLocation;
NSMutableArray *arrayFilterStudio;
NSMutableArray *arrayFilterActivity;
NSMutableArray *arrayFilterAmenity;

NSMutableArray *arrayLocationIds;
NSMutableArray *arrayStudioIds;
NSMutableArray *arrayActivityIds;
NSMutableArray *arrayAmenityIds;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    lstGyms = [[NSMutableArray alloc] init];
    self.tblGym.delegate = self;
    self.mapGym.delegate = self;
    self.tblGym.dataSource = self;
    [self.btnSearch addTarget:self action:@selector(openSearchDialog) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTabList addTarget:self action:@selector(openListMode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTabMap addTarget:self action:@selector(openMapMode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSortOpen addTarget:self action:@selector(sortOpen) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSortDistance addTarget:self action:@selector(sortDistance) forControlEvents:UIControlEventTouchUpInside];
    self.vwSearchDialog.hidden = true;
    [self.btnSortOpen setTitleColor:[Globals colorWithHexString:@"2798C6"] forState:UIControlStateNormal];
    [self.btnSortDistance setTitleColor:[Globals colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    [self setViewMode];
    [self serviceLoadGym];
    
}
-(void) sortOpen
{
    [self.btnSortOpen setTitleColor:[Globals colorWithHexString:@"2798C6"] forState:UIControlStateNormal];
    [self.btnSortDistance setTitleColor:[Globals colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    [lstGyms sortUsingSelector:@selector(compareDistance:)];
    [lstGyms sortUsingSelector:@selector(compareOpen:)];
    [self.tblGym reloadData];
}
-(void) sortDistance
{
    [self.btnSortDistance setTitleColor:[Globals colorWithHexString:@"2798C6"] forState:UIControlStateNormal];
    [self.btnSortOpen setTitleColor:[Globals colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    [lstGyms sortUsingSelector:@selector(compareDistance:)];
    [self.tblGym reloadData];
}
-(void) openListMode
{
    viewMode = 0;
    [self setViewMode];
}
-(void) openMapMode
{
    viewMode = 1;
    [self setViewMode];
}

-(void) setViewMode
{
    if (viewMode == 0)
    {
        self.tblGym.hidden = NO;
        self.mapGym.hidden = YES;
        self.vwSort.hidden = NO;
        [self.btnTabList setTitleColor:[Globals colorWithHexString:@"2798C6"] forState:UIControlStateNormal];
        [self.btnTabMap setTitleColor:[Globals colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    }
    else
    {
        self.tblGym.hidden = YES;
        self.mapGym.hidden = NO;
        self.vwSort.hidden = YES;
        [self.btnTabMap setTitleColor:[Globals colorWithHexString:@"2798C6"] forState:UIControlStateNormal];
        [self.btnTabList setTitleColor:[Globals colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];

    }
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
    //self.vwSearchDialog.hidden = false;
}
-(void) serviceLoadGym
{
    
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_gymlistUrl];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         lstGyms = [[NSMutableArray alloc] init];
         NSMutableArray *closeGyms = [[NSMutableArray alloc] init];
         NSMutableArray *openGyms = [[NSMutableArray alloc] init];
         NSArray *gymList = [receivedData objectForKey:@"gyms"];
         for (int i = 0;i < gymList.count;i++)
         {
             NSDictionary *gymObject = [gymList objectAtIndex:i];
             GymModel *nModel = [[GymModel alloc] init];
             nModel.mName = [gymObject objectForKey:@"name"];
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
             nModel.mCloseHours = [[NSMutableArray alloc] init];
             double lat = [nModel.mLat doubleValue];
             double lon = [nModel.mLon doubleValue];
             CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
             if (currentLocation != nil)
                 nModel.mDistance = [currentLocation distanceFromLocation:locA];
             for (int j =0;j < c_startHoursField.count;j++)
             {
                 NSString *startHour = [gymObject objectForKey:[c_startHoursField objectAtIndex:j]];
                 NSString *endHour = [gymObject objectForKey:[c_endHoursField objectAtIndex:j]];
                 NSString *close = [gymObject objectForKey:[c_closeField objectAtIndex:j]];
                 [nModel.mStartHours addObject:startHour];
                 [nModel.mEndHours addObject:endHour];
                 [nModel.mCloseHours addObject:close];
             }
             if ([self isCloseGym:nModel])
             {
                 [closeGyms addObject:nModel];
             }
             else
                 [openGyms addObject: nModel];
             
         }
         for (int t = 0;t < openGyms.count;t++)
         {
             [lstGyms addObject:[openGyms objectAtIndex:t]];
         }
         for (int t = 0;t < closeGyms.count;t++)
         {
             [lstGyms addObject:[closeGyms objectAtIndex:t]];
         }

         lstCitys = [[NSMutableArray alloc] init];
         NSArray *cityList = [receivedData objectForKey:@"cityInfos"];
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
         
         lstLocations = [[NSMutableArray alloc] init];
         NSArray *locationList = [receivedData objectForKey:@"locationInfos"];
         for (int i = 0;i < locationList.count;i++)
         {
             NSDictionary *locationObject = [locationList objectAtIndex:i];
             SearchModel *nModel = [[SearchModel alloc] init];
             nModel.mName = [locationObject objectForKey:@"name"];
             nModel.mId = [locationObject objectForKey:@"id"];
             [lstLocations addObject:nModel];
         }
         
         lstAmenity = [[NSMutableArray alloc] init];
         NSArray *amenityList = [receivedData objectForKey:@"amenityInfos"];
         for (int i = 0;i < amenityList.count;i++)
         {
             NSDictionary *amenityObject = [amenityList objectAtIndex:i];
             SearchModel *nModel = [[SearchModel alloc] init];
             nModel.mName = [amenityObject objectForKey:@"name"];
             nModel.mId = [amenityObject objectForKey:@"id"];
             [lstAmenity addObject:nModel];
         }
         lstActivity = [[NSMutableArray alloc] init];
         NSArray *activityList = [receivedData objectForKey:@"activityInfos"];
         for (int i = 0;i < activityList.count;i++)
         {
             NSDictionary *activityObject = [activityList objectAtIndex:i];
             SearchModel *nModel = [[SearchModel alloc] init];
             nModel.mName = [activityObject objectForKey:@"name"];
             nModel.mId = [activityObject objectForKey:@"id"];
             [lstActivity addObject:nModel];
         }
         
         lstStudio = [[NSMutableArray alloc] init];
         NSArray *studioList = [receivedData objectForKey:@"studioInfos"];
         for (int i = 0;i < studioList.count;i++)
         {
             NSDictionary *studioObject = [studioList objectAtIndex:i];
             SearchModel *nModel = [[SearchModel alloc] init];
             nModel.mName = [studioObject objectForKey:@"name"];
             nModel.mId = [studioObject objectForKey:@"id"];
             [lstStudio addObject:nModel];
         }
         [self sortOpen];
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
         [self.tblGym reloadData];
         [self inflateSearchDialog];
         [self addMarker];
         [self addCurrentLocation];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}

-(Boolean) isCloseGym:(GymModel*)model
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDay = [components weekday] - 1;
    NSRange range = NSMakeRange(0, 5);
    NSString *endHour =[[model.mEndHours objectAtIndex:currentDay] substringWithRange:range];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lstGyms.count;
    
}
-(void) addCurrentLocation
{
    MKPointAnnotation *mark = [[MKPointAnnotation alloc] init];
    if (currentLocation != nil)
    {
        CLLocationCoordinate2D coordinate = [currentLocation coordinate];
        mark.title = NSLocalizedString(@"currentLocation", @"");
        mark.coordinate = coordinate;
        [self.mapGym addAnnotation:mark];
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = currentLocation.coordinate;
        [self.mapGym setRegion:region animated:YES];
    }
}
-(void) addMarker
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDay = [components weekday] - 1;
    NSRange range = NSMakeRange(0, 5);
    for(int i = 0; i < lstGyms.count; i++)
    {
        GymModel* gModel = [lstGyms objectAtIndex:i];
        MKPointAnnotation *mark = [[MKPointAnnotation alloc] init];
        NSString *startHour =[[gModel.mStartHours objectAtIndex:currentDay] substringWithRange:range];
        NSString *endHour = [[gModel.mEndHours objectAtIndex:currentDay] substringWithRange:range];
        mark.title = gModel.mName;
        mark.subtitle = [[startHour stringByAppendingString:@"-"] stringByAppendingString:endHour];
        mark.coordinate = CLLocationCoordinate2DMake([gModel.mLat doubleValue],[gModel.mLon doubleValue]);
        
        [self.mapGym addAnnotation:mark];
        
        
    }
    
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    static NSString *annReuseId = @"currentloc";
    
    MKPinAnnotationView *annView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annReuseId];
    if (annView == nil)
    {
        annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annReuseId];
        
        annView.animatesDrop = YES;
        annView.canShowCallout = YES;
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annView.rightCalloutAccessoryView=detailButton;
    }
    else {
        annView.annotation = annotation;
    }
    return annView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //[self performSegueWithIdentifier:@"DetailsIphone" sender:view];
    //[Globals showErrorDialog:@"aaa"];
    MKAnnotationView *annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKPointAnnotation *mark = annotation;
        for(int i = 0; i < lstGyms.count; i++)
        {
            GymModel* gModel = [lstGyms objectAtIndex:i];
            if ([mark.title isEqualToString:gModel.mName])
            {
                currentGym = [lstGyms objectAtIndex:i];
                DetailGymViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailGymViewController"];
                viewController.navController = self.navigationController;
                [self presentViewController:viewController animated:YES completion:nil];            }
        }
    }

}
-(void) inflateSearchDialog
{
    NSMutableArray * arrayCity = [[NSMutableArray alloc] init];
    arrayFilterStudio = [[NSMutableArray alloc] init];
    arrayFilterActivity = [[NSMutableArray alloc] init];
    arrayFilterAmenity = [[NSMutableArray alloc] init];
    arrayFilterLocation = [[NSMutableArray alloc] init];
    
    arrayAmenityIds = [[NSMutableArray alloc] init];
    arrayStudioIds = [[NSMutableArray alloc] init];
    arrayActivityIds = [[NSMutableArray alloc] init];
    arrayLocationIds = [[NSMutableArray alloc] init];
    
    
    /*
    [arrayCity addObject:NSLocalizedString(@"any", @"")];
    for (int j = 0; j < lstCitys.count;j++)
    {
        [arrayCity addObject:[(SearchModel*)[lstCitys objectAtIndex:j] mName]];
    }
    self.pickerCity = [[DownPicker alloc] initWithTextField:self.editDialogCity withData:arrayCity];
    self.pickerCity.selectedIndex = 0;*/
    
    [self.btnDialogSearch addTarget:self action:@selector(searchGym) forControlEvents:UIControlEventTouchUpInside];
    //UILabel *lblActivity = [[UILabel alloc] initWithFrame:CGRectMake(10, 172, 150, 30)];
    //lblActivity.text = @"Activity";
    //lblActivity.font = [UIFont systemFontOfSize:14.0];
    //[self.vwContentView addSubview:lblActivity];
    double baseTop = 120;
    /*for (int j = 0;j < lstActivity.count;j++)
    {
        SearchModel *sModel = [lstActivity objectAtIndex:j];
        baseTop = [self addFilterItem:baseTop :arrayFilterActivity :sModel.mName];
    }*/
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, baseTop, 150, 30)];
    lblLocation.text = NSLocalizedString(@"location", @"");
    lblLocation.font = [UIFont systemFontOfSize:14.0];
    [self.vwContentView addSubview:lblLocation];
    baseTop = baseTop + 30;
    for (int j = 0;j < lstLocations.count;j++)
    {
        SearchModel *sModel = [lstLocations objectAtIndex:j];
        baseTop = [self addFilterItem:baseTop :arrayFilterLocation :sModel.mName];
    }

    
    
    UILabel *lblStudio = [[UILabel alloc] initWithFrame:CGRectMake(10, baseTop, 150, 30)];
    lblStudio.text = NSLocalizedString(@"studio", @"");
    lblStudio.font = [UIFont systemFontOfSize:14.0];
    [self.vwContentView addSubview:lblStudio];
    baseTop = baseTop + 30;
    for (int j = 0;j < lstStudio.count;j++)
    {
        SearchModel *sModel = [lstStudio objectAtIndex:j];
        baseTop = [self addFilterItem:baseTop :arrayFilterStudio :sModel.mName];
    }
    
    UILabel *lblAmenity = [[UILabel alloc] initWithFrame:CGRectMake(10, baseTop, 150, 30)];
    lblAmenity.text = NSLocalizedString(@"amenity", @"");
    lblAmenity.font = [UIFont systemFontOfSize:14.0];
    [self.vwContentView addSubview:lblAmenity];
    baseTop = baseTop + 30;
    for (int j = 0;j < lstAmenity.count;j++)
    {
        SearchModel *sModel = [lstAmenity objectAtIndex:j];
        baseTop = [self addFilterItem:baseTop :arrayFilterAmenity :sModel.mName];
    }
    
    
    CGSize size = self.scrlSearch.contentSize;
    self.constraintContentHeight.constant = 1000;
    
    [_vwContentView setNeedsUpdateConstraints];
    [_vwContentView layoutIfNeeded];
    
    //[self.vwContentView setBackgroundColor:[UIColor redColor]];
    [self.scrlSearch setContentSize:CGSizeMake(size.width, baseTop)];
    
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
    [self.vwContentView addSubview:activityButton];
    return baseTop + 30;
}
- (void)filterClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected; // toggle the selected property, just a simple BOOL
}
-(void) searchGym
{
    [self openSearchDialog];
    [self.editDialogKeyword endEditing:YES];
    
    arrayAmenityIds = [[NSMutableArray alloc] init];
    arrayStudioIds = [[NSMutableArray alloc] init];
    arrayActivityIds = [[NSMutableArray alloc] init];
    arrayLocationIds = [[NSMutableArray alloc] init];
    NSString *request  = @"";
    /*if ([self.editDialogCity.text isEqualToString:@""] || [self.editDialogCity.text isEqualToString:NSLocalizedString(@"any", @"")])
    {
        request = [[request stringByAppendingString:@"/"] stringByAppendingString:@"-1"];
    }
    else
        request = [[request stringByAppendingString:@"/"] stringByAppendingString:self.editDialogCity.text];*/
    request = [[request stringByAppendingString:@"/"] stringByAppendingString:@"-1"];
    
    if ([self.editDialogKeyword.text isEqualToString:@""])
    {
        request = [[request stringByAppendingString:@"/" ] stringByAppendingString:@"-1"];
    }
    else
    {
        request = [[request stringByAppendingString:@"/" ] stringByAppendingString:self.editDialogKeyword.text];
    }
    NSString *strAmenity = @"-";
    for (int i = 0;i < arrayFilterAmenity.count;i++)
    {
        UIButton *filterButton = [arrayFilterAmenity objectAtIndex:i];
        if (filterButton.isSelected)
        {
            SearchModel *sModel = [lstAmenity objectAtIndex:i];
            strAmenity = [[strAmenity stringByAppendingString:[(NSNumber*)sModel.mId stringValue]] stringByAppendingString:@"-"];
            [arrayAmenityIds addObject:sModel.mId];
        }
    }
    NSString *strActivity = @"-";
    for (int i = 0;i < arrayFilterActivity.count;i++)
    {
        UIButton *filterButton = [arrayFilterActivity objectAtIndex:i];
        if (filterButton.isSelected)
        {
            SearchModel *sModel = [lstActivity objectAtIndex:i];
            strActivity = [[strActivity stringByAppendingString:[(NSNumber*)sModel.mId stringValue]] stringByAppendingString:@"-"];
            [arrayActivityIds addObject:sModel.mId];
        }
    }
    NSString *strStudio = @"-";
    for (int i = 0;i < arrayFilterStudio.count;i++)
    {
        UIButton *filterButton = [arrayFilterStudio objectAtIndex:i];
        if (filterButton.isSelected)
        {
            SearchModel *sModel = [lstStudio objectAtIndex:i];
            strStudio = [[strStudio stringByAppendingString:[(NSNumber*)sModel.mId stringValue]] stringByAppendingString:@"-"];
            [arrayStudioIds addObject:sModel.mId];
        }
    }
    NSString *strLocation = @"-";
    for (int i = 0;i < arrayFilterLocation.count;i++)
    {
        UIButton *filterButton = [arrayFilterLocation objectAtIndex:i];
        if (filterButton.isSelected)
        {
            SearchModel *sModel = [lstLocations objectAtIndex:i];
            strLocation = [[strLocation stringByAppendingString:[(NSNumber*)sModel.mId stringValue]] stringByAppendingString:@"-"];
            [arrayLocationIds addObject:sModel.mId];
        }
    }
    request = [[request stringByAppendingString:@"/" ] stringByAppendingString:strActivity];
    request = [[request stringByAppendingString:@"/" ] stringByAppendingString:strAmenity];
    request = [[request stringByAppendingString:@"/" ] stringByAppendingString:strStudio];
    request = [[request stringByAppendingString:@"/" ] stringByAppendingString:strLocation];
    [self serviceSearchGym:request];
}
-(void) serviceSearchGym:(NSString *)request
{
    NSString *serverurl = [[ c_baseUrl stringByAppendingString:c_searchGymUrl] stringByAppendingString:request];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         lstGyms = [[NSMutableArray alloc] init];
         NSMutableArray *closeGyms = [[NSMutableArray alloc] init];
         NSMutableArray *openGyms = [[NSMutableArray alloc] init];
         NSArray *gymList = [receivedData objectForKey:@"gyms"];
         for (int i = 0;i < gymList.count;i++)
         {
             NSDictionary *gymObject = [gymList objectAtIndex:i];
             GymModel *nModel = [[GymModel alloc] init];
             nModel.mName = [gymObject objectForKey:@"name"];
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
             nModel.mCloseHours = [[NSMutableArray alloc] init];
             
             double lat = [nModel.mLat doubleValue];
             double lon = [nModel.mLon doubleValue];
             CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
             if (currentLocation != nil)
                 nModel.mDistance = [currentLocation distanceFromLocation:locA];
             
             
             NSArray *gymAmenity = [gymObject objectForKey:@"gym_amenity"];
             NSArray *gymActivity = [gymObject objectForKey:@"gym_activity"];
             NSArray *gymStudio = [gymObject objectForKey:@"gym_studio"];
             NSArray *gymLocation = [gymObject objectForKey:@"gym_location"];
             
             nModel.mAmenity = [[NSMutableArray alloc] init];
             for (int j =0;j < gymAmenity.count;j++)
             {
                 NSDictionary *filterObject = [gymAmenity objectAtIndex:j];
                 [nModel.mAmenity addObject:[filterObject objectForKey:@"amenity_id"]];
             }
             
             nModel.mActivity = [[NSMutableArray alloc] init];
             for (int j =0;j < gymActivity.count;j++)
             {
                 NSDictionary *filterObject = [gymActivity objectAtIndex:j];
                 [nModel.mActivity addObject:[filterObject objectForKey:@"activity_id"]];
             }
             
             nModel.mStudio = [[NSMutableArray alloc] init];
             for (int j =0;j < gymStudio.count;j++)
             {
                 NSDictionary *filterObject = [gymStudio objectAtIndex:j];
                 [nModel.mStudio addObject:[filterObject objectForKey:@"studio_id"]];
             }
             
             nModel.mLocation = [[NSMutableArray alloc] init];
             for (int j =0;j < gymLocation.count;j++)
             {
                 NSDictionary *filterObject = [gymLocation objectAtIndex:j];
                 [nModel.mLocation addObject:[filterObject objectForKey:@"location_id"]];
             }
             
             for (int j =0;j < c_startHoursField.count;j++)
             {
                 NSString *startHour = [gymObject objectForKey:[c_startHoursField objectAtIndex:j]];
                 NSString *endHour = [gymObject objectForKey:[c_endHoursField objectAtIndex:j]];
                 NSString *close = [gymObject objectForKey:[c_closeField objectAtIndex:j]];
                 [nModel.mStartHours addObject:startHour];
                 [nModel.mEndHours addObject:endHour];
                 [nModel.mCloseHours addObject:close];
             }
             if ([self isCloseGym:nModel])
             {
                 [closeGyms addObject:nModel];
             }
             else
                 [openGyms addObject: nModel];
         }
         for (int t = 0;t < openGyms.count;t++)
         {
             GymModel *gModel = [openGyms objectAtIndex:t];
             if ([self isFilter:gModel])
                 [lstGyms addObject:[openGyms objectAtIndex:t]];
         }
         for (int t = 0;t < closeGyms.count;t++)
         {
             GymModel *gModel = [closeGyms objectAtIndex:t];
             if ([self isFilter:gModel])
                 [lstGyms addObject:[closeGyms objectAtIndex:t]];
         }
         [self.tblGym reloadData];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(bool) isFilter:(GymModel*)gModel
{
    for (int i = 0;i < gModel.mActivity.count;i++)
    {
        NSNumber * activityId = [NSNumber numberWithInt:[[gModel.mActivity objectAtIndex:i] intValue]];
        if ([arrayActivityIds containsObject:activityId])
            return true;
    }
    for (int i = 0;i < gModel.mAmenity.count;i++)
    {
        NSNumber * amenityId = [NSNumber numberWithInt:[[gModel.mAmenity objectAtIndex:i] intValue]];
        if ([arrayAmenityIds containsObject:amenityId])
            return true;
    }
    for (int i = 0;i < gModel.mStudio.count;i++)
    {
        NSNumber * studioId = [NSNumber numberWithInt:[[gModel.mStudio objectAtIndex:i] intValue]];
        if ([arrayStudioIds containsObject:studioId])
            return true;
    }
    for (int i = 0;i < gModel.mLocation.count;i++)
    {
        NSNumber * locationId = [NSNumber numberWithInt:[[gModel.mLocation objectAtIndex:i] intValue]];
        if ([arrayLocationIds containsObject:locationId])
            return true;
    }
    if (arrayLocationIds.count == 0 && arrayStudioIds.count == 0 && arrayAmenityIds.count == 0 && arrayActivityIds.count == 0)
        return true;
    return false;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"GymCell";
    GymCell *cell;
    NSInteger row = indexPath.row;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDay = [components weekday] - 1;

    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    GymModel *model = [lstGyms objectAtIndex:row];
    cell.lblName.text = model.mName;
    cell.lblLocation.text = [[model.mAddress stringByAppendingString:@","] stringByAppendingString:model.mCity];
    cell.lblReview.text = [[@"(" stringByAppendingString:[(NSNumber*)model.mReview stringValue]] stringByAppendingString:@" Reviews)"];
    //cell.lblReview.text = [[@"(" stringByAppendingString:model.mReview] stringByAppendingString:@" Reviews)"];
    cell.lblReview.hidden = true;
    NSString *imgUrl = [c_imageUrl stringByAppendingString:model.mImage];
    //NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgUrl]];
    [cell.imgGym sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                 placeholderImage:[UIImage imageNamed:@""]];
    
    //cell.imgGym.image= [UIImage imageWithData: imageData];
    NSRange range = NSMakeRange(0, 5);
    NSString *startHour =[[model.mStartHours objectAtIndex:currentDay] substringWithRange:range];
    NSString *endHour = [[model.mEndHours objectAtIndex:currentDay] substringWithRange:range];
    NSString *openHour = [[[[[c_days objectAtIndex:currentDay] stringByAppendingString:@" "] stringByAppendingString:startHour] stringByAppendingString:@"-"] stringByAppendingString: endHour];
    double rating = [model.mRating doubleValue];
    [Globals setRatingView:rating:cell.imgStar1 :cell.imgStar2 :cell.imgStar3 :cell.imgStar4 :cell.imgStar5];
    if (model.mCloseHours.count > currentDay && [[(NSNumber *)[model.mCloseHours objectAtIndex:currentDay] stringValue] isEqualToString:@"1"])
    {
        cell.lblOpenHour.text = NSLocalizedString(@"close", @"");
    }
    else
        cell.lblOpenHour.text = openHour;
    cell.selectionStyle = UITableViewStylePlain;

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentGym = [lstGyms objectAtIndex:indexPath.row];
    DetailGymViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailGymViewController"];
    viewController.navController = self.navigationController;
    [self presentViewController:viewController animated:YES completion:nil];
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
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
