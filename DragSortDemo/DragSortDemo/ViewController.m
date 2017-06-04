//
//  ViewController.m
//  DragSortDemo
//
//  Created by xzw on 17/6/4.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "ViewController.h"
#import "ZWDragSortView.h"

@interface ViewController ()
{
    NSInteger k;
}
@property (nonatomic,strong) NSMutableArray * datas;
@property (nonatomic,strong) ZWDragSortView * cutomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40, 20, 80, 30);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"加一个元素" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(addObject) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.datas = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        
        [self.datas  addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    
    ZWDragSortView * view = [ZWDragSortView sortViewWithTitles:self.datas ];
    [view clickBtnActionBack:^(NSInteger index, NSString *title) {
        
        [self.datas removeObjectAtIndex:index];
        self.cutomView.titlesArr = self.datas;
        
    }];
    //view.viewY = 350;
    //view.frame = CGRectMake(30, 30, 230, 200);
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    self.cutomView = view;
    
}

-(void)addObject
{
    k = self.datas.count - 1;
    k++;
    [self.datas  addObject:[NSString stringWithFormat:@"%02ld",k]];
    self.cutomView.titlesArr = self.datas;
    
}
@end
