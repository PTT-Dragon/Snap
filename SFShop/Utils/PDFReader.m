//
//  PDFReader.m
//  SFShop
//
//  Created by YouHui on 2021/12/9.
//

#import "PDFReader.h"
#import <QuickLook/QuickLook.h>
#import "sendToEmailView.h"



@interface PDFReader ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (nonatomic, readwrite, strong) QLPreviewController *qlVc;
@property (nonatomic, readwrite, strong) NSURL *fileUrl;
@property (nonatomic,copy) NSString *orderId;
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

+ (void)readPDF:(NSString *)url orderId:(NSString *)orderId complete:(void(^)(NSError *_Nullable error, NSURL *_Nullable fileUrl))complete {
    //[MBProgressHUD showHudMsg:@""];
    [SFNetworkManager downloadPDF:url success:^(NSURL *fileURL) {
        PDFReader.share.fileUrl = fileURL;
        [PDFReader share].orderId = orderId;
        [PDFReader share].qlVc = nil;
        [[baseTool getCurrentVC].navigationController pushViewController:PDFReader.share.qlVc animated:YES];
//        [[baseTool getCurrentVC] addChildViewController:PDFReader.share.qlVc];
//        PDFReader.share.qlVc.view.frame = [baseTool getCurrentVC].view.bounds;
//        [[baseTool getCurrentVC].view addSubview:PDFReader.share.qlVc.view];
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
        _qlVc.delegate = self;
        UIButton *ab = [UIButton buttonWithType:UIButtonTypeCustom];
        ab.backgroundColor = RGBColorFrom16(0xff1659);
        [ab setTitle:kLocalizedString(@"SEND_TO_EMAIL") forState:0];
        [ab setTitleColor:[UIColor whiteColor] forState:0];
        ab.titleLabel.font = kFontBlod(14);
        [_qlVc.view addSubview:ab];
        @weakify(self)
        [[ab rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            sendToEmailView *view = [[NSBundle mainBundle] loadNibNamed:@"sendToEmailView" owner:self options:nil].firstObject;
            view.orderId = [PDFReader share].orderId;
            view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
            [[baseTool getCurrentVC].view addSubview:view];
        }];
        [ab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.bottom.mas_equalTo(_qlVc.view.mas_bottom).offset(-20);
            make.height.mas_equalTo(44);
        }];
    }
    return _qlVc;
}

@end
