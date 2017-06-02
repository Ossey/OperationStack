//
//  ViewController.m
//  OperationStack
//
//  Created by xiaoyuan on 2017/6/1.
//  Copyright © 2017年 xiaoyuan. All rights reserved.
//

#import "ViewController.h"
#import "OperationStack.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    OperationStack *stack = [OperationStack new];
    [stack setMaxConcurrentOperationCount:1];
    
    for (int i = 0; i < 20; i++) {
        
        [stack addOperationWithBlock:^{
            NSLog(@"%d", i);
            NSLog(@"%@ -- %d", [NSThread currentThread], __LINE__);
        }];
    }
    
    [stack bringOperationToFontWithBlock:^{
        NSLog(@"hello ");
        NSLog(@"%@ -- %d", [NSThread currentThread], __LINE__);
    }];
    
    
    [stack bringOperationToFontWithBlock:^{
        NSLog(@"hello xiaoyuan");
        
        NSLog(@"%@ -- %d", [NSThread currentThread], __LINE__);
    }];
    
    for (int i = 20; i < 40; i++) {
        
        [stack addOperationWithBlock:^{
            NSLog(@"%d", i);
            NSLog(@"%@ -- %d", [NSThread currentThread], __LINE__);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
