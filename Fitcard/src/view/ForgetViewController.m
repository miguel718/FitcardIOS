//
//  ForgetViewController.m
//  Fitcard
//
//  Created by BoHuang on 8/9/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "ForgetViewController.h"
#import "AFNetworking.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"
#import "Globals.h"

@interface ForgetViewController ()

@end

@implementation ForgetViewController
NSString *verCode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customSetup];
    [self.btnGetCode addTarget:self action:@selector(actionGetCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnResetPassword addTarget:self action:@selector(actionResetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSetPassword addTarget:self action:@selector(actionSetPassword:) forControlEvents:UIControlEventTouchUpInside];
    self.vwPassword.hidden = true;
    self.btnSetPassword.hidden = true;
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
-(void) actionGetCode:(id) sender
{
    NSString *email = self.editEmail.text;
    if ([email isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyEmail", @"")];
        return;
    }
    NSString *serverurl = [c_baseUrl stringByAppendingString:c_forgetCode];
    NSDictionary * reqParam = @{@"email":email};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:serverurl parameters:reqParam
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSString *code = [receivedData objectForKey:@"code"];
         if ([code longLongValue] == 0)
         {
             [Globals showErrorDialog:NSLocalizedString(@"wrongEmail", @"")];
             return;
         }
         verCode = code;
         [Globals showErrorDialog:NSLocalizedString(@"codeSent", @"")];
         return;
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}
-(void) actionResetPassword:(id) sender
{
    if ([verCode isEqual:nil])
    {
        [Globals showErrorDialog:NSLocalizedString(@"verificationCode", @"")];
        return;
    }
    if ([[(NSNumber*)verCode stringValue] isEqualToString:self.editCode.text])
    {
        self.vwPassword.hidden = false;
        self.btnSetPassword.hidden = false;
    }
    else
    {
        [Globals showErrorDialog:NSLocalizedString(@"wrongCode", @"")];
    }
}
-(void) actionSetPassword:(id) sender
{
    NSString *email = self.editEmail.text;
    NSString *password = self.editPassword.text;
    NSString *serverurl = [c_baseUrl stringByAppendingString:c_resetPassword];
    NSDictionary * reqParam = @{@"email":email,@"password":password};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:serverurl parameters:reqParam
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         LoginViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
         [self.navigationController pushViewController:viewController animated:YES];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
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
