//
//  RegisterViewController.m
//  Fitcard
//
//  Created by BoHuang on 7/27/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "RegisterViewController.h"
#import "SWRevealViewController.h"
#import "Globals.h"
#import "AFNetworking.h"
#import "HomeViewController.h"
#import "MemberViewController.h"


@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    // Do any additional setup after loading the view.
    [self.btnRegister addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
}
-(void) actionRegister
{
    NSString *strUser = self.editUser.text;
    NSString *strPassword = self.editPassword.text;
    NSString *strEmail = self.editEmail.text;
    
    if ([strUser isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyUser", @"")];
        return;
    }
    else if ([strPassword isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyPassword", @"")];
        return;
    }
    else if ([strEmail isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyEmail", @"")];
        return;
    }
    else if (![self isValidEmail:strEmail])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageInvalidEmail", @"")];
        return;
    }
    [self serviceRegister];
}
-(void) serviceRegister
{
    NSString *strUser = self.editUser.text;
    NSString *strPassword = self.editPassword.text;
    NSString *strEmail = self.editEmail.text;
    
    NSString *serverurl = [ c_baseUrl1 stringByAppendingString:c_registerUser];
    NSDictionary * reqParam = @{@"name":strUser,@"email":strEmail,@"password":strPassword};

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager POST:serverurl parameters:reqParam
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *userObject = responseObject;
         NSDictionary *errorObject = [userObject objectForKey:@"error"];
         if (![errorObject isEqual:[NSNull null]])
         {
             UserModel *uModel = [[UserModel alloc] init];
             uModel.mId = [userObject objectForKey:@"id"];
             uModel.mName = [userObject objectForKey:@"name"];
             uModel.mEmail = strEmail;
             uModel.mPlan = @"4";
             uModel.mCredit = [userObject objectForKey:@"credit"];
             uModel.mImage = [userObject objectForKey:@"image"];
             uModel.mPhone = [userObject objectForKey:@"phone"];
             uModel.mCity = [userObject objectForKey:@"city"];
             uModel.mAddress = [userObject objectForKey:@"address"];
             uModel.mInvoiceEnd = [userObject objectForKey:@"invoice_end"];
             uModel.mInvoiceStart = [userObject objectForKey:@"invoice_start"];
             uModel.mToken = [userObject objectForKey:@"api_token"];
             uModel.mHasToken = [userObject objectForKey:@"has_card_token"];
             
             
             mAccount = uModel;
             isLogin = 1;
             
             [self openPrice];
         }
         else{
             [Globals showErrorDialog:NSLocalizedString(@"loginError", @"")];
         }
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) openPrice
{
    [Globals saveUserInfo];    
    
    MemberViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
    
}
-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
