//
//  LoginViewController.m
//  Fitcard
//
//  Created by BoHuang on 7/27/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "AFNetworking.h"
#import "Globals.h"
#import "UserModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    [self.btnLogin addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRegister addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.btnForget addTarget:self action:@selector(actionForget) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void) actionForget
{
    ForgetViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgetViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void) actionRegister
{
    RegisterViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void) actionLogin
{
    NSString *user = self.editUser.text;
    NSString *password = self.editPassword.text;
    
    if ([user isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyUser", @"")];
        return;
    }
    else if ([password isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyPassword", @"")];
        return;
    }
    [self serviceLogin:user :password];
        
}
-(void) serviceLogin:(NSString *)user :(NSString *) password
{
    NSString *serverurl = [ c_baseUrl1 stringByAppendingString:c_loginUser];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    NSDictionary * params = @{@"email":user,@"password":password };
    
    
    
    [manager POST:serverurl parameters:params
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
             uModel.mEmail = user;
             uModel.mPlan = [userObject objectForKey:@"plan_id"];
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
         
         [self openHome];
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
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
-(void) openHome
{
    [Globals saveUserInfo];
    HomeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:viewController animated:YES];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
