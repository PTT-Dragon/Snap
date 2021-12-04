//
//  SFNetworkDistributorModule.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "SFNetworkDistributorModule.h"

@implementation SFNetworkDistributorModule
- (NSString *)center
{
    return K_distributor_domain(@"center");
}
- (NSString *)rankingTop
{
    return K_distributor_domain(@"salesranking/top10");
}
- (NSString *)cashOutList
{
    return K_distributor_domain(@"cash/request/list");
}
- (NSString *)createCashOut
{
    return K_distributor_domain(@"cash/request/create");
}
- (NSString *)cancelCashOut
{
    return K_distributor_domain(@"cash/request/cancel");
}
- (NSString *)commission
{
    return K_distributor_domain(@"commission");
}
- (NSString *)commissionList
{
    return K_distributor_domain(@"commission/log/list");
}
- (NSString *)orders
{
    return K_distributor_domain(@"orders");
}

@end
