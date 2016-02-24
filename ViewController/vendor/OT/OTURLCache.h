//
//  OTURLCache.h
//  date
//
//  Created by ruwei on 14-4-16.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OT.h"
@interface OTURLCache : NSURLCache
@property (readwrite , nonatomic , strong) OTCache *innerCache;


- (instancetype)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity InnerCache:(OTCache *)aInnerCache;


@end
