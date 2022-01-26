//
//  MGCShareManager.h
//  SFShop
//
//  Created by Lufer on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import "MGCShareInfoModel.h"
#import "MGCShareItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGCShareManager : NSObject

+ (instancetype)sharedInstance;

- (void)showShareViewWithShareMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
