//
//  ZWDragSortView.m
//  SortViewDemo
//
//  Created by xzw on 17/5/11.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ZWDragSortView.h"

#define Defalut_columnCount 3
#define Defalut_columnMargin 10
#define Defalut_btnH 40
#define Defalut_font 17


@interface ZWDragSortView ()
{
    ZWClickBtnBlock _block;
}
@property (nonatomic,strong) NSMutableArray * btnArr;
@property (nonatomic,strong) NSMutableArray * gestureArr;
@property (nonatomic,strong) UIView * contentView;

@property (nonatomic,assign) CGPoint  startP;

@property (nonatomic,assign) CGPoint  buttonP;
/**
 *  显示所有按钮后，自定义view实际需要高度
 */
@property (nonatomic,assign) CGFloat  lastH;

@end
@implementation ZWDragSortView

-(UIView *)contentView
{
    if (!_contentView) {
        
        _contentView = [[UIView alloc] init];
    }
    
    return _contentView;
}

-(NSMutableArray *)btnArr
{
    if (!_btnArr) {
        
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

-(NSMutableArray *)gestureArr
{
    if (!_gestureArr) {
        
        _gestureArr = [NSMutableArray array];
    }
    return _gestureArr;
}

+(instancetype)sortView
{
    ZWDragSortView * sView = [[ZWDragSortView alloc] init];
    sView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    sView.showsVerticalScrollIndicator = NO;
    sView.showsHorizontalScrollIndicator = NO;
    sView.backgroundColor = [UIColor clearColor];
    return sView;
}

+(instancetype)sortViewWithTitles:(NSMutableArray *)titles
{
    ZWDragSortView * sView = [ZWDragSortView sortView];
    [sView initContentView];
    sView.titlesArr = titles;
    return sView;
}

-(void)initContentView
{
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
}

-(void)initButtons
{
    if (!_titlesArr.count) return;
    for (NSInteger i = 0; i < _titlesArr.count; i++) {
        
        UIButton * titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.backgroundColor = [UIColor redColor];
        [titleBtn setTitle:_titlesArr[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:Defalut_font];
        titleBtn.layer.cornerRadius = 8;
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:titleBtn];
        [self.btnArr addObject:titleBtn];
        
        //添加长按手势
        UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [self.gestureArr addObject:recognizer];
        [titleBtn addGestureRecognizer:recognizer];
        
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
       // [self setBtnFrame];
        
    });
}

//按钮九宫格布局
-(void)setBtnFrame
{
    if (_columnCount == 0) {_columnCount = Defalut_columnCount;}
    if (_columnMargin == 0) {_columnMargin = Defalut_columnMargin;}
    if (_tagHeight == 0) {_tagHeight = Defalut_btnH;}
    
    CGFloat btnH = _tagHeight;
    CGFloat btnW = (self.frame.size.width - (_columnCount + 1)*_columnMargin)/_columnCount;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    for (NSInteger i = 0; i < _btnArr.count; i++) {
        
        NSInteger column = i % _columnCount;
        NSInteger row = i / _columnCount;
        btnX = _columnMargin + (btnW + _columnMargin) * column;
        btnY = _columnMargin + (btnH + _columnMargin) * row;
        
        UIButton * btn = _btnArr[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        if (i == _titlesArr.count-1) {
            
            CGRect contentRect = self.contentView.frame;
            CGRect selfRect = self.frame;
            
            _lastH = CGRectGetMaxY(btn.frame) + _columnMargin;
            
            contentRect.size.height = _lastH;
            self.contentView.frame = contentRect;
            
            //判断控件y值＋内容高度是否超出屏幕
            
            if ((selfRect.origin.y + _lastH <= [UIScreen mainScreen].bounds.size.height)) {
                
                selfRect.size.height = _lastH;
                
            }
            else
            {
                 selfRect.size.height = [UIScreen mainScreen].bounds.size.height - selfRect.origin.y;
            }
          
            self.frame = selfRect;
            self.contentSize = CGSizeMake(self.frame.size.width, _lastH);
            [self scrollsToBottomAnimated:YES];
            
        }
        
    }
    
}

-(void)longPress:(UIGestureRecognizer *)longPress
{
    UIButton * currentBtn = (UIButton *)longPress.view;
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            currentBtn.transform = CGAffineTransformScale(currentBtn.transform, 1.2, 1.2);
            currentBtn.alpha = 0.7f;
            _startP = [longPress locationInView:currentBtn];
            _buttonP = currentBtn.center;
            
        }];
    }
    if (longPress.state == UIGestureRecognizerStateChanged) {
        
        CGPoint newP = [longPress locationInView:currentBtn];
        CGFloat movedX = newP.x - _startP.x;
        CGFloat movedY = newP.y - _startP.y;
        currentBtn.center = CGPointMake(currentBtn.center.x + movedX, currentBtn.center.y + movedY);
        
        //获取当前按钮索引
        NSInteger fromIndex = currentBtn.tag;
        //获取目标移动索引
        NSInteger toIndex = [self getMovedIndexByCurrentButton:currentBtn];
        
        if (toIndex < 0) {
            return;
        }else
        {
            currentBtn.tag = toIndex;
            //按钮向后移动
            if (fromIndex < toIndex) {
                
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    
                    //拿到下一个按钮
                    UIButton * nextBtn = self.btnArr[i+1];
                    CGPoint tempP = nextBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextBtn.center = _buttonP;
                    }];
                    _buttonP = tempP;
                    nextBtn.tag = i;
                }
                
                [self sortArray];
                
            }else if (fromIndex > toIndex){ //按钮向前移动
                
                for (NSInteger i = fromIndex; i > toIndex; i--) {
                    
                    //拿到上一个按钮
                    UIButton * previousBtn = self.btnArr[i-1];
                    CGPoint tempP = previousBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        previousBtn.center = _buttonP;
                    }];
                    _buttonP = tempP;
                    previousBtn.tag = i;
                }
                
                [self sortArray];
            
            }
        }
        
        
    }
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.2 animations:^{
           
            currentBtn.transform = CGAffineTransformIdentity;
            currentBtn.alpha = 1.0f;
            currentBtn.center = _buttonP;
            
        }];
    }
    
}

-(void)setTitlesColor:(UIColor *)titlesColor
{
    _titlesColor = titlesColor;
    for (UIButton * btn in _btnArr) {
        [btn setTitleColor:titlesColor forState:UIControlStateNormal];
    }
}

-(void)setBtnBackgroundColor:(UIColor *)btnBackgroundColor
{
    _btnBackgroundColor = btnBackgroundColor;
    for (UIButton * btn in _btnArr) {
        
        btn.backgroundColor = btnBackgroundColor;
    }
}

-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    for (UIButton * btn in _btnArr) {
        btn.titleLabel.font = titleFont;
    }
}

-(void)sortArray
{
    //对已改变按钮的数组进行排序
    [_btnArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        UIButton * temp1 = (UIButton *)obj1;
        UIButton * temp2 = (UIButton *)obj2;
        return temp1.tag > temp2.tag;//将tag值大的向后移
        
    }];
    
}


//获取按钮移动目标索引
-(NSInteger)getMovedIndexByCurrentButton:(UIButton*)currentBtn
{
    for (NSInteger i = 0; i < self.btnArr.count; i++) {
        UIButton * btn = self.btnArr[i];
        
        if (btn != currentBtn) {
            if (CGRectContainsPoint(btn.frame, currentBtn.center)) {
                return i;
            }
        }
    }
    return -1;
}

//设置控件Y值
-(void)setViewY:(CGFloat)viewY
{
    _viewY = viewY;
    CGRect rect = self.frame;
    rect.origin.y = viewY;
    self.frame = rect;
    
    [self setBtnFrame];
}

//拖拽功能使能
-(void)setIsDragEnable:(BOOL)isDragEnable
{
    _isDragEnable = isDragEnable;
    
    for (int i = 0; i < _btnArr.count; i++) {
        
        UIButton * btn = _btnArr[i];
        UILongPressGestureRecognizer * ges = _gestureArr[i];
        [btn removeGestureRecognizer:ges];
    }
    
}

//更新标签，重新布局
-(void)setTitlesArr:(NSMutableArray *)titlesArr
{
    _titlesArr = titlesArr;
    
    [self.btnArr removeAllObjects];
    for (UIView * subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
        
    [self initButtons];
    [self setBtnFrame];
    
}

//点击按钮事件回调
-(void)clickBtnActionBack:(ZWClickBtnBlock)block
{
    _block = block;
    
}

//按钮点击事件
-(void)clickBtn:(UIButton*)btn
{
    !_block ?:_block(btn.tag,btn.titleLabel.text);
}


//自动滚动底部
- (void)scrollsToBottomAnimated:(BOOL)animated
{
    CGFloat offset = self.contentSize.height - self.bounds.size.height;
    if (offset > 0)
    {
        [self setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}




@end
