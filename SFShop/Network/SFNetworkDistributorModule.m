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

@end
