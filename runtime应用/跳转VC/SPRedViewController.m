//
//  SPRedViewController.m
//  runtime应用
//
//  Created by JackMa on 2019/11/6.
//  Copyright © 2019 fire. All rights reserved.
//

#import "SPRedViewController.h"

@interface SPRedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *show_lb;

@end

@implementation SPRedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.show_lb.text = self.name;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
