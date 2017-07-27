//
//  ADView.m
//  ProjectGenericFramework
//
//  Created by joe on 2017/7/26.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "ADView.h"
@interface ADView()


/**
 广告显示图片imageView
 */
@property (nonatomic, strong) UIImageView *aDImageView;
/**
 跳过btn
 */
@property (nonatomic, strong) UIButton *skipBtn;
/**
 计时器
 */
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int count;

@property (nonatomic, copy) TapBlock tapBlock;

@end

@implementation ADView

static int const showTime = 5;
/**
 启动广告页面
 */
static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame tapBlock:(TapBlock)tapBlock {
    if (self = [super initWithFrame:frame]) {
        
        // 1.广告图片
        self.aDImageView = [[UIImageView alloc] initWithFrame:frame];
        self.aDImageView.userInteractionEnabled = YES;
        self.aDImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.aDImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [self.aDImageView addGestureRecognizer:tap];
        
        // 2.跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        self.skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - btnW - 24, btnH, btnW, btnH)];
        [self.skipBtn addTarget:self action:@selector(skipBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过%d", showTime] forState:UIControlStateNormal];
        self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.skipBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        self.skipBtn.layer.cornerRadius = 4;
        
        [self addSubview:self.aDImageView];
        [self addSubview:self.skipBtn];
        
        // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
        NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
        
        BOOL isExist = [self isFileExistWithFilePath:filePath];
        if (isExist) {// 图片存在
            
            //            AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
            //            advertiseView.filePath = filePath;
            //            [advertiseView show];
            [self setFilePath:filePath];
            self.tapBlock = tapBlock;
            [self show];
            
        }
        
        // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
        [self getAdvertisingImage];
    }
    
    return self;
}
#pragma mark - delegate
#pragma mark - event response
#pragma mark - private methods
- (void)show {
    // 倒计时方法1：GCD
    //    [self startCoundown];
    
    // 倒计时方法2：定时器
    if (showTime<=0) {
        return;
    }
    [self timerBegin];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
- (void)timerBegin {
    self.count = showTime;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)countDown {
    
}
- (void)pushToAd {
    
}
- (void)skipBtnAction {
    
}
- (void)timeBegin {
    self.count --;
    [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过%d",self.count] forState:UIControlStateNormal];
    if (_count <= 0) {
        
        [self skipBtnAction];
    }
}
/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}
/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }
    
    // TODO 请求广告接口
    
    //    [PPNetworkHelper POST:NSStringFormat(@"%@%@",URL_main,URL_Test) parameters:@{@"versionId":@100} success:^(id responseObject) {
    //        if (ValidDict(responseObject)) {
    //            if (ValidDict(responseObject[@"data"])) {
    //                NSDictionary *data = responseObject[@"data"];
    //                if (ValidStr(data[@"picUrl"])) {
    //                    // 获取图片名:43-130P5122Z60-50.jpg
    //                    NSArray *stringArr = [data[@"picUrl"] componentsSeparatedByString:@"/"];
    //                    NSString *imageName = stringArr.lastObject;
    //
    //                    // 拼接沙盒路径
    //                    NSString *filePath = [self getFilePathWithImageName:imageName];
    //                    BOOL isExist = [self isFileExistWithFilePath:filePath];
    //                    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
    //
    //                        [self downloadAdImageWithUrl:data[@"picUrl"] imageName:imageName];
    //
    //                    }
    //
    //                }
    //            }
    //        }
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    
    
    //    // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
    //    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    //    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    //
}
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"广告页保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"广告页保存失败");
        }
        
    });
}
/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}
#pragma mark - getters and setters
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
    }
    return _timer;
}


@end
