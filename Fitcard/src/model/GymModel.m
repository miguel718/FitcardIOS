//
//  GymModel.m
//  Fitcard
//
//  Created by BoHuang on 7/25/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "GymModel.h"

@implementation GymModel


- (NSComparisonResult)compareOpen:(GymModel *)otherObject {
    
    Boolean b1 = [self isCloseGym:self];
    Boolean b2 = [self isCloseGym: otherObject];
    if (b1 == true && b2 == false)
    {
        return NSOrderedDescending;
    }
    else if (b1 == false && b2 == true)
    {
        return NSOrderedAscending;
    }
    else return NSOrderedSame;
}
- (NSComparisonResult)compareDistance:(GymModel *)otherObject {
    if (self.mDistance < otherObject.mDistance)
    {
        return NSOrderedAscending;
    }
    else if (self.mDistance > otherObject.mDistance)
        return NSOrderedDescending;
    return NSOrderedSame;
}
-(Boolean) isCloseGym:(GymModel*)model
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday |NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDay = [components weekday] - 1;
    NSRange range = NSMakeRange(0, 5);
    NSString *endHour =[[model.mEndHours objectAtIndex:currentDay] substringWithRange:range];
    NSString* currentDate = [dateFormatter1 stringFromDate:[NSDate date]];
    NSString *currentHour = [[currentDate stringByAppendingString:@" "] stringByAppendingString:endHour];
    NSDate *dateEnd = [NSDate date];
    dateEnd = [dateFormatter dateFromString:currentHour];
    long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    long endTimeStamp = [dateEnd timeIntervalSince1970];
    if (currentTimeStamp > endTimeStamp)
    {
        return true;
        
    }
    return false;
}
@end
