//
//  ClassModel.m
//  Fitcard
//
//  Created by BoHuang on 7/30/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel


- (NSComparisonResult)compareDate:(ClassModel *)otherObject {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dt1 = [[self.mDate stringByAppendingString:@" "] stringByAppendingString:self.mStartHour];
    NSString *dt2 = [[otherObject.mDate stringByAppendingString:@" "] stringByAppendingString:otherObject.mStartHour];
    NSDate* date1 = [dateFormatter dateFromString:dt1];
    NSDate* date2 = [dateFormatter dateFromString:dt2];
    if ([date1 timeIntervalSince1970] < [date2 timeIntervalSince1970])
    {
        return NSOrderedAscending;
    }
    else if ([date1 timeIntervalSince1970] > [date2 timeIntervalSince1970])
        return NSOrderedDescending;
    return NSOrderedSame;
}


@end
