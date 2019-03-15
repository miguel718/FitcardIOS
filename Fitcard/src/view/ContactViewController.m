//
//  ContactViewController.m
//  Fitcard
//
//  Created by BoHuang on 8/8/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "ContactViewController.h"
#import "Globals.h"
#import "AFNetworking.h"
#import "SWRevealViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    [self.btnSubmit addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
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
-(void) clickSubmit:(id) sender
{
    NSString *strName = self.editName.text;
    NSString *strEmail = self.editEmail.text;
    NSString *strPhone = self.editPhone.text;
    NSString *strAddress = self.editAddrss.text;
    NSString *strMessage = self.editMessage.text;
    if ([strMessage isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"emptyMessage", @"")];
        return;
    }
    else if ([strEmail isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyEmail", @"")];
        return;
    }
    NSString *str = [[[[[[[[[@"Name:" stringByAppendingString:strName] stringByAppendingString:@"<br>Email:"] stringByAppendingString:strEmail] stringByAppendingString:@"<br>Phone:"] stringByAppendingString:strPhone] stringByAppendingString:@"<br>Address:"] stringByAppendingString:strAddress] stringByAppendingString:@"<br><br>"] stringByAppendingString:strMessage];
    
    [self serviceContact:str];
    [Globals showErrorDialog:NSLocalizedString(@"messageSent", @"")];
    self.editEmail.text = @"";
    self.editName.text = @"";
    self.editPhone.text = @"";
    self.editMessage.text = @"";
    self.editAddrss.text = @"";	
    
}
-(void) serviceContact:(NSString *) strMessage
{
    NSString *serverurl = [c_baseUrl stringByAppendingString:c_cancelBookClass];
    NSDictionary * reqParam = @{@"message":strMessage};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:serverurl parameters:reqParam
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
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
