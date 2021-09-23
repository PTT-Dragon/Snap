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
//*********************************************接口域名👆*********************************************//

//*********************************************接口模块👇*********************************************//
#define K_account_domain(url) [NSString stringWithFormat:@"%@/loginModule/%@",Host,url]
#define K_h5_domain(url) [NSString stringWithFormat:@"%@/h5/%@",Host,url]
//*********************************************接口模块👆*********************************************//

#endif /* SFNetworkMacro_h */
