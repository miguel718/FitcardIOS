//
//  GymModel.h
//  Fitcard
//
//  Created by BoHuang on 7/25/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GymModel : NSObject

@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mName;
@property (nonatomic, strong) NSString* mDescripton;
@property (nonatomic, strong) NSString* mRating;
@property (nonatomic, strong) NSString* mReview;
@property (nonatomic, strong) NSString* mImage;
@property (nonatomic, strong) NSString*  mCountry;
@property (nonatomic, strong) NSString*  mCity;
@property (nonatomic, strong) NSString*  mAddress;
@property (nonatomic, strong) NSString*  mLat;
@property (nonatomic, strong) NSString*  mLon;
@property (nonatomic, strong) NSString*  mBookDate;
@property (nonatomic, strong) NSString*  mLogo;
@property (nonatomic, strong) NSMutableArray*  mStartHours;
@property (nonatomic, strong) NSMutableArray*  mEndHours;
@property (nonatomic, strong) NSMutableArray*  mCloseHours;
@property (nonatomic, strong) NSString*  mBookId;
@property (nonatomic, strong) NSString*  mUsuability;

@property double  mDistance;

@property (nonatomic, strong) NSMutableArray*  mAmenity;
@property (nonatomic, strong) NSMutableArray*  mActivity;
@property (nonatomic, strong) NSMutableArray*  mStudio;
@property (nonatomic, strong) NSMutableArray*  mLocation;



@end
