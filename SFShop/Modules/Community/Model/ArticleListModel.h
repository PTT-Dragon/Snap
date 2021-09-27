//
//  ArticleListModel.h
//  SFShop
//
//  Created by Jacue on 2021/9/25.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ArticleModel;

@interface ArticleModel : JSONModel

@property(nonatomic, assign) NSInteger communityArticleId;
@property(nonatomic, strong) NSString <Optional> *contentTitle;
@property(nonatomic, assign) NSInteger viewCnt;
@property(nonatomic, strong) NSString <Optional> *publisherName;
@property(nonatomic, strong) NSString <Optional> *profilePicture;
@property(nonatomic, strong) NSString <Optional> *articlePictures;

@end


@interface ArticleListModel : JSONModel

@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger size;
@property(nonatomic, assign) NSInteger startRow;
@property(nonatomic, assign) NSInteger endRow;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, strong) NSArray <ArticleModel *> <ArticleModel> *list;

@end

NS_ASSUME_NONNULL_END