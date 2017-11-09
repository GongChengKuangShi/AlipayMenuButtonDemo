//
//  SingleView.m
//  AlipayMenuButtonDemo
//
//  Created by xrh on 2017/11/8.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import "SingleView.h"

@interface SingleView ()

@property(strong, nonatomic) UILabel *label;

@end

@implementation SingleView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.title = title;
        [self initWithLabel];
    }
    return self;
}

- (void)initWithLabel {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-50)];
    label.text = _title;
    label.userInteractionEnabled = YES;//启动用户交互
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    [self addSubview:label];
    _label = label;
    
    //长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(viewLongPressGesture:)];
    [self addGestureRecognizer:longGesture];
    
    //点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
}

#pragma mark -- 长安手势事件
- (void)viewLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
            //移动前
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(beginMoveAction:)]) {
                _label.textColor = [UIColor redColor];
                [self.delegate beginMoveAction:self.tagId];
            }
            break;
            //移动中
        case UIGestureRecognizerStateChanged:
            if ([self.delegate respondsToSelector:@selector(moveViewAction:gesture:)]) {
                [self.delegate moveViewAction:self.tagId gesture:gesture];
            }
            break;
            
            //移动后
        case UIGestureRecognizerStateEnded:
            if ([self.delegate respondsToSelector:@selector(endMoveViewAction:)]) {
                _label.textColor = [UIColor grayColor];
                [self.delegate endMoveViewAction:self.tagId];
            }
            break;
        default:
            break;
    }
}

- (void)viewTapGesture:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(clickOneViewReturnTitle:)]) {
        [self.delegate clickOneViewReturnTitle:_title];
    }
}

@end
