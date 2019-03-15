//
//  MemberViewController.m
//  Fitcard
//
//  Created by BoHuang on 7/28/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "MemberViewController.h"
#import "SWRevealViewController.h"
#import "ChargeViewController.h"
#import "ProfileViewController.h"
#import "Globals.h"
#import "AFNetworking.h"
#import "MenuViewController.h"
#import "PlanModel.h"

@interface MemberViewController ()

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    [self setBorderView:_vwPlan1];
    [self setBorderView:_vwPlan2];
    [self setBorderView:_vwPlan3];
    [self.btnSubmit addTarget:self action:@selector(submitCouponCode) forControlEvents:UIControlEventTouchUpInside];
    [self serviceLoadPlan];
}
-(void) setBorderView :(UIView *) view
{
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 10;
    view.layer.borderColor = [[Globals colorWithHexString:@"ECEAE4"] CGColor];
    [self.btnPlanSelect1 addTarget:self action:@selector(openChargeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPlanSelect2 addTarget:self action:@selector(openChargeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPlanSelect3 addTarget:self action:@selector(openChargeScreen:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)submitCouponCode
{
    NSString *strCoupon = self.editCouponCode.text;
    if ([strCoupon isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"emptyCode", @"")];
        return;
    }
    [self serviceCouponCode:strCoupon];
}
-(void) serviceCouponCode:(NSString*) code
{
    NSString *serverurl = [[[[[ c_baseUrl stringByAppendingString:c_couponCode] stringByAppendingString:@"/"] stringByAppendingString:code] stringByAppendingString:@"/"] stringByAppendingString:mAccount.mId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         lstGyms = [[NSMutableArray alloc] init];
         NSString *result = [receivedData objectForKey:@"result"];
         if ([result isEqualToString:@"1"])
         {
             NSString* credit = [receivedData objectForKey:@"credit"];
             mAccount.mCredit = credit;
             [Globals saveUserInfo];
             [Globals showErrorDialog:NSLocalizedString(@"successCoupon", @"")];
             return;
             
         }
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) openChargeScreen:(id) sender
{
    if ([sender isEqual:self.btnPlanSelect1])
    {
        currentPlan = 0;
    }
    else if ([sender isEqual:self.btnPlanSelect2])
    {
        currentPlan = 1;
    }
    else if ([sender isEqual:self.btnPlanSelect3])
    {
        currentPlan = 2;
    }
    if (mAccount.mHasToken == nil)
    {
        ChargeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChargeViewController"];
        viewController.navController = self.navigationController;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else if ([mAccount.mHasToken boolValue] == false)
    {
        ChargeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChargeViewController"];
        viewController.navController = self.navigationController;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else
    {
        //messageChangeMembership
        
        UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"messageChangeMembership", @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"no", @"") otherButtonTitles:NSLocalizedString(@"yes", @""), nil];
        errDlg.tag = 11;
        [errDlg show];
        
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11)
    {
        if (buttonIndex == 1)
        {
            [self serviceChangeMembershipBaseCard];
        }
        return;
    }
    if (buttonIndex == 0)
    {
        ProfileViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(void) serviceChangeMembershipBaseCard
{
    NSString *serverurl = [[[[[ c_baseUrl1 stringByAppendingString:c_chargeToken] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)[(PlanModel*)[lstPlans objectAtIndex:currentPlan] mId] stringValue]] stringByAppendingString:@"?api_token="] stringByAppendingString:mAccount.mToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         mAccount.mPlan = [(PlanModel*)[lstPlans objectAtIndex:currentPlan] mId];
         mAccount.mCredit = [(PlanModel*)[lstPlans objectAtIndex:currentPlan] mCredit];
         mAccount.mHasToken = @"1";
         [Globals saveUserInfo];
         UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"messageCharge", @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"close1", @"") otherButtonTitles:nil, nil];
         [errDlg show];
         
         
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) serviceLoadPlan
{
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_loadPlan];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         lstPlans = [[NSMutableArray alloc] init];
         NSArray *planList = [receivedData objectForKey:@"plans"];
         for (int i = 0;i < planList.count;i++)
         {
             NSDictionary *planObject = [planList objectAtIndex:i];
             PlanModel *nModel = [[PlanModel alloc] init];
             nModel.mId = [planObject objectForKey:@"id"];
             nModel.mName = [planObject objectForKey:@"plan"];
             nModel.mPrice = [planObject objectForKey:@"price"];
             nModel.mCredit = [planObject objectForKey:@"credit"];
             
             [lstPlans addObject:nModel];
         }
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
         [self setPlanData];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) setPlanData
{
    self.lblPlanName1.text = [(PlanModel *)[lstPlans objectAtIndex:0] mName];
    self.lblPlanName2.text = [(PlanModel *)[lstPlans objectAtIndex:1] mName];
    self.lblPlanName3.text = [(PlanModel *)[lstPlans objectAtIndex:2] mName];
    
    self.lblPlanCredits1.text = [[(NSNumber*)[(PlanModel *)[lstPlans objectAtIndex:0] mCredit] stringValue] stringByAppendingString:NSLocalizedString(@"creditsMonth", @"")];
    self.lblPlanCredit2.text = [[(NSNumber*)[(PlanModel *)[lstPlans objectAtIndex:1] mCredit] stringValue] stringByAppendingString:NSLocalizedString(@"creditsMonth", @"")];

    self.lblPlanCredit3.text = [[(NSNumber*)[(PlanModel *)[lstPlans objectAtIndex:2] mCredit] stringValue] stringByAppendingString:NSLocalizedString(@"creditsMonth", @"")];
    
    /*self.lblPlanCredits1.text = [[(PlanModel *)[lstPlans objectAtIndex:0] mCredit] stringByAppendingString:NSLocalizedString(@"creditsMonth", @"")];
    self.lblPlanCredit2.text = [[(PlanModel *)[lstPlans objectAtIndex:1] mCredit] stringByAppendingString:NSLocalizedString(@"creditsMonth", @"")];
    
    self.lblPlanCredit3.text = [[(PlanModel *)[lstPlans objectAtIndex:2] mCredit] stringByAppendingString:NSLocalizedString(@"creditsMonth", @"")];*/

    NSString*price1 = [(NSNumber*)[(PlanModel *)[lstPlans objectAtIndex:0] mPrice] stringValue];
    NSString*price2 = [(NSNumber*)[(PlanModel *)[lstPlans objectAtIndex:1] mPrice] stringValue];
    NSString*price3 = [(NSNumber*)[(PlanModel *)[lstPlans objectAtIndex:2] mPrice] stringValue];
    
    self.lblPlanPrice1.text = [[@"€" stringByAppendingString:price1 ] stringByAppendingString:@"/kk"];
    self.lblPlanPrice2.text = [[@"€" stringByAppendingString:price2 ] stringByAppendingString:@"/kk"];
    self.lblPlanPrice3.text = [[@"€" stringByAppendingString:price3] stringByAppendingString:@"/kk"];
    [self selectPlan];
}
-(void) selectPlan
{
    [self.btnPlanSelect1 setTitle:NSLocalizedString(@"select", @"") forState:UIControlStateNormal];
    [self.btnPlanSelect1 setBackgroundColor:[Globals colorWithHexString:@"2389B3"]];
    [self.btnPlanSelect2 setTitle:NSLocalizedString(@"select", @"") forState:UIControlStateNormal];
    [self.btnPlanSelect2 setBackgroundColor:[Globals colorWithHexString:@"2389B3"]];
    [self.btnPlanSelect3 setTitle:NSLocalizedString(@"select", @"") forState:UIControlStateNormal];
    [self.btnPlanSelect3 setBackgroundColor:[Globals colorWithHexString:@"2389B3"]];
    
    self.btnPlanSelect1.userInteractionEnabled = YES;
    self.btnPlanSelect2.userInteractionEnabled = YES;
    self.btnPlanSelect3.userInteractionEnabled = YES;
    
    if (mAccount.mPlan == nil || [mAccount.mPlan isKindOfClass:[NSNull class]])
        mAccount.mPlan = @"4";
    if ([[[lstPlans objectAtIndex:0] mId] longLongValue] == [[mAccount mPlan] longLongValue])
    {
        [self.btnPlanSelect1 setTitle:NSLocalizedString(@"selected", @"") forState:UIControlStateNormal];
        [self.btnPlanSelect1 setBackgroundColor:[Globals colorWithHexString:@"f9a630"]];
        self.btnPlanSelect1.userInteractionEnabled = NO;
    }
    if ([[[lstPlans objectAtIndex:1] mId] longLongValue] == [[mAccount mPlan] longLongValue])
    {
        [self.btnPlanSelect2 setTitle:NSLocalizedString(@"selected", @"") forState:UIControlStateNormal];
        [self.btnPlanSelect2 setBackgroundColor:[Globals colorWithHexString:@"f9a630"]];
        self.btnPlanSelect2.userInteractionEnabled = NO;
    }
    if ([[[lstPlans objectAtIndex:2] mId] longLongValue] == [[mAccount mPlan] longLongValue])
    {
        [self.btnPlanSelect3 setTitle:NSLocalizedString(@"selected", @"") forState:UIControlStateNormal];
        [self.btnPlanSelect3 setBackgroundColor:[Globals colorWithHexString:@"f9a630"]];
        self.btnPlanSelect3.userInteractionEnabled = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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
        MenuViewController *menu = (MenuViewController *)revealViewController.rearViewController;
        [menu.tblMenu reloadData];
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
