//
//  OTURLCache.m
//  date
//
//  Created by ruwei on 14-4-16.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import "OTURLCache.h"
#import "CocoaSecurity.h"
//#import "SecurityUtil.h"

@implementation OTURLCache

- (BOOL)isfresh:( NSCachedURLResponse *)aCachedURLResponse
{
    
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)[aCachedURLResponse response];
    NSDictionary *dic = [response allHeaderFields];
    NSDate *expires = nil;
    NSDate *date = nil;
    NSInteger age = -1;
    
    NSString *expires_s = [dic objectForKey:@"Expires"];
    NSString *date_s = [dic objectForKey:@"Date"];
    NSString *age_s = [dic objectForKey:@"Age"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    
    if ( nil != expires_s)
    {
        expires = [formatter dateFromString:expires_s];
    }
    
    if ( nil != date_s)
    {
        date = [formatter dateFromString:date_s];
    }
    
    if ( nil != age_s)
    {
        age =  [age_s intValue];
    }
    
    if (age != -1)
    {
        expires = [NSDate dateWithTimeInterval:age sinceDate:date];
    }
    
    
    if( [[NSDate date] compare:expires] == NSOrderedDescending )
    {
        return NO ;
    }
    
    return YES;
}

- (BOOL)canCache:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    //[request HTTPBody]
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)[cachedResponse response];
    NSDictionary *headers = [response allHeaderFields];
    NSString *nocache_s = [headers valueForKey:@"Cache-Control"];
    BOOL nocache = (nil == nocache_s) ? NO : ([ nocache_s compare:@"no-cache" options:NSCaseInsensitiveSearch] == NSOrderedSame);
    
    if ([response statusCode] == 200 && !nocache)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (instancetype)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity InnerCache:(OTCache *)aInnerCache
{
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:aInnerCache.path];
    self.innerCache = aInnerCache;
    return self;
}


- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{

    
    NSCachedURLResponse *cachedURLResponse ;
    if ( [[request HTTPMethod] compare:@"GET" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        cachedURLResponse = [self.innerCache cachedResponseForRequest:request withCondition:nil];
    }
    else if( [[request HTTPMethod] compare:@"POST" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
    
        NSData *body = [request HTTPBody];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setValue:[body MD5] forKey:@"BODY"];
        [dic setValue:@"POST" forKey:@"METHOD"];
        cachedURLResponse = [self.innerCache cachedResponseForRequest:request withConditions:dic];
    
    }
    
   
    if ( nil != cachedURLResponse && [self isfresh:cachedURLResponse ] ) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)[cachedURLResponse response];
        
        //OTHTTPResponse *newResponse = [[OTHTTPResponse alloc] initWithResponse:response expectedContentLength:[[cachedURLResponse data] length]];
        
        
        NSURLResponse* newResponse = [[NSURLResponse alloc] initWithURL:request.URL
                                                               MIMEType:[response MIMEType]
                                                  expectedContentLength:[response expectedContentLength]
                                                       textEncodingName:[response textEncodingName]];
        
        
        NSCachedURLResponse *newCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:newResponse data:[cachedURLResponse data] userInfo:[cachedURLResponse userInfo] storagePolicy:NSURLCacheStorageAllowed];
        
        return newCachedResponse;

    }
    else
    {
        return nil;
    }
    
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    
    //- (BOOL)canCache:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
    if ( [self canCache:cachedResponse forRequest:request] )
    {
        //NSHTTPURLResponse *response = (NSHTTPURLResponse *)[cachedResponse response];
        
        if ( [[request HTTPMethod] compare:@"GET" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            [self.innerCache storeCachedResponse:cachedResponse forRequest:request withCondition:nil];
        }
        else if( [[request HTTPMethod] compare:@"POST" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            NSData *body = [request HTTPBody];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [dic setValue:[body MD5] forKey:@"BODY"];
            [dic setValue:@"POST" forKey:@"METHOD"];
            [self.innerCache storeCachedResponse:cachedResponse forRequest:request withConditions:dic];
            
        }
    }
    
    
    
}


- (void)removeCachedResponseForRequest:(NSURLRequest *)request
{
    [self.innerCache removeCachedResponseForRequest:request withCondition:nil];
}


- (void)removeAllCachedResponses
{
    [self.innerCache removeAllCachedObjects];
}
@end
