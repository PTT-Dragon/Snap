//
//  SFNetworkDistributorModule.h
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNetworkDistributorModule : NSObject
@property (nonatomic, readonly, copy) NSString *center;
@property (nonatomic, readonly, copy) NSString *rankingTop;
@property (nonatomic, readonly, copy) NSString *cashOutList;
@property (nonatomic, readonly, copy) NSString *createCashOut;
@property (nonatomic, readonly, copy) NSString *cancelCashOut;
@property (nonatomic, readonly, copy) NSString *commission;
@property (nonatomic, readonly, copy) NSString *commissionList;



@end

NS_ASSUME_NONNULL_END
