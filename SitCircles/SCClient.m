//
//  SCClient.m
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCClient.h"

@interface SCClient ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSString *baseURL;
@end

@implementation SCClient

- (id)init {
    
    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];

    return [self initWithBaseURL:routes[@"localURL"]];
}

- (instancetype)initWithBaseURL:(NSString *)url {
    if (self == [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{@"Content-Type": @"application/json"}];
        _session = [NSURLSession sessionWithConfiguration:config];
        self.baseURL = url;
    }
    
    return self;
}

- (RACSignal *)fetchJSONFromRelativeURLString:(NSString *)urlString {
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, urlString];
    NSURL *url = [NSURL URLWithString:fullURL];
    
    NSLog(@"fetching from: %@", url.absoluteString);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if (!jsonError) {
                    [subscriber sendNext:json];
                } else {
                    [subscriber sendError:jsonError];
                }
            } else {
                [subscriber sendError:error];
            }
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


- (RACSignal *)postJSONData:(NSDictionary *)dict toRelativeURLString:(NSString *) urlString {
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, urlString];
    NSURL *url = [NSURL URLWithString:fullURL];
    
    NSLog(@"posting to: %@", url.absoluteString);
    
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        NSError *serialError = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&serialError];
        NSLog(@"posting data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if (!serialError) {
            //post data...
            NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request
                fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (!error) {
                        //check status code...
                        NSInteger status = [(NSHTTPURLResponse *) response statusCode];
                        NSLog(@"status code: %ld", (long)status);
                        if (status >= 200 && status < 300) {
                            //looks good
                            NSError *jsonError = nil;
                            id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                            
                            if (!jsonError) {
                                //send subscriper serialized json as array or dictionary
                                [subscriber sendNext:json];
                            } else {
                                //notify subscriber of error
                                NSLog(@"error serializing response JSON");
                                [subscriber sendError:jsonError];
                            }
                        } else {
                            //generate error from response...
                            NSLog(@"error: did not get an http 200");
                            [subscriber sendError:[self errorFromResponse:(NSHTTPURLResponse *) response]];
                        }
                    } else {
                        [subscriber sendError:error];
                    }
                }];
            
            [uploadTask resume];
            
            return [RACDisposable disposableWithBlock:^{
                [uploadTask cancel];
            }];
        } else {
            NSLog(@"Failed to serialize request JSON");
            [subscriber sendError:serialError];
            return nil;
        }
        
    }] doError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


- (NSError *)errorFromResponse:(NSHTTPURLResponse *)response {
    NSString *domain = @"HTTPStatusCodeErrorDomain";
    NSInteger code = response.statusCode;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:response.allHeaderFields];
    [dict setValue:response.URL.absoluteString forKey:@"URL"];
    [dict setValue:[NSString stringWithFormat:@"%ld", response.statusCode] forKey:@"statusCode"];
    
    NSError *responseError = [NSError errorWithDomain:domain code:code userInfo:dict];
    return responseError;
}

@end
