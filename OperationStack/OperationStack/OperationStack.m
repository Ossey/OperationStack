//
//  OperationStack.m
//  OperationStack
//
//  Created by Ossey on 2017/5/31.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "OperationStack.h"
#import <libkern/OSAtomic.h>

void LIFO_performLocked(dispatch_block_t block) {
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    block();
    OSSpinLockUnlock(&aspect_lock);
}

@implementation NSOperationQueue (LIFO)

- (void)bringOperationToFont:(NSOperation *)op {
    
    [self LIFO_setDependenciesForOperation:op];
    [self addOperation:op];
}
- (void)bringOperationSToFont:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait {
    for (NSOperation *operation in ops) {
        [self LIFO_setDependenciesForOperation:operation];
    }
    
    [self addOperations:ops waitUntilFinished:wait];
}
- (void)bringOperationToFontWithBlock:(void (^)(void))block {
    
    [self bringOperationToFont:[NSBlockOperation blockOperationWithBlock:block]];
}

- (void)LIFO_setDependenciesForOperation:(NSOperation *)op {
    @synchronized (self) {
        // 获取当前队列是否正在暂停
        BOOL isSuspended = [self isSuspended];
        // 暂停队列
        [self setSuspended:YES];
        
        // 让op成为队列中所有操作的依赖
        NSInteger maxOperationsCount = self.maxConcurrentOperationCount> 0 ? self.maxConcurrentOperationCount : INT_MAX;
        NSArray *operations = [self operations];
        NSInteger idx = [operations count] - maxOperationsCount;
        if (idx > 0) {
            NSOperation *operation = operations[idx];
            // 判断是否正在执行中，如果没有就让operation依赖op
            if (![operation isExecuting]) {
                [operation addDependency:op];
                //                operation.queuePriority = NSOperationQueuePriorityLow;
                //                op.queuePriority = NSOperationQueuePriorityHigh;
            }
        }
        
        // 恢复任务
        [self setSuspended:isSuspended];
        
    }
}

@end

@implementation OperationStack

- (void)addOperation:(NSOperation *)op {
    [self LIFO_setDependenciesForOperation:op];
    [super addOperation:op];
}

- (void)addOperations:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait {
    for (NSOperation *operation in ops) {
        [self LIFO_setDependenciesForOperation:operation];
    }
    [super addOperations:ops waitUntilFinished:wait];
}

- (void)addOperationWithBlock:(void (^)(void))block {
    
    [self addOperation:[NSBlockOperation blockOperationWithBlock:block]];
}

@end



