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
#import <FBSDKShareKit/FBSDKShareKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGCShareManager : NSObject<UIDocumentInteractionControllerDelegate,FBSDKSharingDelegate>
@property (retain) UIDocumentInteractionController * documentInteractionController;
+ (instancetype)sharedInstance;

- (void)showShareViewWithShareMessage:(NSString *)message;
- (void)showShareViewWithShareMessage:(NSString *)message posterModel:(NSArray <PosterPosterModel *> *)posterModelArr productModel:(DistributorRankProductModel *)productModel;

@end

NS_ASSUME_NONNULL_END
