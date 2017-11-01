//
//  DFBrowseImageView.m
//  ViewImageInWebView
//
//  Created by fdai on 2017/10/14.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFBrowseImageView.h"
#import "Masonry.h"

@implementation DFBrowseImageView


-(instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


-(void) setupUI{
    [self addSubview:self.browseBackGroundView];
    [self.browseBackGroundView addSubview:self.browseImageView];
    
    [self setSubviewConstraints];
    
    [self setSubViewAction];
}

#pragma mark - set subview action
-(void) setSubViewAction{
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandle:)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    
    [self.browseImageView addGestureRecognizer:pinchGesture];
    [self.browseImageView addGestureRecognizer:tapGesture];
    
}

-(void) pinchGestureHandle:(UIPinchGestureRecognizer*) pGesture{
    if ([self.delegate respondsToSelector:@selector(browsePinchGestureHandle:)]) {
        [self.delegate browsePinchGestureHandle:pGesture];
    }
}

-(void) tapGestureHandle:(UITapGestureRecognizer*)  tGesture{
    if ([self.delegate respondsToSelector:@selector(browseTapGestureHandle:)]) {
        [self.delegate browseTapGestureHandle:tGesture];
    }
}

#pragma mark - set subview constraints
-(void) setSubviewConstraints{
    [self.browseBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(self);
    }];
    
    [self.browseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(self.browseBackGroundView);
    }];
}
#pragma mark - getter
-(UIView*) browseBackGroundView{
    if (!_browseBackGroundView) {
        _browseBackGroundView                   = [[UIView alloc] init];
        _browseBackGroundView.backgroundColor   = [UIColor colorWithRed:33/255 green:33/255 blue:33/255 alpha:0.7];
        
    }
    
    return _browseBackGroundView;
}

-(UIImageView *) browseImageView{
    if (!_browseImageView) {
        _browseImageView                        = [[UIImageView alloc] init];
        _browseImageView.userInteractionEnabled = YES;
        _browseImageView.contentMode            = UIViewContentModeScaleAspectFit;
    }
    return _browseImageView;
}

@end
