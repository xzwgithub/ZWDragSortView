# ZWDragSortView
自适应标签拖拽排序

# 功能

   适用于有标签拖拽自动排序需求的人使用，该封装最大的特点是自适应，只要外部传入需要显示的标签数组，就可以自动计算该自定义view的高度，不会有多余的空白。当显示的标签数量很大，显示高度超过屏幕，可以支持滚动。可以手动添加标签数量，点击标签支持删除，高度自适应不用额外处理。
   
# 文件结构

该封装只有ZWDragSortView.h和ZWDragSortView.m两个文件。

ZWDragSortView.h头文件定义如下：

```
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

```
titlesArr属性用于标签变化的时候重新布局使用；支持自定义按钮列数，按钮间隔，不赋值使用默认值；支持按钮文字颜色、字体大小，控件背景色设置，支持长按拖拽功能关闭，外部传入viewY值可以改变控件竖直方向位置，也可以自定义控件frame。

# 用法

引入ZWDragSortView.h头文件，

```
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
    
```
外部传入一个字符串数组，用类方法sortViewWithTitles:创建对象,可以设置各种参数，也可以不设置，直接addSubview。clickBtnActionBack方法用于点击标签回调事件结果，没有点击标签需求可以忽略。viewY用于设置控件的位置，默认y值是64，宽度是屏幕宽度，也可以自定义控件宽高。

 # 演示效果
 ![image](https://github.com/xzwgithub/ZWDragSortView/blob/master/DragSortDemo/DragSortDemo/demo演示.gif)
 
 

