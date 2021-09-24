
#import <Foundation/Foundation.h>

@interface AES128Util : NSObject

/// 通用aes128-cbc 加解密
/// @param content 密码字符串
/// @param key 加密key
/// @param iv 向量
NSString * aes_128_cbc_encryptString(NSString *content, NSString *key, NSString *iv);
NSString * aes_128_cbc_decryptString(NSString *content, NSString *key, NSString *iv);

/// 登录密码加解密
/// @param content 密码字符串
NSString * login_aes_128_cbc_encrypt(NSString *content);
NSString * login_aes_128_cbc_decrypt(NSString *content);
@end
