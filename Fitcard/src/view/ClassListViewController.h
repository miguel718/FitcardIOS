//
//  ClassListViewController.h
//  Fitcard
//
//  Created by BoHuang on 7/29/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNAActivityIndicator.h"
#import "DownPicker.h"

@interface ClassListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblClasses;
@property (weak, nonatomic) IBOutlet UIButton *btnDateBack;
@property (weak, nonatomic) IBOutlet UIButton *btnDateNext;
@property (weak, nonatomic) IBOutlet UIButton *btnDate1;
@property (weak, nonatomic) IBOutlet UIView *vwScrollContent;
@property (weak, nonatomic) IBOutlet UILabel *lblDate1;
@property (weak, nonatomic) IBOutlet UILabel *lblDate2;
@property (weak, nonatomic) IBOutlet UIButton *btnDate2;
@property (weak, nonatomic) IBOutlet UILabel *lblDate3;
@property (weak, nonatomic) IBOutlet UIButton *btnDate3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblDate4;
@property (weak, nonatomic) IBOutlet UIButton *btnDate4;
@property (weak, nonatomic) IBOutlet UILabel *lblDate5;
@property (weak, nonatomic) IBOutlet UIButton *btnDate5;
@property (weak, nonatomic) IBOutlet UILabel *lblDate6;
@property (weak, nonatomic) IBOutlet UIButton *btnDate6;
@property (weak, nonatomic) IBOutlet UILabel *lblDate7;
@property (weak, nonatomic) IBOutlet UIButton *btnDate7;
@property (weak, nonatomic) IBOutlet UIButton *btnUpcoming;
@property (weak, nonatomic) IBOutlet UILabel *lblUpcoming;

@property (weak, nonatomic) IBOutlet UIImageView *ImageClass;
@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *vwSearchDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnDialogSearch;
@property (weak, nonatomic) IBOutlet UITextField *editDialogKeyword;
@property (weak, nonatomic) IBOutlet UITextField *editDialogCity;
@property (weak, nonatomic) IBOutlet UITextField *editDialogCategory;

@property (strong, nonatomic)  DownPicker *pickerCity;
@property (strong, nonatomic)  DownPicker *pickerCategory;

@end
