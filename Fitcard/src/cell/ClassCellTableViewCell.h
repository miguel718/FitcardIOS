//
//  ClassCellTableViewCell.h
//  Fitcard
//
//  Created by BoHuang on 7/29/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imgClass;
@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblGym;
@property (weak, nonatomic) IBOutlet UILabel *lblSpot;
@property (weak, nonatomic) IBOutlet UIImageView *imageClass;
@property (weak, nonatomic) IBOutlet UILabel *lblOpenHour;

@end
