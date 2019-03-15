//
//  ProfileViewController.m
//  Fitcard
//
//  Created by BoHuang on 8/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "Globals.h"
#import "AFNetworking.h"

@interface ProfileViewController ()

@end
NSURL *imagePath = nil;
Boolean isUpdatePicture;
UIImage *profileImage;
@implementation ProfileViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customSetup];
    [self.btnCleanCard setTitle:NSLocalizedString(@"cleanCard", @"") forState:UIControlStateNormal];
    [self serviceProfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setData
{
    if  (mAccount.mImage != nil)
    {
        NSString *imgUrl = [c_imageUrl stringByAppendingString:mAccount.mImage];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgUrl]];
        self.imgProfile.image= [UIImage imageWithData: imageData];
    }
    
    self.editName.text = mAccount.mName;
    self.editEmail.text = mAccount.mEmail;
    self.editCity.text = mAccount.mCity;
    self.editPhone.text = mAccount.mPhone;
    self.editAddress.text = mAccount.mAddress;
    if ([mAccount.mCredit isKindOfClass:[NSNumber class]])
        self.lblCredits.text = [[NSLocalizedString(@"currentCredits", @"") stringByAppendingString:[(NSNumber*)mAccount.mCredit stringValue]] stringByAppendingString:NSLocalizedString(@"credits", @"")];
    else self.lblCredits.text = [[NSLocalizedString(@"currentCredits", @"") stringByAppendingString:mAccount.mCredit] stringByAppendingString:NSLocalizedString(@"credits", @"")];
    //self.lblCredits.text = [[NSLocalizedString(@"currentCredits", @"") stringByAppendingString:[(NSNumber*)mAccount.mCredit stringValue]] stringByAppendingString:NSLocalizedString(@"credits", @"")];
    self.imgProfile.layer.cornerRadius = 50;
    self.imgProfile.layer.masksToBounds = YES;
    
    [self.btnUpdateProfile addTarget:self action:@selector(updateProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCleanCard addTarget:self action:@selector(cleanCard) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *imageclimgClickView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitingClick)];
    [self.vwImage addGestureRecognizer:imageclimgClickView];
    [self.editEmail setEnabled:false];
    isUpdatePicture = false;
    [Globals saveUserInfo];
    

}
-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    imagePath = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    profileImage = pickedImage;
    [self.imgProfile setImage:pickedImage];
    isUpdatePicture = true;
    
}
-(void) serviceProfile
{
    NSString *serverurl = [[[ c_baseUrl1 stringByAppendingString:c_profileUser] stringByAppendingString:@"?api_token="] stringByAppendingString:mAccount.mToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
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
             uModel.mEmail = mAccount.mEmail;
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
             [self setData];
         }
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void)waitingClick
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
}
-(void) cleanCard
{
    [self serviceCleanCard];
    
}
-(void) serviceCleanCard
{
    NSString *serverurl = [[[ c_baseUrl stringByAppendingString:c_cleanCard] stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*)mAccount.mId stringValue]];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         mAccount.mHasToken = false;
         [Globals saveUserInfo];
         [Globals showErrorDialog:NSLocalizedString(@"messageCleanCard", @"")];
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
-(void) updateProfile
{
    NSString *mName = self.editName.text;
    NSString *mCity = self.editCity.text;
    NSString *mPhone = self.editPhone.text;
    NSString *mAddress = self.editAddress.text;
    if ([mName isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyName", @"")];
        return;
    }
    else if ([mCity isEqualToString: @""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyCity", @"")];
        return;
    }
    else if ([mPhone isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyPhone", @"")];
        return;
    }
    else if ([mAddress isEqualToString:@""])
    {
        [Globals showErrorDialog:NSLocalizedString(@"messageEmptyAddress", @"")];
        return;
    }
    mAccount.mAddress = mAddress;
    mAccount.mPhone = mPhone;
    mAccount.mCity = mCity;
    mAccount.mName = mName;
    if (isUpdatePicture)
    {
        [self serviceUploadImage];
    }
    else
        [self serviceUpdateProfile];
}
-(void) serviceUploadImage
{
    [self addActivityIndicator];
    
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_uploadLogo];
    UIImage *thumbImage;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(70,70), NO, 0);
    [profileImage drawInRect:CGRectMake(0, 0, 70, 70)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage,0.7);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *fileName = [mAccount.mName stringByAppendingString:@".jpg"];
    
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager POST:serverurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"uploaded_file" fileName:fileName mimeType:@"multipart/form-data;boundary=*****"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        mAccount.mImage = [@"/uploads/consumer/" stringByAppendingString:fileName];
        [self serviceUpdateProfile];
        [Globals removeActivityIndicator:self.activityIndicator :self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.response);
        
        
    }];
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
-(void) serviceUpdateProfile
{
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_uploadProfile];
    serverurl = [[[serverurl stringByAppendingString:@"/"] stringByAppendingString:[(NSNumber*) mAccount.mId stringValue]] stringByAppendingString:@"/-1/-1/-1/-1"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    NSDictionary * params = @{@"image":mAccount.mImage,@"phone":mAccount.mPhone ,@"city":mAccount.mCity ,@"address":mAccount.mAddress,@"name":mAccount.mName};
    
    [manager POST:serverurl parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [Globals showErrorDialog:NSLocalizedString(@"profileUpdated", @"")];
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
