//
//  OTURLCache.h
//  FileSystemSample
//
//  Created by ruwei on 14-4-8.
//  Copyright (c) 2014年 ruwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTCachedURLResponse : NSCachedURLResponse

@end


@interface OTCache :NSObject

@property (readonly , nonatomic , strong ) NSString *path;


- (instancetype)initWithDiskPath:(NSString *)aPath;


- (void)storeCachedObject:(id <NSCoding>)aObject forKey:(NSString *)aKey withCondition:(NSString *)aCondition;
- (void)storeCachedObject:(id <NSCoding>)aObject forKey:(NSString *)aKey withConditions:(NSDictionary *)aConditions;
- (id)cachedObjectForKey:(NSString *)aKey withCondition:(NSString *)aCondition;
- (id)cachedObjectForKey:(NSString *)aKey withConditions:(NSDictionary *)aConditions;

- (void)removeCachedObjectForKey:(NSString *)aKey withCondition:(NSString *)aCondition;
- (void)removeCachedObjectForKey:(NSString *)aKey withConditions:(NSDictionary *)aConditions;
- (void)removeAllCachedObjects;


@end

@interface OTCache (HTTP)

- (void)storeCachedResponse:(NSCachedURLResponse *)aCachedResponse forRequest:(NSURLRequest *)aRequest withCondition:(NSString *)aCondition;
- (void)storeCachedResponse:(NSCachedURLResponse *)aCachedResponse forRequest:(NSURLRequest *)aRequest withConditions:(NSDictionary *)aConditions;


- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)aRequest withCondition:(NSString *)aCondition;
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)aRequest withConditions:(NSDictionary *)aConditions;

- (void)removeCachedResponseForRequest:(NSURLRequest *)aRequest withCondition:(NSString *)aCondition;
- (void)removeCachedResponseForRequest:(NSURLRequest *)aRequest withConditions:(NSDictionary *)aConditions;




@end


