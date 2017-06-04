//
//  ZWDragSortView.h
//  SortViewDemo
//
//  Created by xzw on 17/5/11.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZWClickBtnBlock)(NSInteger index,NSString * title);

@interface ZWDragSortView : UIScrollView

@property (nonatomic,strong) NSMutableArray * titlesArr;//按钮显示数组
@property (nonatomic,assign) CGFloat  columnMargin;//按钮间隔
@property (nonatomic,assign) NSInteger  columnCount;//按钮列数
@property (nonatomic,strong) UIColor * titlesColor;//设置按钮文字颜色
@property (nonatomic,strong) UIColor * btnBackgroundColor;//设置按钮背景颜色
@property (nonatomic,assign) CGFloat  tagHeight;//设置按钮标签高度
@property (nonatomic,strong) UIFont * titleFont;//设置按钮文字字体大小
@property (nonatomic,assign) CGFloat  viewY;//直接设置控件的y值即可食用
@property (nonatomic,assign) BOOL  isDragEnable;//长按拖拽使能,默认开启

//初始化
+(instancetype)sortViewWithTitles:(NSMutableArray*)titles;

//点击标签回调
-(void)clickBtnActionBack:(ZWClickBtnBlock)block;

@end
