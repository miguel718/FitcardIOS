//
//  UserModel.h
//  Fitcard
//
//  Created by BoHuang on 7/27/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject


@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mName;
@property (nonatomic, strong) NSString* mEmail;
@property (nonatomic, strong) NSString* mImage;
@property (nonatomic, strong) NSString* mPlan;
@property (nonatomic, strong) NSString* mCredit;
@property (nonatomic, strong) NSString* mAddress;
@property (nonatomic, strong) NSString*  mCity;
@property (nonatomic, strong) NSString*  mPhone;
@property (nonatomic, strong) NSString*  mInvoiceStart;
@property (nonatomic, strong) NSString*  mInvoiceEnd;
@property (nonatomic, strong) NSString*  mToken;
@property (nonatomic, strong) NSString*  mHasToken;


@end
