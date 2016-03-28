

#import <Foundation/Foundation.h>

@interface NSString (Hash)


- (NSString *)md5String;

- (NSString *)sha1String;

- (NSString *)sha256String;

- (NSString *)sha512String;

- (NSString *)hmacMD5StringWithKey:(NSString *)key;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

- (NSString *)fileMD5Hash;

- (NSString *)fileSHA1Hash;

- (NSString *)fileSHA256Hash;

- (NSString *)fileSHA512Hash;

@end
