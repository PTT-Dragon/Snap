//
//  PublicWebViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "PublicWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WKWebViewJavascriptBridge.h"
#import "CouponCenterViewController.h"
#import "FlashSaleViewController.h"
#import "SFSearchView.h"
#import "MessageViewController.h"
#import "ProductViewController.h"
#import "GroupListViewController.h"
#import "ProductDetailModel.h"
#import "CategoryRankViewController.h"
#import "SceneManager.h"

@interface PublicWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (weak,nonatomic) WKWebView *webView;
@property (nonatomic,weak) WKWebViewConfiguration *configuration;
@property (nonatomic,strong) WKWebViewJavascriptBridge *jsBridge;
@end

@implementation PublicWebViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isHome) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNoTi];
    [self initWebview];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    if ([url containsString:@"/chat/"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KWillEnterChatNotification" object:nil];
    }
}

- (void)initWebview
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.configuration = configuration;
    WKWebView *webview = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, _isHome ? statuBarHei: navBarHei, MainScreen_width, MainScreen_height-(_isHome ? (tabbarHei+statuBarHei): navBarHei)) configuration:_configuration];
    _webView = webview;
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    [webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *newUserAgent = [result stringByAppendingFormat:@" %@",@"app/CYLON-APP"];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUserAgent}];
        webview.customUserAgent = newUserAgent;
    }];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"jsFunc"];
    [self.view addSubview:webview];
    [self addJsBridge];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    MPWeakSelf(self)
    [self jk_backButtonTouched:^(UIViewController *vc) {
        [weakself reset];
        if (weakself.shouldBackToHome) {
            [SceneManager transToHome];
        } else {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)addNoTi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLanguageChangeNotification:)
                                                 name:@"KLanguageChange"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReloadWebviewNotification:)
                                                 name:@"KReloadWebview"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterChatNotification:)
                                                 name:@"KWillEnterChatNotification"
                                               object:nil];
}

- (void)reset {
    if (_webView) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"jsFunc"];
        self.webView.UIDelegate = nil;
        self.webView.navigationDelegate = nil;
        _webView = nil;
        _jsBridge = nil;
    }
}

- (void)willEnterChatNotification:(NSNotification *)noti {
    if (_isHome) {
        MPWeakSelf(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            UserModel *model = [FMDBManager sharedInstance].currentUser;
            NSString *isLogin = [NSString stringWithFormat:@"window.localStorage.setItem('isLogin', '%@')", model ? @"Y" : @"N"];
            NSString *token = [NSString stringWithFormat:@"window.localStorage.setItem('h5Token', '%@')", model.accessToken];
            [self.webView evaluateJavaScript:token completionHandler:nil];
            [self.webView evaluateJavaScript:isLogin completionHandler:^(id _Nullable, NSError * _Nullable error) {
                NSLog(@"");
            }];
        });
    }
}

- (void)setlocalWeb {
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    // 设置localStorage
    NSString *currentLanguage = UserDefaultObjectForKey(@"Language");
    if ([currentLanguage isEqualToString:kLanguageChinese]) {
        currentLanguage = @"zh";
    }
    NSString *language = [NSString stringWithFormat:@"window.localStorage.setItem('USER_LANGUAGE', '%@')", currentLanguage];
    NSString *token = [NSString stringWithFormat:@"window.localStorage.setItem('h5Token', '%@')", model.accessToken];
    NSString *isLogin = [NSString stringWithFormat:@"window.localStorage.setItem('isLogin', '%d')", model ? 1 : 0];
    if ([self.webView.URL.absoluteString containsString:@"/chat/"]) {
        isLogin = [NSString stringWithFormat:@"window.localStorage.setItem('isLogin', '%@')", model ? @"Y" : @"N"];
    }
    [self.webView evaluateJavaScript:token completionHandler:nil];
    [self.webView evaluateJavaScript:isLogin completionHandler:nil];
    [self.webView evaluateJavaScript:language completionHandler:nil];
    [self.jsBridge callHandler:@"functionInJs" data:@{@"name":@"setAppLanguage",@"url":@"", @"params":@{}, @"title":@""}];
}

- (void)receiveLanguageChangeNotification:(NSNotification *)noti {
    // iOS调用js
    [self setlocalWeb];
    
    //清除掉，防止内存泄漏
    [self reset];
}

- (void)receiveReloadWebviewNotification:(NSNotification *)noti
{
//    [self.webView reloadFromOrigin];
}

- (void)addJsBridge {
    _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_jsBridge setWebViewDelegate:self];
//    [_jsBridge registerHandler:@"COUPON" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"1");
//    }];
//    [_jsBridge registerHandler:@"SEARCH" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"2");
//    }];
//    [_jsBridge registerHandler:@"CATG" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"3");
//    }];
//    [_jsBridge registerHandler:@"CUST_PAGE" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"4");
//    }];
//    [_jsBridge registerHandler:@"PROD_DETAIL" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"5");
//    }];
//    [_jsBridge registerHandler:@"FILTER_PRODUCT" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"6");
//    }];
//    [_jsBridge registerHandler:@"FUNCTION_PAGE" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"7");
//    }];
//    [_jsBridge registerHandler:@"FLASH_SHOP_MORE" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"8");
//    }];
//    [_jsBridge registerHandler:@"GROUP_SHOP_MORE" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"9");
//    }];
//    [_jsBridge registerHandler:@"PROD_CLICK" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"10");
//    }];
}
- (void)setIsHome:(BOOL)isHome
{
    _isHome = isHome;
}
#pragma mark - WKNavigationDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary *func = message.body;
    if ([func[@"type"] isEqualToString:@"SEARCH"]) {
        CategoryRankViewController *vc = [[CategoryRankViewController alloc] init];
        vc.activeSearch = YES;
        vc.shouldBackToHome = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([func[@"type"] isEqualToString:@"PROD_DETAIL"]) {
        NSDictionary *dic = func[@"data"];
        ProductViewController *vc = [[ProductViewController alloc] init];
        vc.offerId = [dic[@"offerId"] integerValue];
        vc.productId = [dic[@"productId"] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([func[@"type"] isEqualToString:@"GROUP_SHOP_MORE"]){
//        if (self.pushVc) {[self.navigationController popToViewController:self.pushVc animated:NO];}
//        GroupListViewController *vc = [[GroupListViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#131313\"" completionHandler:nil];
//    [SVProgressHUD showInfoWithStatus:@"正在加载中"];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self setlocalWeb];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    if ([navigationAction.request.URL.absoluteString rangeOfString :@"coupon-center"].location != NSNotFound) {
        if (self.pushVc) {[self.navigationController popToViewController:self.pushVc animated:NO];}
        CouponCenterViewController *vc = [[CouponCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"/spike"].location != NSNotFound){
        if (self.pushVc) {[self.navigationController popToViewController:self.pushVc animated:NO];}
        FlashSaleViewController *vc = [[FlashSaleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    else if ([navigationAction.request.URL.absoluteString rangeOfString :@"/message-center"].location != NSNotFound){
        if (self.pushVc) {[self.navigationController popToViewController:self.pushVc animated:NO];}
        MessageViewController *vc = [[MessageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"/product/detail/"].location != NSNotFound){
        if (self.pushVc) {[self.navigationController popToViewController:self.pushVc animated:NO];}
        NSString *offerId = navigationAction.request.URL.lastPathComponent;
        NSString *productId = nil;
        NSURLComponents *urlComponent = [[NSURLComponents alloc] initWithString:navigationAction.request.URL.absoluteString];
        for (NSURLQueryItem *item in urlComponent.queryItems) {
            if ([item.name isEqualToString:@"productId"]) {
                productId = item.value;
                break;
            }
        }
        ProductViewController *vc = [[ProductViewController alloc] init];
        vc.offerId = offerId.integerValue;
        vc.productId = productId.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
//        [self requestProductInfoWithOfferId:offerId];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"product/GroupBuy"].location != NSNotFound){
        if (self.pushVc) {[self.navigationController popToViewController:self.pushVc animated:NO];}
        GroupListViewController *vc = [[GroupListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
//        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"product/list/"].location != NSNotFound){
        if (self.pushVc) {[self.navigationController popToViewController:self.pushVc animated:NO];}
        NSRange range1 = [navigationAction.request.URL.absoluteString rangeOfString:@"product/list/"];
        NSString *categoryId = @"";
        categoryId = [navigationAction.request.URL.absoluteString substringWithRange:NSMakeRange(range1.location+range1.length, navigationAction.request.URL.absoluteString.length-range1.location-range1.length)];
        CategoryRankViewController *vc = [[CategoryRankViewController alloc] init];
        CategoryModel *model = [[CategoryModel alloc] init];
        CategoryInnerModel *innerModel = [[CategoryInnerModel alloc] init];
        CatgRelaModel *relaModel = [[CatgRelaModel alloc] init];
        ObjValueModel *objModel = [[ObjValueModel alloc] init];
        objModel.objId = categoryId;
        relaModel.objValue = objModel;
        innerModel.catgRela = relaModel;
        model.inner = innerModel;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"search-page"].location != NSNotFound){
        if (self.pushVc) {[self.navigationController popToViewController:self.pushVc animated:NO];}
        CategoryRankViewController *vc = [[CategoryRankViewController alloc] init];
        vc.activeSearch = YES;
        vc.shouldBackToHome = YES;
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
      [webView loadRequest:navigationAction.request];
    }

    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
    
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];

        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

- (void)dealloc {
    [self reset];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //不需要清除缓存，否则会移除掉localStorge
//    if (iOS9) {
//        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//        //// Date from
//        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//        //// Execute
//        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//            // Done
//            NSLog(@"清楚缓存完毕");
//        }];
//    }
}

@end
