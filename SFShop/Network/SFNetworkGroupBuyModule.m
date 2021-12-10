//
//  SFNetworkShareBuyModule.m
//  SFShop
//
//  Created by 游挺 on 2021/12/8.
//

#import "SFNetworkGroupBuyModule.h"

@implementation SFNetworkGroupBuyModule


- (NSString *)group
{
    return K_groupBuy_domain(@"group");
}
- (NSString *)getGroupBuyGroupNbr:(NSString *)GroupNbr
{
    NSString *url = [NSString stringWithFormat:@"group/%@",GroupNbr];
    return K_groupBuy_domain(url);
}
@end
