//
//  PDFReader.h
//  SFShop
//
//  Created by YouHui on 2021/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFReader : NSObject

/// 下载并展示pdf
/// @param url pdf 链接
/// @param complete 完成block
+ (void)readPDF:(NSString *)url complete:(void(^)(NSError *_Nullable error, NSURL *_Nullable fileUrl))complete;

@end

NS_ASSUME_NONNULL_END
