//
//  PDFReader.m
//  SFShop
//
//  Created by YouHui on 2021/12/9.
//

#import "PDFReader.h"
#import <QuickLook/QuickLook.h>

@interface PDFReader ()<QLPreviewControllerDataSource>
@property (nonatomic, readwrite, strong) QLPreviewController *qlVc;
@property (nonatomic, readwrite, strong) NSURL *fileUrl;
@end

@implementation PDFReader

static PDFReader *_instance = nil;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PDFReader alloc] init];
        //在退出app时清掉temporary 文件夹
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            NSString *temporary = NSTemporaryDirectory();
            NSArray *contents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:temporary error:NULL];
            NSEnumerator *e = [contents objectEnumerator];
            NSString *filename;
            while ((filename = [e nextObject])) {
                [NSFileManager.defaultManager removeItemAtPath:[temporary stringByAppendingPathComponent:filename] error:NULL];
            }
        }];
    });
    return _instance;
}

+ (void)readPDF:(NSString *)url complete:(void (^)(NSError * _Nullable, NSURL * _Nullable))complete {
    [MBProgressHUD showHudMsg:@""];
    [SFNetworkManager downloadPDF:url success:^(NSURL *fileURL) {
        PDFReader.share.fileUrl = fileURL;
        [[baseTool getCurrentVC].navigationController pushViewController:PDFReader.share.qlVc animated:YES];
        complete(nil, fileURL);
        [MBProgressHUD hideFromKeyWindow];
    } failed:^(NSError * _Nonnull error) {
        complete(error, nil);
        [MBProgressHUD showTopErrotMessage:@"文件获取出错, 请稍后再试 ~"];
    }];
}

#pragma mark QLPreviewControllerDataSource
//返回文件的个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

//加载需要显示的文件
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.fileUrl;
}

#pragma mark - Getter
- (QLPreviewController *)qlVc{
    if (!_qlVc) {
        _qlVc = [[QLPreviewController alloc] init];
        _qlVc.dataSource = self;
    }
    return _qlVc;
}

@end
