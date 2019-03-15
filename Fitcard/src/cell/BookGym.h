//
//  BookGym.h
//  Fitcard
//
//  Created by BoHuang on 8/8/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookGym : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgGym;
@property (weak, nonatomic) IBOutlet UILabel *lblGymHour;
@property (weak, nonatomic) IBOutlet UILabel *lblGymName;
@property (weak, nonatomic) IBOutlet UILabel *lblBookDate;

@end
