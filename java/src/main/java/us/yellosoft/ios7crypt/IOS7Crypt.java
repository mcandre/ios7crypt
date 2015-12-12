package us.yellosoft.ios7crypt;

import java.util.Random;
import java.util.stream.IntStream;

import com.google.common.collect.Iterables;

/** Cisco IOSv7 password encryptor/decryptor */
public final class IOS7Crypt {
  /** Static key */
  public static final Iterable<Integer> XLAT = Iterables.cycle(
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
  );

  private static Random random = new Random();

  /** Utility class */
  private IOS7Crypt() {}

  /** Encrypt password
      @param password an ASCII-formatted password
      @return Cisco IOSv7 encrypted hash
   */
  public static String encrypt(final String password) {
    if (password.length() < 1) {
      return "";
    }

    final int seed = random.nextInt(16);

    return String.format(
      "%02d%s",
      seed,
      String.join(
        "",
        IntStream.range(0, password.length()).parallel().mapToObj(
          (final int i) -> String.format("%02x", Iterables.get(XLAT, seed + i) ^ password.charAt(i))
        ).toArray(String[]::new)
      )
    );
  }

  /** Decrypt a hash
      @param hash a Cisco IOSv7-encrypted hash
      @return an ASCII password
   */
  public static String decrypt(final String hash) {
    if (hash.length() < 1) {
      return "";
    }

    try {
      final int seed = Integer.parseInt(hash.substring(0, 2));
      final String encryptedPassword = hash.substring(2);

      return String.join(
        "",
        IntStream.range(0, encryptedPassword.length() / 2).parallel().mapToObj(
          (final int i) -> Character.toString((char) (Integer.parseInt(encryptedPassword.substring(i * 2, i * 2 + 2), 16) ^ Iterables.get(XLAT, seed + i)))
        ).toArray(String[]::new)
      );
    } catch (NumberFormatException e) {
      return "";
    }
  }
}
