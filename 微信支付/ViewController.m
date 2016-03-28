//
//  ViewController.m
//  微信支付
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "NSString+Hash.h"
#import "RegexKitLite.h"
#import "WXApi.h"
@interface ViewController ()<WXApiDelegate>
@property (nonatomic,copy) NSString *prepayId;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSString *sign;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)sendRequest:(id)sender {
    
    
    srand( (unsigned)time(0) );
    NSString *nonce_str = [NSString stringWithFormat:@"%d", rand()];
    NSString *out_trade_no = [NSString stringWithFormat:@"%ld",time(0)];
    
    NSString *appid = @"微信返回的wx序列";
    NSString *mch_id = @"1265687501";
    NSString *body = @"ipad";
    NSString *total_fee = @"1";
    NSString *notify_url = @"http://www.baidu.com";
    NSString *trade_type = @"APP";
    NSString *spbill_create_ip = @"106.2.195.178";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:appid forKey:@"appid"];
    [dict setValue:mch_id forKey:@"mch_id"];
    [dict setValue:nonce_str forKey:@"nonce_str"];
    [dict setValue:out_trade_no forKey:@"out_trade_no"];
    [dict setValue:body forKey:@"body"];
    [dict setValue:notify_url forKey:@"notify_url"];
    [dict setValue:trade_type forKey:@"trade_type"];
    [dict setValue:total_fee forKey:@"total_fee"];
    [dict setValue:spbill_create_ip forKey:@"spbill_create_ip"];
    
    
    NSArray *array = dict.allKeys;
    
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString *appKey = @"自己的AppKey";
    NSLog(@"%@\n",sortArray);
    
    NSMutableString *stringA = [NSMutableString string];
    
    for (NSString *key in sortArray) {
        [stringA appendFormat:@"%@=%@&",key,dict[key]];
    }
    [stringA appendFormat:@"key=%@",appKey];
    
    
    NSLog(@"%@\n",stringA);
    
    NSString *md5Sign = [stringA md5String];
    
    NSLog(@"%@",md5Sign);
    
    NSString *md5Sign1 = [stringA md5String];
    
    NSLog(@"%@",md5Sign1);
    
    NSMutableString *xmlString = [NSMutableString string];
    [xmlString appendString:@"<xml>\n"];
    
    for (NSString *key in sortArray) {
        [xmlString appendFormat:@"<%@>%@</%@>\n",key,dict[key],key];
    }
    
    [xmlString appendFormat:@"<sign>%@</sign>\n</xml>",md5Sign];

    NSLog(@"%@\n",xmlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.mch.weixin.qq.com/pay/unifiedorder"] cachePolicy:0 timeoutInterval:30];
    request.HTTPBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPMethod = @"POST";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@\n\n",str);
        
        NSString *prepayId = [str stringByMatching:@".prepay_id.+[wx(\\w+)].+prepay_id.+"];
        
        NSString *Id = [prepayId stringByMatching:@"wx(\\w+)" capture:YES];
        
        NSString *signId = [str stringByMatching:@"<sign.+[\\w{32}].+sign>"];
        
        NSString *returnSign = [signId stringByMatching:@"(\\w{32})" capture:YES];
        
        NSLog(@"%@",returnSign);
        self.sign = returnSign;
        
        NSLog(@"%@",Id);
        self.prepayId = Id;
    }];
}

-  (NSString *)md5Sign
{
    NSArray *newArray = [self.array sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        
        NSString *subString1 = [obj1 substringToIndex:1];
        NSString *subString2 = [obj2 substringToIndex:1];
        
        NSComparisonResult result = [subString1 compare:subString2];
        
        if (result == NSOrderedDescending) {
            return NSOrderedDescending;
        }else {
            return NSOrderedAscending;
        }
    }];
    
    NSLog(@"%@",newArray);
    
    NSMutableString *sign = [NSMutableString string];
    
    for (int i = 0; i<= newArray.count -1; i++) {
        NSString *key = [newArray objectAtIndex:i];
        NSString *value = self.dict[key];
        
        if (i<= newArray.count -2) {
            [sign appendFormat:@"%@=%@&",key,value];
        }else {
            [sign appendFormat:@"%@=%@",key,value];
        }
    }
    
    [sign appendFormat:@"&key=%@",@"13c1b7d24a771a2aa66c2cda0d753b55"];
    
    //    NSString *newSign = @"sign&key=13c1b7d24a771a2aa66c2cda0d753b55";
    
    
    NSLog(@"%@",sign);
    
    
    NSString *signMD5 = [sign md5String];
    
    NSString *upperSignMD5 = [signMD5 uppercaseString];
    
    NSLog(@"%@",upperSignMD5);
    
    return upperSignMD5;

}
- (IBAction)Pay:(id)sender {
    
    time_t now;
    time(&now);
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",now];
    
    NSString *nonceStr = [timeStamp md5String];
    NSString *appid= @"wx01079172808bb850"; // 此处是申请返回的微信AppId
    NSString *partnerId = @"1265687501"; // 商家账号
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:appid forKey:@"appid"];
    [dict setValue:partnerId forKey:@"partnerid"];
    [dict setValue:self.prepayId forKey:@"prepayid"];
    [dict setValue:@"Sign=WXPay" forKey:@"package"];  // 此处有坑，安卓中package是关键字，自己服务器返回的时候要注意。
    [dict setValue:timeStamp forKey:@"timestamp"];
    [dict setValue:nonceStr forKey:@"noncestr"];
    
    
    NSArray *array = dict.allKeys;
    
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString *appKey = @"13c1b7d24a771a2aa66c2cda0d753b55";
    NSLog(@"%@\n",sortArray);
    
    NSMutableString *stringA = [NSMutableString string];
    
    for (NSString *key in sortArray) {
        [stringA appendFormat:@"%@=%@&",key,dict[key]];
    }
    [stringA appendFormat:@"key=%@",appKey];
    
    
    NSLog(@"%@\n",stringA);
    
    NSString *md5Sign = [stringA md5String];
    
    NSLog(@"%@",md5Sign);
    
    PayReq *request = [[PayReq alloc] init];
//    request.openID = appid;
    request.partnerId = partnerId;
    request.prepayId = self.prepayId;
    request.package = @"Sign=WXPay";
    request.nonceStr= nonceStr;
    request.timeStamp = timeStamp.intValue;
    request.sign = md5Sign;
    NSLog(@"%@",request.sign);
    [WXApi sendReq:request];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
