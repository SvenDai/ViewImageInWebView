//
//  DFBrowseImageView.h
//  ViewImageInWebView
//
//  Created by fdai on 2017/10/14.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@protocol DFBrowseImageViewDelegate <NSObject>

-(void) browsePinchGestureHandle:(UIPinchGestureRecognizer*) pinchGesture;

-(void) browseTapGestureHandle:(UITapGestureRecognizer*) tapGesture;

@end

@interface DFBrowseImageView : UIView

@property(nonatomic,weak) id<DFBrowseImageViewDelegate> delegate;

@property(nonatomic,strong) UIView      *browseBackGroundView;

@property(nonatomic,strong) UIImageView *browseImageView;

@end
