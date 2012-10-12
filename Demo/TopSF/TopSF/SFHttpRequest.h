//
//  SFHttpRequest.h
//  TopSF
//
//  Created by jiajun on 9/27/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#define DATA_TYPE		@"_dataType"
#define REQ_METHOD		@"_dataType"

#define REQ_GET         @"GET"
#define REQ_POST        @"POST"

// 返回字节类型,用于图片下载
#define DATA_BYTE		@"byte"
// 返回字符串类型,用于推请求
#define DATA_STRING		@"string"

#define PROTOCOL        @"PROTOCOL"
#define HOST            @"HOST"
#define PARAMS          @"PARAMS"
#define URI             @"URI"

@interface NSString(SF)

- (NSString *)urlencode;
- (NSString *)md5;
/**
 *  @param NSString *URL 需要解析的URL，格式如：http://host.name/testpage/?keyA=valueA&amp;keyB=valueB
 *  @return NSDictionary *params 从URL中解析出的参数表
 *    PROTOCOL 如 http
 *    HOST     如 host.name
 *    PARAMS   如 {keyA:valueA, keyB:valueB}
 *    URI      如 /testpage
 */
- (NSDictionary *)paramsFromURL;
- (NSString*)addUrlFromDictionary:(NSDictionary*)params;

- (NSString *)removeVowel;

@end

@interface SFHttpRequest : NSObject

+ (void)invoke:(NSString*)url
		params:(NSMutableDictionary *)params
      userInfo:(NSMutableDictionary *)userInfo
	  delegate:(id)delegate
	 onSuccess:(SEL)successCallback
	 onFailure:(SEL)failureCallback
	onComplete:(SEL)completeCallback;

@end
