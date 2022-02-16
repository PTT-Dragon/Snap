//
//  CommunityEvaluateCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/19.
//

#import <UIKit/UIKit.h>
#import "ArticleEvaluateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityEvaluateCell : UITableViewCell
@property (nonatomic,strong) ArticleEvaluateChildrenModel *model;
@property (nonatomic,strong) ArticleEvaluateReplyModel *replyModel;
@property (nonatomic,assign) NSInteger type;//1.评论文章 2.评论回复
@end

NS_ASSUME_NONNULL_END
