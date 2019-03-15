//
//  ClassModel.h
//  Fitcard
//
//  Created by BoHuang on 7/30/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject

@property (nonatomic, strong) NSString* mName;
@property (nonatomic, strong) NSString* mImage;
@property (nonatomic, strong) NSString* mRecurring;
@property (nonatomic, strong) NSString* mEndDate;
@property (nonatomic, strong) NSString* mDate;
@property (nonatomic, strong) NSString* mStartHour;
@property (nonatomic, strong) NSString* mEndHour;
@property (nonatomic, strong) NSString* mGymName;
@property (nonatomic, strong) NSString* mCategory;
@property (nonatomic, strong) NSString* mAddress;
@property (nonatomic, strong) NSString* mDuration;
@property (nonatomic, strong) NSString* mAvailable;
@property (nonatomic, strong) NSString* mDescription;
@property (nonatomic, strong) NSString* mCity;
@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mBookDate;
@property (nonatomic, strong) NSString* mBookId;
@property (nonatomic, strong) NSString* mGymId;
@property (nonatomic, strong) NSString* mIsBook;

@end
