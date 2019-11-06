//
//  ViewController.m
//  runtime应用
//
//  Created by JackMa on 2019/11/6.
//  Copyright © 2019 fire. All rights reserved.
//

#import "ViewController.h"
#import "SPPerson.h"
#import "SPArchiveTool.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear: %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = @[@{@"class":@"SPRedViewController",
      @"data":@{@"name":@"spirej-18",
                @"backgroundColor":@"red"}},
    @{@"class":@"SPGreenViewController",
      @"data":@{@"slogan":@"和谐学习,不急不躁",
                @"backgroundColor":@"green"}},
    @{@"class":@"SPBlueViewController",
      @"data":@{@"ending":@"我就是我,颜色不一样的烟火",
                @"backgroundColor":@"blue"}}];
    
    [self archiveTest];
    
    [self createClassTest];
}

#pragma mark - 归档测试

- (void)archiveTest {
    
    SPPerson *p = [[SPPerson alloc] init];
    p.name = @"spirej";
    p.nickName = @"sp";
    p.age = 18;
    
    // 归档
    [SPArchiveTool sp_archiveObject:p prefix:NSStringFromClass(SPPerson.class)];
    
    // 解档
    [SPArchiveTool sp_unarchiveClass:SPPerson.class prefix:NSStringFromClass(SPPerson.class)];
    
    NSLog(@"name = %@, nickName = %@, age = %ld", p.name, p.nickName, (long)p.age);
}

#pragma mark - 动态创建类测试

void hunting(id self, SEL _cmd) {
    NSLog(@"%@ - %s", self, __func__);
}

- (void)createClassTest {
    // 创建一类对
    Class SPCat = objc_allocateClassPair([NSObject class], "SPCat", 0);
    
    // 添加实例变量
    NSString *name = @"spCat";
    class_addIvar(SPCat, name.UTF8String, sizeof(id), log2(sizeof(id)), @encode(id));
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    // 添加方法
    class_addMethod(SPCat, @selector(hunting), (IMP)hunting, "v@:");
    
    // 注册类
    objc_registerClassPair(SPCat);
    
    // 创建实例对象
    id cat = [[SPCat alloc] init];
    [cat setValue:@"Tom" forKey:name];
    NSLog(@"name = %@", [cat valueForKey:name]);
    
    // 方法调用
    [cat performSelector:@selector(hunting)];
}

#pragma mark - 动态创建类 控制器vc测试

- (IBAction)goRedVC:(UIButton *)sender {
    [self pushToAnyVCWithData:self.dataArray[0]];
}

- (IBAction)goGreenVC:(UIButton *)sender {
    [self pushToAnyVCWithData:self.dataArray[1]];
}

- (IBAction)goBlueVC:(UIButton *)sender {
    [self pushToAnyVCWithData:self.dataArray[2]];
}

- (void)pushToAnyVCWithData:(NSDictionary *)dataDic {
    
    const char *clsName = [dataDic[@"class"] UTF8String];
    Class cls = objc_getClass(clsName);
    
    // 1.创建类
    if (!cls) {
        Class superClass = [UIViewController class];
        // 创建一类对
        cls = objc_allocateClassPair(superClass, clsName, 0);
        // 添加成员变量
        class_addIvar(cls, "ending", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        class_addIvar(cls, "show_lb", sizeof(UILabel *), log2(sizeof(UILabel *)), @encode(UILabel *));
        // 添加方法
        Method method = class_getInstanceMethod([self class], @selector(sp_instanceMethod));
        IMP methodIMP = method_getImplementation(method);
        const char *types = method_getTypeEncoding(method);
        BOOL rest = class_addMethod(cls, @selector(viewDidLoad), methodIMP, types);
        NSLog(@"rest == %d", rest);
    }
    
    // 实例化对象
    id instance = nil;
    @try {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        instance = [sb instantiateViewControllerWithIdentifier:dataDic[@"class"]];
    } @catch (NSException *exception) {
        instance = [[cls alloc] init];
    } @finally {
        NSLog(@"OK");
    }
    
    NSDictionary *dict = dataDic[@"data"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        // 检测是否存在key的属性
        if (class_getProperty(cls, [key UTF8String])) {
            [instance setValue:obj forKey:key];
        }
        // 检测是否存在key的变量
        if (class_getInstanceVariable(cls, [key UTF8String])) {
            [instance setValue:obj forKey:key];
        }
    }];
    
    [self.navigationController pushViewController:instance animated:YES];
}

- (void)sp_instanceMethod {
    [super viewDidLoad];
    
    [self setValue:[UIColor blueColor] forKeyPath:@"view.backgroundColor"];
    [self setValue:[[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 30)] forKey:@"show_lb"];
    UILabel *show_lb = [self valueForKey:@"show_lb"];
    [[self valueForKey:@"view"] addSubview:show_lb];
    show_lb.text = [self valueForKey:@"ending"];
    show_lb.font = [UIFont systemFontOfSize:14];
    show_lb.textColor = [UIColor blackColor];
    show_lb.textAlignment = NSTextAlignmentCenter;
    show_lb.backgroundColor = [UIColor whiteColor];
    NSLog(@"hello word");
}

@end
