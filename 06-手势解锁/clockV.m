//
//  clockV.m
//  06-手势解锁
//
//  Created by 张灿 on 16/3/21.
//  Copyright © 2016年 张灿. All rights reserved.
//

#import "clockV.h"

@interface clockV ()

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, assign) CGPoint curP;

@end

@implementation clockV

//懒加载
- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUp];
        
    }
    return self;
}


- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO; //这一步不能忘!!!
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [self addSubview:btn];
        
    }
    
}

//获取当前点
- (CGPoint)getCurP:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    return curP;
}

//判断点在不在按钮上
- (UIButton *)btnContainsCurP:(CGPoint)curP
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, curP)) {
            return btn;
        }
    }
    return nil;
}

//开始触摸
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取当前点
    CGPoint curP = [self getCurP:touches];
    
    //判断在不在按钮上
    UIButton *btn = [self btnContainsCurP:curP];
    
    //在的话设置按钮为被选择状态
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectArray addObject:btn];
    }
}

//移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取当前点
    CGPoint curP = [self getCurP:touches];
    
    self.curP = curP;
    
    //判断在不在按钮上
    UIButton *btn = [self btnContainsCurP:curP];
    
    //在的话设置按钮为被选择状态
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectArray addObject:btn];
    }
    
    [self setNeedsDisplay];//重绘要放在外面
}

//手指俩开
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //移除所有选择,删除所有线条
    for (UIButton *btn in self.selectArray) {
        btn.selected = NO;
    }
    [self.selectArray removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

//绘制路径
- (void)drawRect:(CGRect)rect
{
    if (self.selectArray.count) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectArray.count; i++) {
            //取出按钮
            UIButton *btn = self.selectArray[i];
            if (i == 0) {
                [path moveToPoint:btn.center];
            }else {
                [path addLineToPoint:btn.center];
            }
        }
        [path addLineToPoint:self.curP];
        //颜色
        [[UIColor redColor] set];
        //线宽
        [path setLineWidth:10];
        //连接样式
        [path setLineJoinStyle:kCGLineJoinRound];
        
        
        [path stroke];
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat wh = 74;
    int colnum = 3;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat space = (self.bounds.size.width - wh * colnum) / (colnum + 1);
    CGFloat curCol = 0;
    CGFloat curRow = 0;
    
    for (int i = 0; i < self.subviews.count; i++) {
        //取出按钮
        UIButton *btn = self.subviews[i];
        //列号
        curCol = i % colnum;
        curRow = i / colnum;
        x = space + (wh + space) * curCol;
        y = space + (wh + space) * curRow;
        btn.frame = CGRectMake(x, y, wh, wh);
        
    }
}
@end
