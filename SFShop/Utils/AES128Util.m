#import "AES128Util.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation AES128Util
static NSString *K_AES_128_CBC_LoginKey = @"4EGJ6D9CFFA2GG9A";
static NSString *K_AES_128_CBC_IV = @"0102030405060708";

#pragma mark - Public
NSString * aes_128_cbc_encryptString(NSString *content, NSString *key, NSString *iv) {
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *encrptedData = aesEncryptData(contentData, keyData, ivData);
    return [encrptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

NSString * aes_128_cbc_decryptString(NSString *content, NSString *key, NSString *iv) {
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = aesDecryptData(contentData, keyData, ivData);
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

NSString * login_aes_128_cbc_encrypt(NSString *content) {
    return aes_128_cbc_encryptString(content,K_AES_128_CBC_LoginKey,K_AES_128_CBC_IV);;
}

NSString * login_aes_128_cbc_decrypt(NSString *content) {
    return aes_128_cbc_decryptString(content,K_AES_128_CBC_LoginKey,K_AES_128_CBC_IV);;
}

#pragma mark - Private
NSData * aesEncryptData(NSData *contentData, NSData *keyData, NSData *ivData) {
    return cipherOperation(contentData, keyData, ivData, kCCEncrypt);
}

NSData * aesDecryptData(NSData *contentData, NSData *keyData, NSData *ivData) {
    return cipherOperation(contentData, keyData, ivData, kCCDecrypt);
}

NSData * cipherOperation(NSData *contentData, NSData *keyData, NSData *ivData, CCOperation operation) {
    NSUInteger dataLength = contentData.length;
    void const *initVectorBytes = ivData.bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  // 与其他平台的PKCS5Padding相等
                                          keyBytes,
                                          kCCKeySizeAES128,  // 秘钥长度选择AES128
                                          initVectorBytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    
    free(operationBytes);
    operationBytes = NULL;
    return nil;
}

@end
