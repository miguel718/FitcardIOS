//
//  BookClass.h
//  Fitcard
//
//  Created by BoHuang on 8/8/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookClass : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgClass;
@property (weak, nonatomic) IBOutlet UILabel *lblOpenHour;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelBook;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblBookDate;
@property (weak, nonatomic) IBOutlet UILabel *lblGymName;
@property (weak, nonatomic) IBOutlet UILabel *lblClassName;

@end
