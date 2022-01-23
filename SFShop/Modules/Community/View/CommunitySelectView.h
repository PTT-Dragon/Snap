//
//  CommunitySelectView.h
//  SFShop
//
//  Created by Lufer on 2022/1/23.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CommunitySelectViewBlock)(ArticleTitleModel *titleModel);

@interface CommunitySelectView : UIView
@property (nonatomic,copy) CommunitySelectViewBlock block;
@property (nonatomic,strong) ArticleTitleModel *titleModel;
@end

NS_ASSUME_NONNULL_END
