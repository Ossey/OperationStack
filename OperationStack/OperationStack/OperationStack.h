//
//  OperationStack.h
//  OperationStack
//
//  Created by Ossey on 2017/5/31.
//  Copyright © 2017年 Ossey. All rights reserved.
//

/*
 NSOperationQueue是创建FIFO(先进先出)的后台任务队列，当我们需要添加的任务先执行时可以使用StackOperationQueue
 当然OperationStack并不完全按照LIFO(后进先出)的顺序执行的, 当添加新的LIFO的操作时，如果有任务已经在执行了那么在执行中的任务是不受任何影响的，那么第一个操作添加仍将首先被执行，LIFO(后进先出)队列将仅适用于除第一个任务外后面添加的操作
 另外,当maxconcurrentoperationcount > 1时，每一个操作并发执行，添加到队列后就会立即执行，所以此时StackOperationQueue是几乎无效的
 */

#import <Foundation/Foundation.h>


@interface OperationStack : NSOperationQueue


@end

@interface NSOperationQueue (LIFO)

- (void)bringOperationToFont:(NSOperation *)op;
- (void)bringOperationSToFont:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait;
- (void)bringOperationToFontWithBlock:(void (^)(void))block;

@end
