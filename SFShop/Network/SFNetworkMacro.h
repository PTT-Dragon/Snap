//
//  SFNetworkMacro.h
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#ifndef SFNetworkMacro_h
#define SFNetworkMacro_h

//*********************************************接口域名👇*********************************************//
#ifdef DEBUG
#define Host @"http://147.139.137.130"
#else
#define Host @"http://147.139.137.130"
#endif

#define SFImage(v) ([[NSString stringWithFormat:@"%@%@",Host,v] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]])
//*********************************************接口域名👆*********************************************//

//*********************************************接口模块👇*********************************************//
#define K_users_domain(url) [NSString stringWithFormat:@"%@/h5/users/%@",Host,url]
#define K_pages_domain(url) [NSString stringWithFormat:@"%@/h5/pages/%@",Host,url]
#define K_articles_domain(url) [NSString stringWithFormat:@"%@/h5/articles/%@",Host,url]
#define K_articles_evaluate_domain(url) [NSString stringWithFormat:@"%@/h5/articles/%@/evaluate",Host,url]
#define K_offers_domain(url) [NSString stringWithFormat:@"%@/h5/offers/%@",Host,url]
#define K_address_domain(url) [NSString stringWithFormat:@"%@/h5/address/%@",Host,url]
#define K_cart_domain(url) [NSString stringWithFormat:@"%@/h5/carts/%@",Host,url]
#define K_coupon_domain(url) [NSString stringWithFormat:@"%@/h5/coupons/%@",Host,url]
#define K_favorite_domain(url) [NSString stringWithFormat:@"%@/h5/usercollection/%@",Host,url]
#define K_invite_domain(url) [NSString stringWithFormat:@"%@/h5/newInv/%@",Host,url]
#define K_order_domain(url) [NSString stringWithFormat:@"%@/h5/orders/%@",Host,url]
#define K_orderReason_domain(url) [NSString stringWithFormat:@"%@/h5/orderreason/%@",Host,url]
#define K_recent_domain(url) [NSString stringWithFormat:@"%@/h5/viewlog/%@",Host,url]
#define K_evaluate_domain(url) [NSString stringWithFormat:@"%@/h5/evaluate/%@",Host,url]
#define K_refund_domain(url) [NSString stringWithFormat:@"%@/h5/orderapply/%@",Host,url]
#define K_distributor_domain(url) [NSString stringWithFormat:@"%@/h5/kol/%@",Host,url]
#define K_h5_domain(url) [NSString stringWithFormat:@"%@/h5/%@",Host,url]


//*********************************************接口模块👆*********************************************//

#pragma mark - login


#endif /* SFNetworkMacro_h */
