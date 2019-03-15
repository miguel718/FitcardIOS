//
//  HomeViewController.m
//  Fitcard
//
//  Created by BoHuang on 7/25/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "MenuViewController.h"
#import "GymListViewController.h"
#import "ClassListViewController.h"
#import "DetailGymViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "Globals.h"
#import "GymModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface HomeViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@end
@implementation HomeViewController
@synthesize btnMenu;
@synthesize btnFindGym;
@synthesize btnFindClasses;
@synthesize vwFeaturedGyms;
NSMutableArray *vwGymViews;
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    currentLocation = self.locationManager.location;
    
    
    c_startHoursField = @[@"starthour_sun",@"starthour_mon",@"starthour_tue",@"starthour_wed",@"starthour_thu",@"starthour_fri",@"starthour_sat"];
    c_endHoursField = @[@"endhour_sun",@"endhour_mon",@"endhour_tue",@"endhour_wed",@"endhour_thu",@"endhour_fri",@"endhour_sat"];
    c_closeField = @[@"close_sun",@"close_mon",@"close_tue",@"close_wed",@"close_thu",@"close_fri",@"close_sat"];
    c_days = @[NSLocalizedString(@"sun", @""),NSLocalizedString(@"mon", @""),NSLocalizedString(@"tue", @""),NSLocalizedString(@"wed", @""),NSLocalizedString(@"thu", @""),NSLocalizedString(@"fri", @""),NSLocalizedString(@"sat", @"")];
    vwGymViews = [[NSMutableArray alloc] init];
    [self getUserInfo];
    [self customSetup];
    
    
    
    
    UITapGestureRecognizer *gymlist = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGyms:)];
    [self.btnFindGym addGestureRecognizer:gymlist];
    UITapGestureRecognizer *classList = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openClasses:)];
    [self.btnFindClasses addGestureRecognizer:classList];
    [self serviceLoadFeaturedGym];
    [self getFirstTime];
}
-(void) openGyms:(id) sender
{
    GymListViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GymListViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void) openClasses:(id) sender
{
    gymId = @"-1";
    ClassListViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClassListViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void) getFirstTime
{
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    NSString *first = [preference objectForKey:@"first"];
    if (first == nil)
    {
        [preference setObject:@"1" forKey:@"first"];
        [preference synchronize];
        UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"messageWelcome", @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"login", @"") otherButtonTitles:NSLocalizedString(@"signup", @""), nil];
        [errDlg show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == 0)
        {
            LoginViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            RegisterViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
}
-(void) getUserInfo
{
    mAccount = [[UserModel alloc] init];
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    mAccount.mId = [preference objectForKey:@"id"];
    mAccount.mName = [preference objectForKey:@"name"];
    mAccount.mImage = [preference objectForKey:@"image"];
    mAccount.mAddress = [preference objectForKey:@"address"];
    mAccount.mPhone = [preference objectForKey:@"phone"];
    mAccount.mCity = [preference objectForKey:@"city"];
    mAccount.mCredit = [preference objectForKey:@"credit"];
    mAccount.mPlan = [preference objectForKey:@"plan"];
    mAccount.mEmail = [preference objectForKey:@"email"];
    mAccount.mInvoiceEnd = [preference objectForKey:@"invoiceend"];
    mAccount.mInvoiceStart = [preference objectForKey:@"invoicestart"];
    mAccount.mToken = [preference objectForKey:@"token"];
    mAccount.mHasToken = [preference objectForKey:@"hasToken"];
    
    if (mAccount.mName == nil || [mAccount.mName isEqualToString:@""])
    {
        isLogin = 0;
    }
    else isLogin = 1;

}
- (void)customSetup
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;    
    [revealViewController panGestureRecognizer];
    [revealViewController tapGestureRecognizer];
    if ( revealViewController )
    {
        
        MenuViewController *menu = (MenuViewController *)revealViewController.rearViewController;
        [menu.tblMenu reloadData];
        [self.btnMenu addTarget:revealViewController action:@selector( revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
}
-(void) clickFeatureGym:(id) sender
{
    UITapGestureRecognizer *tapGes = (UITapGestureRecognizer*) sender;
    int tag = [tapGes.view tag];
    currentGym = [lstFeaturedGym objectAtIndex:tag];
    DetailGymViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailGymViewController"];
    viewController.navController = self.navigationController;
    [self presentViewController:viewController animated:YES completion:nil];
    
}
-(void) addFeaturedGymView
{
    int nWidth = vwFeaturedGyms.bounds.size.width;
    vwGymViews = [[NSMutableArray alloc] init];
    for (int k = 0;k < lstFeaturedGym.count;k++)
    {
        GymModel *gymObject = [lstFeaturedGym objectAtIndex:k];
        NSString *imageUrl = [c_imageUrl stringByAppendingString:gymObject.mImage];
        UIView *featureGym = [[UIView alloc] initWithFrame:CGRectMake(0, 156 * k, nWidth, 150)];
        UIView *maskGym = [[UIView alloc] initWithFrame:CGRectMake(0,6, nWidth, 150)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,6, nWidth, 150)];
        //NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:[UIImage imageNamed:@""]];
        
        UILabel *lblGymName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, nWidth, 150)];
        [lblGymName setTextAlignment: UITextAlignmentCenter];
        lblGymName.text = gymObject.mName;
        //imageView.image = [UIImage imageWithData: imageData];
        //featureGym.backgroundColor = [UIColor grayColor];
        [featureGym addSubview:imageView];
        [lblGymName setTextColor:[UIColor whiteColor]];
        [maskGym setBackgroundColor:[UIColor colorWithRed:((float) 0)
                                                                                green:((float) 0)
                                                                                 blue:((float) 0)
                                                                                alpha:0.4f]];
        
        [featureGym addSubview:maskGym];
        [lblGymName setFont:[UIFont systemFontOfSize:23]];
        [featureGym addSubview:lblGymName];
        featureGym.tag = k;
        [vwFeaturedGyms addSubview:featureGym];
        [vwGymViews addObject:featureGym];
        
        
        UITapGestureRecognizer *featureGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFeatureGym:)];
        [[vwGymViews objectAtIndex:k] addGestureRecognizer:featureGes];
    }
    
}
-(void) serviceLoadFeaturedGym
{
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_featuredUrl];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         lstFeaturedGym = [[NSMutableArray alloc] init];
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
             
             double lat = [nModel.mLat doubleValue];
             double lon = [nModel.mLon doubleValue];
             CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
             if (currentLocation != nil)
                 nModel.mDistance = [currentLocation distanceFromLocation:locA];
             for (int j =0;j < c_startHoursField.count;j++)
             {
                 NSString *startHour = [gymObject objectForKey:[c_startHoursField objectAtIndex:j]];
                 NSString *endHour = [gymObject objectForKey:[c_endHoursField objectAtIndex:j]];
                 [nModel.mStartHours addObject:startHour];
                 [nModel.mEndHours addObject:endHour];
             }
             [lstFeaturedGym addObject:nModel];
             
             
             
         }
         [self addFeaturedGymView];
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
#pragma mark state preservation / restoration
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    currentLocation = newLocation;
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
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

@end
