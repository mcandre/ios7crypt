#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <string.h>
#import "IOS7Crypt.h"

static const unsigned int XLAT[] = {
  0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
  0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
  0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
  0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
  0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
  0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
  0x3b, 0x66, 0x67, 0x38, 0x37
};

static const unsigned int XLAT_LEN = 53;

@implementation IOS7Crypt

+ (NSString*) encrypt: (const NSString*) password {
  unsigned int length = (unsigned int) [password length];

  if (length < 1) {
    return @"";
  }

  const char* password_cstring = [password UTF8String];

  unsigned int seed = arc4random() % 16;

  NSMutableArray* ciphertext = [NSMutableArray arrayWithCapacity: length];

  for (unsigned int i = 0; i < length; i++) {
    unsigned int p = (unsigned int) password_cstring[i];

    unsigned int k = XLAT[(i + seed) % XLAT_LEN];

    unsigned int cipherbyte = p ^ k;

    [ciphertext addObject: [NSNumber numberWithUnsignedInt: cipherbyte]];
  }

  NSString* hash = [NSString stringWithFormat: @"%02d", seed];

  for (unsigned int i = 0; i < length; i++) {
    unsigned int c = [(NSNumber*) [ciphertext objectAtIndex: i] unsignedIntValue];

    hash = [hash stringByAppendingString: [NSString stringWithFormat: @"%02x", c]];
  }

  return hash;
}

+ (NSString*) decrypt: (const NSString*) hash {
  unsigned int length = (unsigned int) [hash length];

  if (length < 4) {
    return @"";
  }

  unsigned int seed = (unsigned int) [[hash substringToIndex: 2] intValue];

  NSMutableArray* plaintext = [NSMutableArray arrayWithCapacity: (length - 2) / 2];

  for (unsigned int i = 0; i < (length - 2) / 2; i++) {
    NSScanner* scanner = [NSScanner scannerWithString:[hash substringWithRange: NSMakeRange(2 + i * 2, 2)]];

    unsigned int c;
    [scanner scanHexInt: &c];

    unsigned int k = XLAT[(i + seed) % XLAT_LEN];

    unsigned int p = c ^ k;

    [plaintext addObject: [NSNumber numberWithUnsignedInt: p]];
  }

  NSString* password = @"";

  for (unsigned int i = 0; i < (length - 2) / 2; i++) {
    unsigned int p = [(NSNumber*) [plaintext objectAtIndex: i] unsignedIntValue];

    NSString* s = [NSString stringWithFormat: @"%c", (char) p];

    password = [password stringByAppendingString: s];
  }

  return password;
}

+ (void) __attribute__((noreturn)) usage: (char*) program {
  printf("Usage: %s\n", program);
  printf("-e --encrypt <password>\tEncrypt a password\n");
  printf("-d --decrypt <hash>\tDecrypt a hash\n");
  printf("-h --help\tPrint usage info\n");

  exit(0);
}

int main(int argc, char** argv) {
  if (argc < 2) {
    [IOS7Crypt usage: argv[0]];
  }
  else if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0) {
    [IOS7Crypt usage: argv[0]];
  }
  else if (strcmp(argv[1], "-e") == 0 || strcmp(argv[1], "--encrypt") == 0) {
    if (argc < 3) {
      [IOS7Crypt usage: argv[0]];
    }
    else {
      NSString* password = [NSString stringWithUTF8String: argv[2]];
      NSString* hash = [IOS7Crypt encrypt: password];

      printf("%s\n", [hash UTF8String]);
    }
  }
  else if (strcmp(argv[1], "-d") == 0 || strcmp(argv[1], "--decrypt") == 0) {
    if (argc < 3) {
      [IOS7Crypt usage: argv[0]];
    }
    else {
      NSString* hash = [NSString stringWithUTF8String: argv[2]];
      NSString* password = [IOS7Crypt decrypt: hash];

      printf("%s\n", [password UTF8String]);
    }
  }
}

@end
