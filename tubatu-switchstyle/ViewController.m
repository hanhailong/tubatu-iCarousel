//
//  ViewController.m
//  tubatu-switchstyle
//
//  Created by HailongHan on 15/9/28.
//  Copyright © 2015年 hhl. All rights reserved.
//

#define PAGE_OFFSET 50
// 屏幕宽高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//普通的颜色值
#define UIColorRGB(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
// 随机色
#define RandomColor UIColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#import "ViewController.h"
#import "UIView+Extension.h"
#import "iCarousel.h"

@interface ViewController ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic,strong) iCarousel *iCarousel;

@property (nonatomic,strong) NSMutableArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViews];
}

#pragma mark - 初始化视图View
- (void)setUpViews {
    [self.view addSubview:self.iCarousel];
}

-(iCarousel *)iCarousel{
    CGFloat height = ScreenWidth - 2 *PAGE_OFFSET;
    if (_iCarousel == nil) {
        _iCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, (ScreenHeight-height)*0.5, ScreenWidth, height)];
        _iCarousel.delegate = self;
        _iCarousel.dataSource = self;
        _iCarousel.bounces = NO;
        _iCarousel.pagingEnabled = YES;
        _iCarousel.type = iCarouselTypeCustom;
    }
    return _iCarousel;
}

#pragma mark - 填充数据
- (NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
        [_dataList addObject:[NSString stringWithFormat:@"style_%@.jpg",@"dny"]];
        [_dataList addObject:[NSString stringWithFormat:@"style_%@.jpg",@"dzh"]];
        [_dataList addObject:[NSString stringWithFormat:@"style_%@.jpg",@"jianyue"]];
        [_dataList addObject:[NSString stringWithFormat:@"style_%@.jpg",@"meishi"]];
        [_dataList addObject:[NSString stringWithFormat:@"style_%@.jpg",@"oushi"]];
        [_dataList addObject:[NSString stringWithFormat:@"style_%@.jpg",@"rishi"]];
        [_dataList addObject:[NSString stringWithFormat:@"style_%@.jpg",@"xiandai"]];
        [_dataList addObject:[NSString stringWithFormat:@"style_%@.jpg",@"zhongshi"]];
    }
    return _dataList;
}

#pragma mark - iCarousel代理
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        CGFloat viewWidth = ScreenWidth - 2*PAGE_OFFSET;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
    }
    
    ((UIImageView *)view).image = [UIImage imageNamed:[self.dataList objectAtIndex:index]];
    
    return view;
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.6f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.iCarousel.itemWidth * 1.4, 0.0, 0.0);
}

-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.dataList.count;
}

@end
