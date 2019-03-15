		//
//  ChargeViewController.m
//  Fitcard
//
//  Created by BoHuang on 7/28/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "ChargeViewController.h"
#import "Globals.h"
#import "AFNetworking.h"
#import "PlanModel.h"
#import "HomeViewController.h"

@interface ChargeViewController ()

@end

@implementation ChargeViewController
NSArray *monthArray;
NSArray *yearArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.btnChargeBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.editPay addTarget:self action:@selector(actionPay) forControlEvents:UIControlEventTouchUpInside];
    [self.editAmount setText:[(NSNumber*)[(PlanModel*)[lstPlans objectAtIndex:currentPlan]  mPrice] stringValue]];
    [self.editAmount setEnabled:false];
    
}
-(void) getCardInfo
{
    self.pickerMonth.selectedIndex = 0;
    self.pickerYear.selectedIndex = 0;
    
}
-(void) viewDidAppear:(BOOL)animated
{
    monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    yearArray = @[@"2016",@"2017",@"2018",@"2019",@"2020"];
    
    self.pickerYear = [[DownPicker alloc] initWithTextField:self.editYear withData:yearArray];
    self.pickerMonth = [[DownPicker alloc] initWithTextField:self.editMonth withData:monthArray];
    [self getCardInfo];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) closeScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) actionPay
{
    NSString *cardNumber = self.editCardNumber.text;
    NSString *cvv = self.editCvv.text;
    
    if ([cardNumber isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageCardEmpty", @"")];
        return;
    }
    else if ([cvv isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageCvvEmpty", @"")];
        return;
    }
    NSString * month = [monthArray objectAtIndex:self.pickerMonth.selectedIndex];
    NSString *year = [yearArray objectAtIndex:self.pickerYear.selectedIndex];
    int amount = [self.editAmount.text integerValue] * 100;
    NSString *amt = [NSString stringWithFormat:@"%d",amount];
    
    
    
    [self serviceChargeFund:cardNumber :cvv :month :year :amt ];
}
-(void) serviceChargeFund:(NSString *) card :(NSString*) cvv:(NSString *) month :(NSString *) year:(NSString *)amount
{
    PlanModel *pModel = [lstPlans objectAtIndex:currentPlan];
    NSString *serverurl = [[[[ c_baseUrl1 stringByAppendingString:c_chargeFund] stringByAppendingString:[(NSNumber*) pModel.mId stringValue]] stringByAppendingString:@"?api_token="] stringByAppendingString:mAccount.mToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSString *token = [receivedData objectForKey:@"token"];
         NSString *url = [receivedData objectForKey:@"payment_url"];
         NSString *currency = [receivedData objectForKey:@"currency"];
         [self servicePaymentService:url :token :card :amount :currency :month :year :cvv];
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) servicePaymentService:(NSString *) url :(NSString*) token:(NSString *) card :(NSString *) amount:(NSString *)currency:(NSString *) month:(NSString *) year :(NSString *) code

{
    NSDictionary * params = @{@"token":token,@"card":card,@"amount":amount,@"currency":currency,@"exp_month":month,@"exp_year":year,@"security_code":code};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:	[NSSet setWithObject:@"text/html"]];
    [self addActivityIndicator];
    
    [manager POST:url parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         [self serviceFundCheck:token];
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) serviceFundCheck:(NSString *) token
{
    NSString *serverurl = [[[ c_baseUrl1 stringByAppendingString:c_fundCheck] stringByAppendingString:@"?api_token="] stringByAppendingString:mAccount.mToken];
    
    NSDictionary * params = @{@"payment_token":token};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    
    [manager POST:serverurl parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSString *result = [receivedData objectForKey:@"success"];
         if (![result isEqual:[NSNull class]] && result != nil)
         {
             [self updateUserCredit];
             [Globals saveUserInfo];
             [Globals removeActivityIndicator:self.activityIndicator :self.view];
         }
         else
         {
             [Globals removeActivityIndicator:self.activityIndicator :self.view];
             [Globals showErrorDialog:NSLocalizedString(@"messageFailProcess", @"")];
         }
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];

}
-(void) serviceUpdateCredit:(NSString *) cardToken:(NSString *) planId
{
    NSString *serverurl = [[[[[[[ c_baseUrl stringByAppendingString:c_updateCredit] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)mAccount.mId stringValue]] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)planId stringValue]] stringByAppendingString:@"/"] stringByAppendingString:cardToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         [self updateUserCredit];
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) updateUserCredit
{
    mAccount.mPlan = [(PlanModel *)[lstPlans objectAtIndex:currentPlan] mId];
    mAccount.mCredit = [(PlanModel *)[lstPlans objectAtIndex:currentPlan] mCredit];
    [Globals saveUserInfo];
    UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"messageCharge", @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"close1", @"") otherButtonTitles:nil, nil];
    [errDlg show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:^
         {
             if (self.navController != nil)
             {
                 HomeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
                 [self.navController pushViewController:viewController animated:YES];
             }
             
         }];
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
