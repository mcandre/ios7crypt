#import <Foundation/Foundation.h>
#include <stdlib.h>
#import "IOS7Crypt.h"

@implementation IOS7Crypt

+ (NSArray*) xlat {
  static NSArray* key = [NSArray arrayWithObjects:
                                 0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
                                 0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
                                 0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
                                 0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
                                 0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
                                 0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
                                 0x3b, 0x66, 0x67, 0x38, 0x37, nil];

  return key;
}

+ (NSArray*) xlat: (NSUInteger) start andLength: (NSUInteger) length {
  NSArray* key = [NSMutableArray initWithCapacity: length];

  for (int i = 0; i < length; i++) {
    [key addObject: [[IOS7Crypt xlat] objectAtIndex: i]];
  }

  return key;
}

+ (NSString*) encrypt: (const NSString*) password {
  NSUInteger length = [password length];

  if (length < 1) {
    return @"";
  }

  NSUInteger seed = arc4random() % 16;

  NSArray* key = [IOS7Crypt xlat: seed length: length];

  NSArray* ciphertext = [NSMutableArray initWithCapacity: length];

  for (int i = 0; i < length; i++) {
    NSUInteger p = (NSUInteger) [password characterAt: i];

    NSUInteger k = [key objectAtIndex: i];

    NSUInteger cipherbyte = p ^ k;

    [ciphertext addObject: cipherbyte];
  }

  NSString* hash = [NSString initWithFormat: @"%02d", seed];

  for (int i = 0; i < length; i++) {
    NSUInteger c = [ciphertext objectAtIndex: i];

    hash = [hash stringByAppendingString: [NSString initWithFormat: @"%02x", c]];
  }

  return hash;
}

+ (NSString*) decrypt: (const NSString*) hash {
  // ...
}

int main() {
  // ...
}

@end
