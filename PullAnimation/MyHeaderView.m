//
//  MyHeaderView.m
//  PullAnimation
//
//  Created by caokun on 16/10/29.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import "MyHeaderView.h"
#import "Masonry.h"

@interface MyHeaderView ()

@property (strong, nonatomic) UIImageView *imageV;          // 随便放一个 imageView
@property (assign, nonatomic) CGFloat headerViewHeight;     // headerView 高度
@property (assign, nonatomic) CGFloat screenWidth;

@end

@implementation MyHeaderView

- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_Default"]];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        _imageV.userInteractionEnabled = true;
        [_imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)]];
    }
    return _imageV;
}

- (void)imageViewTapAction:(id)sender {
    NSLog(@"imageView tap");
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.headerViewHeight = 180;
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        [self addSubview:self.imageV];
    }
    return self;
}

// 更改 frame 会触发 layoutSubviews
// 触发 layoutSubviews 后，这个 view 里面的控件想怎么变（旋转，位移，缩放），全部这个方法里面就好了
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // imageV 是 60 * 60 的
    CGFloat y = 60 + (self.frame.size.height - self.headerViewHeight) * 0.6;
    self.imageV.frame = CGRectMake((self.screenWidth - 60) * 0.5, y, 60, 60);
    
    [self setNeedsDisplay];     // 重绘
}

// 绘制曲线
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.00392, 0.54117, 0.85098, 1.0);
    
    CGFloat h1 = self.headerViewHeight;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGContextMoveToPoint(context, w, h1);
    CGContextAddLineToPoint(context, w, 0);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, h1);
    CGContextAddQuadCurveToPoint(context, w * 0.5, h + (h - h1) * 0.6, w, h1);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFill);
}

// 这个 view 里面有多少个被点击的控件，把他的 frame 告诉 pointInside 就可以了
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 判断点击的点，在不在圆内
    CGPoint center = self.imageV.center;
    CGFloat r = self.imageV.frame.size.width * 0.5;
    CGFloat newR = sqrt((center.x - point.x) * (center.x - point.x) + (center.y - point.y) * (center.y - point.y));
    
    // 浮点数比较不推荐用等号，虽然 ios 底层已经处理了这种情况
    if (newR > r) {
        return false;
    } else {
        return true;
    }
}

@end
