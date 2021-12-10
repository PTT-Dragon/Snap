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

@interface PublicWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (weak,nonatomic) WKWebView *webView;
@property (nonatomic,weak) WKWebViewConfiguration *configuration;
@property (nonatomic,strong) WKWebViewJavascriptBridge *jsBridge;
@end

@implementation PublicWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.configuration = configuration;
    WKWebView *webview = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height-navBarHei) configuration:_configuration];
    _webView = webview;
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    UserModel *model = [FMDBManager sharedInstance].currentUser;
//    NSString * userContent = [NSString stringWithFormat:@"h5Token:%@",model.accessToken];
    // 设置localStorage
    NSString *jsString = [NSString stringWithFormat:@"localStorage.setItem('h5Token', '%@')", model.accessToken];
    // 移除localStorage
    // NSString *jsString = @"localStorage.removeItem('userContent')";
    // 获取localStorage
    // NSString *jsString = @"localStorage.getItem('userContent')";
    [self.webView evaluateJavaScript:jsString completionHandler:nil];
//    NSString *jsFounction = [NSString stringWithFormat:@"sysAccount('%@')", _sysAccount];
//    [self.webView evaluateJavaScript:jsFounction completionHandler:nil];
    [webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *newUserAgent = [result stringByAppendingFormat:@"/%@",@"app/CYLON-APP"];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUserAgent}];
    }];
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self addJsBridge];
}
- (void)addJsBridge
{
    _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    [_jsBridge setWebViewDelegate:self];
    [_jsBridge registerHandler:@"COUPON" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
}
#pragma mark - WKNavigationDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
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
    //iOS调用js
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
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
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    if ([navigationAction.request.URL.absoluteString isEqualToString:@"https://www.smartfrenshop.com/coupon-center"]) {
        CouponCenterViewController *vc = [[CouponCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString isEqualToString:@"https://www.smartfrenshop.com/search-page"]){
        
    }else if ([navigationAction.request.URL.absoluteString isEqualToString:@"https://www.smartfrenshop.com/spike"]){
        FlashSaleViewController *vc = [[FlashSaleViewController alloc] init];
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
- (void)dealloc
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"openBankCardDialog"];

    if (iOS9) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            NSLog(@"清楚缓存完毕");
            
        }];
    }
    
}

@end
