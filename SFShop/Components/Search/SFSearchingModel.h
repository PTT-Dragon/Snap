//
//  SFSearchingModel.h
//  SFShop
//
//  Created by MasterFly on 2021/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchingModel : NSObject

@property (nonatomic, readwrite, strong) NSArray *data;
@property (nonatomic, readwrite, copy) NSString *text;//搜索联想值

//自定义属性
@property (nonatomic, readwrite, copy) NSString *qStr;//搜索关键词
@end

NS_ASSUME_NONNULL_END
