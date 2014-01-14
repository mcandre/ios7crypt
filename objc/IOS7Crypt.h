static const unsigned int XLAT[];
static const unsigned int XLAT_LEN;

@interface IOS7Crypt: NSObject

+ (NSString*) encrypt: (const NSString*) password;
+ (NSString*) decrypt: (const NSString*) hash;

+ (void) __attribute__((noreturn)) usage: (char*) program;

@end
