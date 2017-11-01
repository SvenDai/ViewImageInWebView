//
//  DFBrowseImageManager.m
//  ViewImageInWebView
//
//  Created by fdai on 2017/10/14.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFBrowseImageManager.h"
#import "DFBrowseImageView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface DFBrowseImageManager ()<DFBrowseImageViewDelegate>

@property(nonatomic,strong) DFBrowseImageView *browseView;

@end

@implementation DFBrowseImageManager

+(instancetype) shareInstance{
    static DFBrowseImageManager * biManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        biManager = [[DFBrowseImageManager alloc] init];
    });
    return biManager;
}

-(int) getImageCountformWebView:(UIWebView*)webView {
    
    if (webView) {
        static  NSString * const getImagesCountJS =
        @"function getImages(){\
            var objs = document.getElementsByTagName(\"img\");\
            for(var i = 0;i<objs.length;i++){\
                objs[i].onclick = function(){\
                    document.location = \"myweb:imageClick:\"+this.src;\
                };\
            };\
            return objs.length;\
        };";
        
        [webView stringByEvaluatingJavaScriptFromString:getImagesCountJS];
        int imgCount = [[webView stringByEvaluatingJavaScriptFromString:@"getImages()"] intValue];
        //NSLog(@"<%@, %s, %i>",self.class,__func__,imgCount);
        
        return imgCount;
    }else {
        NSLog(@"<%@, %s, %@>",self.class,__func__,@"Can't find a webView");
        return 0;
    }
}


-(NSArray*) getImageUrlfromWebView:(UIWebView*) webView{
    if (webView) {
        static  NSString * const getImagesUrlJS =
        @"function getImageUrl(){\
            var objs = document.getElementsByTagName(\"img\");\
            var imgSrc = '';\
            for(var i = 0;i<objs.length;i++){\
                imgSrc = imgSrc + objs[i].src +'+';\
            }\
            return imgSrc;\
        };";
        
        [webView stringByEvaluatingJavaScriptFromString:getImagesUrlJS];
        NSString* imgUrls = [webView stringByEvaluatingJavaScriptFromString:@"getImageUrl();"];
        //NSLog(@"<%@, %s, %@>",self.class,__func__,imgUrls);
        return [NSArray arrayWithArray:[imgUrls componentsSeparatedByString:@"+"]];
    }else {
        NSLog(@"<%@, %s, %@>",self.class,__func__,@"cant't find a webview");
        return @[];
    }
}

-(void) addTouchEventtoMoveImage:(NSSet<UITouch *> *)touches{
        // 拿到UITouch就能获取当前点
        UITouch *touch = [touches anyObject];
        // 获取当前点
        CGPoint curP = [touch locationInView:self.browseView.browseImageView];
        // 获取上一个点
        CGPoint preP = [touch previousLocationInView:self.browseView.browseImageView];
        // 获取手指x轴偏移量
        CGFloat offsetX = curP.x - preP.x;
        // 获取手指y轴偏移量
        CGFloat offsetY = curP.y - preP.y;
        // 移动当前view
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.browseView.browseImageView.transform = CGAffineTransformTranslate(self.browseView.browseImageView.transform, offsetX, offsetY);
        } completion:^(BOOL finshed){
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                //self->imgView.transform = CGAffineTransformTranslate(self->imgView.transform, 0, 0);
//                CGRect frame = self.browseView.browseImageView.frame;
//                frame.origin.x = 10;
//                self.browseView.browseImageView.frame = frame;
            }completion:nil];
        }];
}

-(BOOL) browseImageWithSingleModel:(NSString*)url parentView:(UIView*) view {
    //将url转换为string
    NSString *requestString = url;
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        if (_browseView) {
            [self removeBigImage];
            [self.browseView.browseImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"house_moren"]];
        }
        else{
            [self showBigImage:imageUrl inParentView:view];//创建视图并显示图片
        }
        return NO;
    }
    return YES;

}

#pragma mark - DFBrowseImageViewDelegate
-(void) browseTapGestureHandle:(UITapGestureRecognizer *)tapGesture{
    [self removeBigImage];
}

-(void) browsePinchGestureHandle:(UIPinchGestureRecognizer *)pinchGesture{
    [self handlePinch:pinchGesture];
}

#pragma mark - private method
-(void)showBigImage:(NSString *)imageUrl inParentView:(UIView*) view{
    [view addSubview:self.browseView];
    [self.browseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(view);
    }];
    
    [self.browseView.browseImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.browseView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

//关闭按钮
-(void)removeBigImage
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        // 执行动画
        self.browseView.alpha = 0.2;
    } completion:^(BOOL finished) {
        // 动画完成做什么事情
        [UIView animateWithDuration:0.2 animations:^{
            self.browseView.alpha = 1.0;
            self.browseView.hidden = self.browseView.hidden? NO:YES;
            //[self setDefaultAnchorPointforView:self.browseView.browseImageView];
        }];
    }];
    
}

- (void) handlePinch:(UIPinchGestureRecognizer*) gr{
    if (gr.state == UIGestureRecognizerStateBegan) {
        
        CGPoint onoPoint = [gr locationOfTouch:0 inView:gr.view];
        CGPoint twoPoint = [gr locationOfTouch:1 inView:gr.view];
        
        CGPoint anchorPoint;
        anchorPoint.x = (onoPoint.x + twoPoint.x) / 2 / gr.view.bounds.size.width;
        anchorPoint.y = (onoPoint.y + twoPoint.y) / 2 / gr.view.bounds.size.height;
        
        [self setAnchorPoint:anchorPoint forView:gr.view];
        
    }
    if (gr.state == UIGestureRecognizerStateBegan || gr.state == UIGestureRecognizerStateChanged) {
        
//        _lastScale = self.lastScale;
//        float nowScale = (_lastScale -1) +gr.scale;
//        nowScale = MAX(nowScale, self.minScale);
        [UIView animateWithDuration:0.5 animations:^{//CGAffineTransformIdentity
            gr.view.transform = CGAffineTransformScale(gr.view.transform, gr.scale, gr.scale);
            gr.scale = 1;
        }];
    }
    if ((gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateFailed || gr.state == UIGestureRecognizerStateCancelled) ) {
        [self setDefaultAnchorPointforView:self.browseView.browseImageView];
    }
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)setDefaultAnchorPointforView:(UIView *)view
{
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}

#pragma mark - getter
-(DFBrowseImageView*) browseView{
    if (!_browseView) {
        _browseView = [[DFBrowseImageView alloc] init];
        _browseView.delegate = self;
    }
    return _browseView;
}
@end
