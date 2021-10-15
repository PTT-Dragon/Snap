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
#define K_offers_domain(url) [NSString stringWithFormat:@"%@/h5/offers/%@",Host,url]

//*********************************************接口模块👆*********************************************//

#pragma mark - login


#endif /* SFNetworkMacro_h */
