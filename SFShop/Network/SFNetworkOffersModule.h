//
//  SFNetworkOffersModule.h
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNetworkOffersModule : NSObject

@property (nonatomic, readonly, copy) NSString *suggest;

@property (nonatomic, readonly, copy) NSString *offers;

@property (nonatomic, readonly, copy) NSString *viewlog;

@property (nonatomic, readonly, copy) NSString *stock;

@property (nonatomic, readonly, copy) NSString *evaluationList;

@property (nonatomic, readonly, copy) NSString *campaigns;





- (NSString *)getDetailOf: (NSInteger)offerId;


@end

NS_ASSUME_NONNULL_END
