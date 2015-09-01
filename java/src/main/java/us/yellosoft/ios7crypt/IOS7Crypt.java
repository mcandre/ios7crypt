package us.yellosoft.ios7crypt;

import java.util.Random;

import com.google.common.collect.Iterables;

public final class IOS7Crypt {
  private IOS7Crypt() {}

  public static final Iterable<Integer> XLAT = Iterables.cycle(
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
  );

  public static String encrypt(final String password) {
    if (password.length() < 1) {
      return "";
    }

    final int seed = (int)(new Random().nextDouble() * 16);

    final StringBuilder stringBuilder = new StringBuilder();

    stringBuilder.append(String.format("%02d", seed));

    for (int i = 0; i < password.length() && i < 11; i++) {
      int encryptedByte = Iterables.get(XLAT, seed + i) ^ password.charAt(i);
      stringBuilder.append(String.format("%02x", encryptedByte));
    }

    return stringBuilder.toString();
  }

  public static String decrypt(final String hash) {
    if (hash.length() < 1) {
      return "";
    } else if (hash.length() % 2 != 0) {
      return "";
    }

    try {
      final StringBuilder stringBuilder = new StringBuilder();

      final int seed = Integer.parseInt(hash.substring(0, 2));

      for (int i = 2; i + 1 < hash.length(); i += 2) {
        int encryptedByte = Integer.parseInt(hash.substring(i, i + 2), 16);
        stringBuilder.append((char)(encryptedByte ^ Iterables.get(XLAT, seed + i/2 - 1)));
      }

      return stringBuilder.toString();
    } catch (NumberFormatException e) {
      return "";
    }
  }
}
