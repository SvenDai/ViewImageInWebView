//
//  DFBrowseImageManager.h
//  ViewImageInWebView
//
//  Created by fdai on 2017/10/14.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DFBrowseImageManager : NSObject


+(instancetype) shareInstance;

/**
  获取webview 中的图片的数量

 @param webView 目标webview
 @return 图片数量
 */
-(int) getImageCountformWebView:(UIWebView*) webView;

/**
 获取webview 中的图片的 url 集合

 @param webView 目标webview
 @return 图片url数组
 */
-(NSArray*) getImageUrlfromWebView:(UIWebView*) webView;


/**
 查看单个图片

 @param url 图片url
 @param view 显示图片view的父view
 @return return 是否拦截图片的点击事件（拦截用来显示，不拦截跳转）
 */
-(BOOL) browseImageWithSingleModel:(NSString*)url parentView:(UIView*) view;

/**
 图片拖拽功能

 @param touches 触摸事件
 */
-(void) addTouchEventtoMoveImage:(NSSet<UITouch *> *)touches;

@end
