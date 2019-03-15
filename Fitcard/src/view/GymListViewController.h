//
//  GymListViewController.h
//  Fitcard
//
//  Created by BoHuang on 7/29/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WNAActivityIndicator.h"
#import "DownPicker.h"

@interface GymListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *vwSort;
@property (weak, nonatomic) IBOutlet UIButton *btnSortDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnSortOpen;

@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnTabMap;
@property (weak, nonatomic) IBOutlet UIButton *btnTabList;
@property (weak, nonatomic) IBOutlet UITableView *tblGym;
@property (weak, nonatomic) IBOutlet UIView *vwSearchDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnDialogSearch;
@property (weak, nonatomic) IBOutlet UITextField *editDialogKeyword;
@property (weak, nonatomic) IBOutlet UITextField *editDialogCity;
@property (weak, nonatomic) IBOutlet UIView *vwDialogKeyword;
@property (weak, nonatomic) IBOutlet UIView *vwDialogCity;

@property (strong, nonatomic)  DownPicker *pickerCity;

@property (weak, nonatomic) IBOutlet UIScrollView *scrlSearch;
@property (weak, nonatomic) IBOutlet UIView *vwContentView;
@property (weak, nonatomic) IBOutlet MKMapView *mapGym;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@end
