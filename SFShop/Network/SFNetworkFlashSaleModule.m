//
//  SFNetworkFlashSaleModule.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "SFNetworkFlashSaleModule.h"

@implementation SFNetworkFlashSaleModule
- (NSString *)next
{
    return K_flashSale_domain(@"next");
}
- (NSString *)productList
{
    return K_flashSale_domain(@"product/page");
}
- (NSString *)getCatg:(NSString *)catgId
{
    NSString *url = [NSString stringWithFormat:@"catg/%@",catgId];
    return K_flashSale_domain(url);
}
@end
