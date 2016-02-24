//
//  OTURLCache.m
//  FileSystemSample
//
//  Created by ruwei on 14-4-8.
//  Copyright (c) 2014年 ruwei. All rights reserved.
//

#import "OT.h"
#import <sqlite3.h>
#import <CommonCrypto/CommonDigest.h>
#import "SecurityUtil.h"

#define DIR_NAME_OT_CACHE_DATA @"CacheData"
#define Header_KeepForever @"KeepForever"
#define Version @"V1_0"



@implementation OTCachedURLResponse



- (instancetype)initWithCoder:(NSCoder *)aDecoder
{

    NSData *data = [aDecoder decodeObjectForKey:@"OT_DATA"];
    NSURLResponse *response = [aDecoder decodeObjectForKey:@"OT_RESPONSE"];
    NSDictionary *userInfo = [aDecoder decodeObjectForKey:@"OT_USERINFO"];
    
    self = [super initWithResponse:response data:data userInfo:userInfo storagePolicy:NSURLCacheStorageAllowed];
    
    return self;
}

    
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self data] forKey:@"OT_DATA"];
    [aCoder encodeObject:[self response] forKey:@"OT_RESPONSE"];
    [aCoder encodeObject:[self userInfo] forKey:@"OT_USERINFO"];
    
}


@end

@interface OTCache()

@property (readwrite , nonatomic , strong ) NSString *path;

@end


@implementation OTCache



- (instancetype)initWithDiskPath:(NSString *)aPath
{
    self = [super init];
    if ( nil != self)
    {
        self.path = aPath;
    }
    return self;
}


- (void)storeCachedObject:(id <NSCoding>)aObject forKey:(NSString *)aKey withCondition:(NSString *)aCondition
{
    if (nil == aCondition)
    {
        aCondition = @"";
    }
    
    //创建零时文件
    OTFileAutoRemoved *file = OTF_CreateTempFile();
    //OTFileAutoRemoved *file = OTF_CreateTempFileForIdentifier(@"OT_URL_CACHE_OBJECT", YES);
    
    BOOL ret;
    ret = [NSKeyedArchiver archiveRootObject:aObject toFile:file.path];
    
    if ( !ret )
    {
        @throw [[NSException alloc] initWithName:@"cache失败" reason:@"打包Object失败。" userInfo:nil];
    }
    
    //    OTCachedURLResponse *savedCachedResponse = (OTCachedURLResponse *)[NSKeyedUnarchiver unarchiveObjectWithFile:file.path];
    
    NSString *cachedPath = self.path ;
    cachedPath = [cachedPath stringByAppendingPathComponent:DIR_NAME_OT_CACHE_DATA];
    NSString *cachedName = [NSString stringWithFormat:@"%@%@%@", Version , aKey , aCondition];
    cachedName = [cachedName MD5];
    NSString *cachedFilePath = [cachedPath stringByAppendingPathComponent:cachedName];
    
    @try
    {
        //将零时文件拷到缓存目录下。
        OTF_MoveItem(file.path, cachedFilePath);
    }
    @catch (NSException *exception)
    {
        @throw [[NSException alloc] initWithName:@"cache失败[移动文件失败]" reason:[exception reason] userInfo:[exception userInfo]];
    }

}

- (void)storeCachedObject:(id <NSCoding>)aObject forKey:(NSString *)aKey withConditions:(NSDictionary *)aConditions
{
    NSMutableString *condition = nil;
    
    if ( nil != aConditions )
    {
        NSArray *keys = [aConditions keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSString *s1 , *s2 ;
            s1 = (NSString *)obj1;
            s2 = (NSString *)obj2;
            return [s1 compare:s2 options:NSLiteralSearch];
        }];
        
        condition = [[NSMutableString alloc] init];
        for ( int i = 0 ; i < [keys count]; i++)
        {
            [condition appendFormat:@"%@:%@",keys[i] , [aConditions objectForKey:keys[i]]];
            if (i != [keys count] - 1)
            {
                [condition appendString:@"&"];
            }
        }
    }
    
    [self storeCachedObject:aObject forKey:aKey withCondition:condition];
}

- (id)cachedObjectForKey:(NSString *)aKey withCondition:(NSString *)aCondition
{
    if (nil == aCondition)
    {
        aCondition = @"";
    }
    
    id cachedObject;
    
    NSString *cachedPath = self.path ;
    cachedPath = [cachedPath stringByAppendingPathComponent:DIR_NAME_OT_CACHE_DATA];
    NSString *cachedName = [NSString stringWithFormat:@"%@%@%@", Version , aKey , aCondition];
    cachedName = [cachedName MD5];
    NSString *cachedFilePath = [cachedPath stringByAppendingPathComponent:cachedName];
    BOOL ret , isDir;
    ret = OTF_FileExistsAtPath( cachedFilePath , &isDir );
    
    if (ret && !isDir)
    {
        cachedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:cachedFilePath];
    }
    else
    {
        cachedObject = nil;
    }
    
    
    return cachedObject;
}

- (id)cachedObjectForKey:(NSString *)aKey withConditions:(NSDictionary *)aConditions
{
    NSMutableString *condition = nil;
    
    if ( nil != aConditions )
    {
        NSArray *keys = [aConditions keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSString *s1 , *s2 ;
            s1 = (NSString *)obj1;
            s2 = (NSString *)obj2;
            return [s1 compare:s2 options:NSLiteralSearch];
        }];
        
        condition = [[NSMutableString alloc] init];
        for ( int i = 0 ; i < [keys count]; i++)
        {
            [condition appendFormat:@"%@:%@",keys[i] , [aConditions objectForKey:keys[i]]];
            if (i != [keys count] - 1)
            {
                [condition appendString:@"&"];
            }
        }
    }
    
    return [self cachedObjectForKey:(NSString *)aKey withCondition:condition];
    
}

- (void)removeCachedObjectForKey:(NSString *)aKey withCondition:(NSString *)aCondition
{
    if ( nil == aCondition )
    {
        aCondition = @"";
    }
    
    NSString *cachedPath = self.path ;
    cachedPath = [cachedPath stringByAppendingPathComponent:DIR_NAME_OT_CACHE_DATA];
    NSString *cachedName = [NSString stringWithFormat:@"%@%@%@", Version , aKey , aCondition];
    cachedName = [cachedName MD5];
    NSString *cachedFilePath = [cachedPath stringByAppendingPathComponent:cachedName];
    BOOL ret , isDir;
    ret = OTF_FileExistsAtPath( cachedFilePath , &isDir );
    
    if (ret && !isDir)
    {
        OTF_RemoveItem(cachedFilePath);
    }
    else
    {
    }
}


- (void)removeCachedObjectForKey:(NSString *)aKey withConditions:(NSDictionary *)aConditions
{
    NSMutableString *condition = nil;
    
    if ( nil != aConditions )
    {
        NSArray *keys = [aConditions keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSString *s1 , *s2 ;
            s1 = (NSString *)obj1;
            s2 = (NSString *)obj2;
            return [s1 compare:s2 options:NSLiteralSearch];
        }];
        
        condition = [[NSMutableString alloc] init];
        for ( int i = 0 ; i < [keys count]; i++)
        {
            [condition appendFormat:@"%@:%@",keys[i] , [aConditions objectForKey:keys[i]]];
            if (i != [keys count] - 1)
            {
                [condition appendString:@"&"];
            }
        }
    }
    
    [self removeCachedObjectForKey:aKey withCondition:condition];
    
}

- (void)removeAllCachedObjects
{
    NSString *tempDir = OTF_PathForDirDomain(OTF_Temp);
    NSString *name = [NSString stringWithFormat:@"%lf" , [[NSDate date] timeIntervalSince1970] ] ;
    name = OTF_UniqueIdentifier(name);
    tempDir = [tempDir stringByAppendingPathComponent:[name MD5]];
    
    NSString *cachedPath = self.path ;
    cachedPath = [cachedPath stringByAppendingPathComponent:DIR_NAME_OT_CACHE_DATA];
    OTF_MoveItem(cachedPath, tempDir);
    OTF_RemoveItem(tempDir);
}



@end


@implementation OTCache (HTTP)



- (void)storeCachedResponse:(NSCachedURLResponse *)aCachedResponse forRequest:(NSURLRequest *)aRequest withCondition:(NSString *)aCondition
{
    
    if (![aCachedResponse isKindOfClass:[OTCachedURLResponse class]])
    {
        OTCachedURLResponse *otCachedResponse = [[OTCachedURLResponse alloc] initWithResponse:[aCachedResponse response] data:[aCachedResponse data] userInfo:[aCachedResponse userInfo] storagePolicy:NSURLCacheStorageAllowed];
        
        [self storeCachedObject:otCachedResponse forKey:[[aRequest URL] absoluteString] withCondition:aCondition];
    }
    else
    {
        [self storeCachedObject:aCachedResponse forKey:[[aRequest URL] absoluteString] withCondition:aCondition];
    }

}

- (void)storeCachedResponse:(NSCachedURLResponse *)aCachedResponse forRequest:(NSURLRequest *)aRequest withConditions:(NSDictionary *)aConditions
{
    if (![aCachedResponse isKindOfClass: [OTCachedURLResponse class]])
    {
        OTCachedURLResponse *otCachedResponse = [[OTCachedURLResponse alloc] initWithResponse:[aCachedResponse response] data:[aCachedResponse data] userInfo:[aCachedResponse userInfo] storagePolicy:NSURLCacheStorageAllowed];
        [self storeCachedObject:otCachedResponse forKey:[[aRequest URL] absoluteString] withConditions:aConditions];
    }
    else
    {
        [self storeCachedObject:aCachedResponse forKey:[[aRequest URL] absoluteString] withConditions:aConditions];
    }
    
}


- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)aRequest withCondition:(NSString *)aCondition
{
    return (NSCachedURLResponse *)[self cachedObjectForKey:[[aRequest URL] absoluteString] withCondition:aCondition];
}


- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)aRequest withConditions:(NSDictionary *)aConditions
{
    return (NSCachedURLResponse *)[self cachedObjectForKey:[[aRequest URL] absoluteString] withConditions:aConditions];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)aRequest withCondition:(NSString *)aCondition
{
    [self removeCachedObjectForKey:[[aRequest URL] absoluteString] withCondition:aCondition];
}
- (void)removeCachedResponseForRequest:(NSURLRequest *)aRequest withConditions:(NSDictionary *)aConditions
{
    [self removeCachedObjectForKey:[[aRequest URL] absoluteString] withConditions:aConditions];
}


@end












