//
//  HomePageModel.h
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageModel : NSObject
@property (nonatomic, readwrite, assign) NSInteger bdPageId;
@property (nonatomic, readwrite, assign) NSInteger bdPageVerId;
@property (nonatomic, readwrite, assign) NSInteger devicePageId;
@property (nonatomic, readwrite, copy) NSString* uuid;
@property (nonatomic, readwrite, copy) NSString* verType;
@property (nonatomic, readwrite, copy) NSString* pageUrl;
@property (nonatomic, readwrite, copy) NSString* terminalType;
@property (nonatomic, readwrite, copy) NSString* layout;
@end

@interface ChildNode : NSObject
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *idStr;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *param;
@property (nonatomic, readwrite, copy) NSString *pid;
@property (nonatomic, readwrite, assign) NSInteger index;
@property (nonatomic, readwrite, assign) BOOL isSelected;
@property (nonatomic, readwrite, copy) NSString *renderer;
@end

@interface LayoutModel : NSObject
@property (nonatomic, readwrite, assign) NSInteger index;
@property (nonatomic, readwrite, copy) NSString *idStr;
@property (nonatomic, readwrite, assign) NSInteger pid;
@property (nonatomic, readwrite, assign) BOOL isSelected;
@property (nonatomic, readwrite, strong) NSArray<ChildNode *> *childNodes;
@end

//@interface LayoutModel : NSObject
//
//
//
//@end


NS_ASSUME_NONNULL_END
