//
//  ViewController.m
//  ViewImageInWebView
//
//  Created by fdai on 2017/10/5.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "DFBrowseImageManager.h"

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>{
    UIView      *bgView;
    UIImageView *imgView;
}

@property(nonatomic,strong) UIWebView   *webView;

//@property(nonatomic,strong) UIView      *bgView;

@property(nonatomic,assign) CGFloat     lastScale;

@property(nonatomic,assign) CGFloat     maxScale;
@property(nonatomic,assign) CGFloat     minScale;

@property(nonatomic,strong) DFBrowseImageManager    *biManager;

@property(nonatomic,strong) NSArray                 *imgArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //_biManager = [[DFBrowseImageManager alloc] init];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://download2.ctrip.com/ChengguanjiaRes/ipub/79/1502073223527messageaction.html"]];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
    [self initScale];
}

-(void) initScale{
    self.lastScale  = (CGFloat) 1.0;
    self.maxScale   = (CGFloat) 3.0;
    self.minScale   = (CGFloat) 1.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
-(void) webViewDidStartLoad:(UIWebView *)webView{

}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    //_biManager = [[DFBrowseImageManager alloc] init];
    [[DFBrowseImageManager shareInstance] getImageCountformWebView:webView];
    self.imgArray =  [[DFBrowseImageManager shareInstance] getImageUrlfromWebView:webView];
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return [[DFBrowseImageManager shareInstance] browseImageWithSingleModel:[[request URL] absoluteString] parentView:self.view];

//    //将url转换为string
//    NSString *requestString = [[request URL] absoluteString];
//    //    NSLog(@"requestString is %@",requestString);
//    
//    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
//    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
//        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
//        //        NSLog(@"image url------%@", imageUrl);
//        
//        if (bgView) {
//            //设置不隐藏，还原放大缩小，显示图片
//            //bgView.hidden = NO;
//            //imgView.frame = CGRectMake(10, 10, SCREEN_WIDTH-40, 220);
//            [self removeBigImage];
//            [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"house_moren"]];
//        }
//        else{
//            [self showBigImage:imageUrl];//创建视图并显示图片
//        }
//        return NO;
//    }
//    return YES;
}

#pragma mark 显示大图片
//-(void)showBigImage:(NSString *)imageUrl{
//    //创建灰色透明背景，使其背后内容不可操作
//    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [bgView setBackgroundColor:[UIColor colorWithRed:33/255 green:33/255 blue:33/255 alpha:0.7]];
//    self->bgView.alpha = 0.2;
//    [self.view addSubview:bgView];
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        // 执行动画
//        self->bgView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        // 动画完成做什么事情
//    }];
//    //创建显示图像视图
//    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(bgView.frame)-20, CGRectGetHeight(bgView.frame)-20)];
//    imgView.userInteractionEnabled = YES;
//    imgView.contentMode = UIViewContentModeScaleAspectFit;
//    imgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//    
//    [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"house_moren"]];
//    [bgView addSubview:imgView];
//    
//    //添加捏合手势
//    UIPinchGestureRecognizer *pingesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
//    [imgView addGestureRecognizer:pingesture];
//    pingesture.delegate = self;
//    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBigImage)];
//    [imgView addGestureRecognizer:gesture];
//    
//}

#pragma mark - UIPinchGestureRecognizer
//实现关闭和捏合手势的方法
//关闭按钮
//-(void)removeBigImage
//{
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        // 执行动画
//        self->bgView.alpha = 0.2;
//    } completion:^(BOOL finished) {
//        // 动画完成做什么事情
//        [UIView animateWithDuration:0.2 animations:^{
//            self->bgView.alpha = 1.0;
//            bgView.hidden = bgView.hidden? NO:YES;
//            //[self setDefaultAnchorPointforView:self->imgView];
//        }];
//    }];
//    
//}

//- (void) handlePinch:(UIPinchGestureRecognizer*) gr{
//    if (gr.state == UIGestureRecognizerStateBegan) {
//        
//    CGPoint onoPoint = [gr locationOfTouch:0 inView:gr.view];
//    CGPoint twoPoint = [gr locationOfTouch:1 inView:gr.view];
//    
//    CGPoint anchorPoint;
//    anchorPoint.x = (onoPoint.x + twoPoint.x) / 2 / gr.view.bounds.size.width;
//    anchorPoint.y = (onoPoint.y + twoPoint.y) / 2 / gr.view.bounds.size.height;
//    
//    [self setAnchorPoint:anchorPoint forView:gr.view];
//
//    }
//    if (gr.state == UIGestureRecognizerStateBegan || gr.state == UIGestureRecognizerStateChanged) {
//        
//        _lastScale = self.lastScale;
//        float nowScale = (_lastScale -1) +gr.scale;
//        nowScale = MAX(nowScale, self.minScale);
//        [UIView animateWithDuration:0.5 animations:^{
//            gr.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, nowScale , nowScale);
//        }];
//    }
//    if ((gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateFailed || gr.state == UIGestureRecognizerStateCancelled) ) {
//        [self setDefaultAnchorPointforView:self->imgView];
//    }
//}


-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[DFBrowseImageManager shareInstance] addTouchEventtoMoveImage:touches];
//    // 拿到UITouch就能获取当前点
//    UITouch *touch = [touches anyObject];
//    // 获取当前点
//    CGPoint curP = [touch locationInView:self->imgView];
//    // 获取上一个点
//    CGPoint preP = [touch previousLocationInView:self->imgView];
//    // 获取手指x轴偏移量
//    CGFloat offsetX = curP.x - preP.x;
//    // 获取手指y轴偏移量
//    CGFloat offsetY = curP.y - preP.y;
//    // 移动当前view
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self->imgView.transform = CGAffineTransformTranslate(self->imgView.transform, offsetX, offsetY);
//    } completion:^(BOOL finshed){
//    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            //self->imgView.transform = CGAffineTransformTranslate(self->imgView.transform, 0, 0);
//            CGRect frame = self->imgView.frame;
//            frame.origin.x = 10;
//            self->imgView.frame = frame;
//            
//            //self->imgView.center.y = SCREEN_HEIGHT/2;
//            
//        }completion:nil];
//    }];
}

//- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
//{
//    CGPoint oldOrigin = view.frame.origin;
//    view.layer.anchorPoint = anchorPoint;
//    CGPoint newOrigin = view.frame.origin;
//    
//    CGPoint transition;
//    transition.x = newOrigin.x - oldOrigin.x;
//    transition.y = newOrigin.y - oldOrigin.y;
//    
//    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
//}
//
//- (void)setDefaultAnchorPointforView:(UIView *)view
//{
//    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
//}
#pragma mark - getter
-(UIWebView*)webView{
    if (!_webView) {
        _webView            = [[UIWebView alloc] init];
        _webView.frame      = self.view.frame;
        _webView.delegate   = self;
    }
    return _webView;
}

@end
