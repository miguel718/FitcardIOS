//
//  BooksViewController.h
//  Fitcard
//
//  Created by BoHuang on 8/8/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNAActivityIndicator.h"

@interface BooksViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnTabClass;
@property (weak, nonatomic) IBOutlet UIButton *btnTabGym;
@property (weak, nonatomic) IBOutlet UITableView *tblGyms;

@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;

@end
