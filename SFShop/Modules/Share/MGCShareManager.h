//
//  MGCShareManager.h
//  SFShop
//
//  Created by Lufer on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import "MGCShareInfoModel.h"
#import "MGCShareItemModel.h"
#import "DistributorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGCShareManager : NSObject

+ (instancetype)sharedInstance;

- (void)showShareViewWithShareMessage:(NSString *)message;
- (void)showShareViewWithShareMessage:(NSString *)message posterModel:(PosterPosterModel *)posterModel;

@end

NS_ASSUME_NONNULL_END
