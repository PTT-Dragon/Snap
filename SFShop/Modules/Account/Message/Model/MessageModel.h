//
//  MessageModel.h
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MessageUnreadModel;

@interface MessageUnreadModel : JSONModel
@property (nonatomic,copy) NSString *socialCode;
@property (nonatomic,copy) NSString *flowNo;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSMutableAttributedString *messageSttrStr;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *contentType;
@property (nonatomic,assign) NSInteger unreadNum;
@property (nonatomic,copy) NSString *storeId;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *storeLogoUrl;
//加载html片段
+ (NSAttributedString *)attrHtmlStringFrom:(NSString *)str;
@end

@interface MessageContactModel : JSONModel
@property (nonatomic,assign) NSInteger unreadNum;
@property (nonatomic,copy) NSString *sendTime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSMutableAttributedString *contentSttrStr;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *subject;

@end
@interface MessageModel : JSONModel
@property (nonatomic,strong) NSArray <MessageUnreadModel>*unreadMessages;
@property (nonatomic,strong) MessageContactModel *contactMessage;
@end

@interface MessageStoreModel : JSONModel
@property (nonatomic,copy) NSString *storeId;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *logoUrl;
@end
@interface MessageProductModel : JSONModel
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *productNum;
@end

@interface MessageOrderListModel : JSONModel
@property (nonatomic,assign) NSInteger relaType;
@property (nonatomic,copy) NSString *relaObjId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *sendTime;
@property (nonatomic,strong) MessageContactModel *message;
@property (nonatomic,strong) MessageProductModel *product;
@property (nonatomic,strong) MessageStoreModel *store;

@end



NS_ASSUME_NONNULL_END
