//
//  SFHttpRequest.m
//  TopSF
//
//  Created by jiajun on 9/27/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFHttpRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString(SF)

- (NSString *)md5 {
	const char* str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
	
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
	for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x",result[i]];
	}
	return ret;
}

- (NSString *)urlencode {
	NSString *encUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	int len = [encUrl length];
	const char *c;
	c = [encUrl UTF8String];
	NSString *ret = @"";
	for(int i = 0; i < len; i++) {
		switch (*c) {
			case '/':
				ret = [ret stringByAppendingString:@"%2F"];
				break;
			case '\'':
				ret = [ret stringByAppendingString:@"%27"];
				break;
			case ';':
				ret = [ret stringByAppendingString:@"%3B"];
				break;
			case '?':
				ret = [ret stringByAppendingString:@"%3F"];
				break;
			case ':':
				ret = [ret stringByAppendingString:@"%3A"];
				break;
			case '@':
				ret = [ret stringByAppendingString:@"%40"];
				break;
			case '&':
				ret = [ret stringByAppendingString:@"%26"];
				break;
			case '=':
				ret = [ret stringByAppendingString:@"%3D"];
				break;
			case '+':
				ret = [ret stringByAppendingString:@"%2B"];
				break;
			case '$':
				ret = [ret stringByAppendingString:@"%24"];
				break;
			case ',':
				ret = [ret stringByAppendingString:@"%2C"];
				break;
			case '[':
				ret = [ret stringByAppendingString:@"%5B"];
				break;
			case ']':
				ret = [ret stringByAppendingString:@"%5D"];
				break;
			case '#':
				ret = [ret stringByAppendingString:@"%23"];
				break;
			case '!':
				ret = [ret stringByAppendingString:@"%21"];
				break;
			case '(':
				ret = [ret stringByAppendingString:@"%28"];
				break;
			case ')':
				ret = [ret stringByAppendingString:@"%29"];
				break;
			case '*':
				ret = [ret stringByAppendingString:@"%2A"];
				break;
			default:
				ret = [ret stringByAppendingFormat:@"%c", *c];
		}
		c++;
	}
    
	return ret;
    /**
     NSString *result = (NSString *)
     CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
     (CFStringRef)self,
     CFSTR(""),
     kCFStringEncodingUTF8);
     return [result autorelease];
     **/
}

- (NSDictionary *)paramsFromURL {
	
    NSString *protocolString = @"";
    NSString *tmpString = @"";
	NSString *hostString = @"";
    NSString *uriString = @"/";
    
    if (0 < [self rangeOfString:@"://"].length) {
        protocolString = [self substringToIndex:([self rangeOfString:@"://"].location)];
        tmpString = [self substringFromIndex:([self rangeOfString:@"://"].location + 3)];
    }
    
	if (0 < [tmpString rangeOfString:@"/"].length) {
		hostString = [tmpString substringToIndex:([tmpString rangeOfString:@"/"].location)];
        tmpString = [self substringFromIndex:([self rangeOfString:hostString].location + [self rangeOfString:hostString].length)];
	}
	else if (0 < [tmpString rangeOfString:@"?"].length) {
		hostString = [tmpString substringToIndex:([tmpString rangeOfString:@"?"].location)];
        if (0 < hostString.length) {
            tmpString = [self substringFromIndex:([self rangeOfString:hostString].location + [self rangeOfString:hostString].length)];
        }
	}
	else {
		hostString = tmpString;
        tmpString = nil;
	}
	
    if (tmpString) {
        if (0 < [tmpString rangeOfString:@"/"].length) {
            if (0 < [tmpString rangeOfString:@"?"].length) {
                uriString = [tmpString substringToIndex:[tmpString rangeOfString:@"?"].location];
            }
            else {
                uriString = tmpString;
            }
        }
    }
	NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
	if (0 < [self rangeOfString:@"?"].length) {
		NSString *paramString = [self substringFromIndex:([self rangeOfString:@"?"].location + 1)];
		NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
		NSScanner* scanner = [[NSScanner alloc] initWithString:paramString];
		while (![scanner isAtEnd]) {
			NSString* pairString = nil;
			[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
			[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
			NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
			if (kvPair.count == 2) {
				NSString* key = [[kvPair objectAtIndex:0]
								 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				NSString* value = [[kvPair objectAtIndex:1]
								   stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				[pairs setObject:value forKey:key];
			}
		}
	}
	
	return [NSDictionary dictionaryWithObjectsAndKeys:
			pairs, PARAMS,
			protocolString, PROTOCOL,
			hostString, HOST,
			uriString, URI, nil];
}

- (NSString*)addUrlFromDictionary:(NSDictionary*)params
{
    NSMutableString *_add = nil;
    if ([self rangeOfString:@"?"].length > 0) {
        _add = [NSMutableString stringWithString:@"&"];
    }else {
        _add = [NSMutableString stringWithString:@"?"];
    }
    for (NSString* key in [params allKeys]) {
        if ([params objectForKey:key] && 0 < [[params objectForKey:key] length]) {
            if([key isEqualToString:@"ttid"]){
                [_add appendFormat:@"%@=%@&",key,[params objectForKey:key]];
            }else{
                [_add appendFormat:@"%@=%@&",key,[[params objectForKey:key] urlencode]];
            }
        }
    }
    
    return [NSString stringWithFormat:@"%@%@",self,[_add substringToIndex:[_add length] - 1]];
}

- (NSString *)removeVowel
{
    BOOL vowel = NO;
	int len = [self length];
	const char *c;
	c = [self UTF8String];
	NSString *ret = @"";
	for(int i = 0; i < len; i++) {
        if (('a' == *c) || ('e' == *c) || ('i' == *c)
            || ('o' == *c) || ('u' == *c) || ('v' == *c)) {
            if (! vowel) {
                ret = [ret stringByAppendingFormat:@"%c", *c];
            }
        }
        else {
            vowel = YES;
            ret = [ret stringByAppendingFormat:@"%c", *c];
        }
        c ++;
    }
	return ret;
}

@end

@interface SFHttpRequest ()

- (void)asynchronous:(NSString *)url
			  params:(NSMutableDictionary *)params
            userInfo:(NSMutableDictionary *)userInfo
			delegate:(id)delegate
		   onSuccess:(SEL)successCallback
		   onFailure:(SEL)failureCallback
		  onComplete:(SEL)completeCallback;

- (void)requestFinished:(ASIHTTPRequest*)request;
- (void)requestFailed:(ASIHTTPRequest*)request;

@property (nonatomic, assign)   id          delegate;
@property (nonatomic, assign)   SEL         successCallback;
@property (nonatomic, assign)   SEL         failureCallback;
@property (nonatomic, assign)   SEL         completeCallback;
@property (nonatomic, copy)     NSString    *responseDataType;
@property (nonatomic, copy)     NSString    *requestMethod;

@end

@implementation SFHttpRequest

@synthesize delegate;
@synthesize successCallback;
@synthesize failureCallback;
@synthesize completeCallback;
@synthesize responseDataType;

+ (void)invoke:(NSString*)url
		params:(NSMutableDictionary *)params
      userInfo:(NSMutableDictionary *)userInfo
	  delegate:(id)delegate
	 onSuccess:(SEL)successCallback
	 onFailure:(SEL)failureCallback
	onComplete:(SEL)completeCallback
{
	
	 SFHttpRequest *request = [[SFHttpRequest alloc] init];
	[request asynchronous:url params:params userInfo:userInfo delegate:delegate onSuccess:successCallback onFailure:failureCallback onComplete:completeCallback];
}


/**
 * 发起异步HTTP请求
 * params:专门用于存放上传参数的字典
 * userInfo:自定义字典,用于区分不同的请求,规定“_cacheType”字段用于存放缓存方案标识
 ASIDefaultCachePolicy = 0,
 ASIIgnoreCachePolicy = 1,
 ASIReloadIfDifferentCachePolicy = 2,
 ASIOnlyLoadIfNotCachedCachePolicy = 3,
 ASIUseCacheIfLoadFailsCachePolicy = 4
 分别用字符串:"0","1","2","3","4"表示
 *
 */
- (void)asynchronous:(NSString *)url
			  params:(NSMutableDictionary *)params
            userInfo:(NSMutableDictionary *)userInfo
			delegate:(id)aDelegate
		   onSuccess:(SEL)aSuccessCallback
		   onFailure:(SEL)aFailureCallback
		  onComplete:(SEL)aCompleteCallback
{
	self.delegate = aDelegate;
	self.successCallback = aSuccessCallback;
	self.failureCallback = aFailureCallback;
	self.completeCallback = aCompleteCallback;
    
	[self.delegate retain];
    
    if ([[userInfo allKeys] containsObject:DATA_TYPE]) {
        self.responseDataType = [userInfo objectForKey:DATA_TYPE];
    } else {
        self.responseDataType = DATA_STRING;
    }
    
    if ([[userInfo allKeys] containsObject:REQ_METHOD]) {
        self.requestMethod = [userInfo objectForKey:REQ_METHOD];
    } else {
        self.requestMethod = REQ_GET;
    }
    
    ASIFormDataRequest *request = nil;
	if ([self.responseDataType isEqualToString:DATA_BYTE]) {
		if (nil != url && ![[NSNull null] isEqual:url ] && [url length] > 0 && [url hasPrefix:@"http://"]) {
            request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[url addUrlFromDictionary:params]]];
            [request setRequestMethod:REQ_GET];
            [request buildPostBody];
            [request setDelegate:self];
            [request startAsynchronous];
        }
	}
	else {
        if ([REQ_GET isEqual:self.requestMethod]) {
            request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[url addUrlFromDictionary:params]]];
        } else {
            request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
            if (params == nil) {
                params = [NSMutableDictionary dictionary];
            }
            for (NSString *key in [params allKeys]) {
                [request addPostValue:[params objectForKey:key] forKey:key];
            }
        }
        [request setRequestMethod:self.requestMethod];

		[request buildPostBody];
		[request setDelegate:self];
		[request startAsynchronous];
	}
}

/**
 * HTTP响应成功的回调函数
 *
 */
- (void)requestFinished:(ASIHTTPRequest*)request {
	NSError *error = [request error];
	if (!error) {
		int statusCode = [request responseStatusCode];
		if (statusCode == 200) {
			if ([DATA_BYTE isEqualToString:self.responseDataType]) {
				NSData *data = [request responseData];
				if ([self.delegate respondsToSelector:self.successCallback]) {
					[self.delegate performSelector:self.successCallback withObject:data withObject:request.originalURL.absoluteString];
				}
			}
			else {
                NSDictionary *data = nil;
                if (request.responseString && 0 < [request.responseString length]) {
                    data = [[request responseString] JSONValue];
                }
				if (data) {
                    if ([self.delegate respondsToSelector:self.successCallback]) {
                        [self.delegate performSelector:self.successCallback withObject:data];
                    }
                }
			}
		}
		else {
			NSString *statusMessage = [request responseStatusMessage];
			NSMutableDictionary *errorDic = [NSMutableDictionary dictionary];
			[errorDic setObject:statusMessage forKey:@"status"];
			NSError *httpError = [NSError errorWithDomain:@"HTTPResponseDomain"
													 code:statusCode
												 userInfo:errorDic];
			
			if ([self.delegate respondsToSelector:self.failureCallback]) {
				[self.delegate performSelector:self.failureCallback withObject:httpError];
			}
		}
	}
	else {
		if ([self.delegate respondsToSelector:self.failureCallback]) {
			[self.delegate performSelector:self.failureCallback withObject:error];
		}
	}
	
	if ([self.delegate respondsToSelector:self.completeCallback]) {
		[self.delegate performSelector:self.completeCallback];
	}
    [request release];
    [self release];
}


/**
 * HTTP响应失败的回调函数
 *
 */
- (void)requestFailed:(ASIHTTPRequest*)request {
	NSError *error = [request error];
    
    if ([self.delegate respondsToSelector:self.failureCallback]) {
        [self.delegate performSelector:self.failureCallback withObject:error];
    }
    
    if ([self.delegate respondsToSelector:self.completeCallback]) {
        [self.delegate performSelector:self.completeCallback];
    }
    
    [request release];
    [self release];
}

@end
