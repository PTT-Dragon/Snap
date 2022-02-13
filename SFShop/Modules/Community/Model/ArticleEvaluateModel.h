//
//  ArticleEvaluateModel.h
//  SFShop
//
//  Created by Jacue on 2021/10/19.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ArticleEvaluateModel;

@interface ArticleEvaluateChildrenModel : JSONModel

@property(nonatomic, strong) NSString <Optional> *articleEvalId;
@property(nonatomic, strong) NSString <Optional> *communityArticleId;
@property(nonatomic, strong) NSString <Optional> *createdDate;
@property(nonatomic, strong) NSString  *createdDateStr;
@property(nonatomic, strong) NSString <Optional> *evalComments;
@property(nonatomic, strong) NSString <Optional> *handleDate;
@property(nonatomic, strong) NSString <Optional> *handlePartyType;
@property(nonatomic, strong) NSString <Optional> *handleReason;
@property(nonatomic, strong) NSString <Optional> *handleUserId;
@property(nonatomic, strong) NSString <Optional> *isUseful;
@property(nonatomic, strong) NSString <Optional> *parentId;
@property(nonatomic, strong) NSString <Optional> *replyTotal;
@property(nonatomic, strong) NSString <Optional> *state;
@property(nonatomic, strong) NSString <Optional> *stateDate;
@property(nonatomic, assign) NSInteger usefulCnt;
@property(nonatomic, strong) NSString <Optional> *userId;
@property(nonatomic, strong) NSString <Optional> *userLogo;
@property(nonatomic, strong) NSString <Optional> *userName;

@end


@interface ArticleEvaluateModel : JSONModel

@property(nonatomic, strong) ArticleEvaluateChildrenModel *model;
@property(nonatomic, strong) NSArray <ArticleEvaluateModel *> <ArticleEvaluateModel, Optional> *children;
@property (nonatomic,assign) BOOL showAll;

@end

NS_ASSUME_NONNULL_END
