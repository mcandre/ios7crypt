package us.yellosoft.ios7crypt

import java.util.Random

object IOS7Crypt {
  val XLAT = Array(
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
  )

  val XLAT_LEN = XLAT.length

  val random = new Random

  def encrypt(password : String) : String = {
    val len = password.length

    len match {
      case 0 => ""
      case _ => {
        var seed = (random.nextDouble * 16).toInt

        var hash = String.format("%02d", new Integer(seed))

        (0 to len - 1).foreach { i : Int =>
          val encryptedByte = XLAT(seed % XLAT_LEN) ^ password.charAt(i)
          seed += 1

          hash += String.format("%02x", new Integer(encryptedByte))
        }

        hash
      }
    }
  }

  def decrypt(hash : String) : String = {
    val len = hash.length

    len match {
      case 0 => ""
      case _ => try {
        var password = ""

        var seed = Integer.parseInt(hash.substring(0, 2))

        List.range(2, len, 2).foreach { i : Int =>
          val encryptedByte = Integer.parseInt(hash.substring(i, i + 2), 16)
          password += (encryptedByte ^ XLAT(seed % XLAT_LEN)).toChar
          seed += 1
        }

        password
      }
      catch {
        case e : NumberFormatException => ""
      }
    }
  }

  def main(args : Array[String]) : Unit = {
    if (args.length < 2) {
      println("Usage: ios7crypt (-e <password>) | (-e <hash>)")
    }
    else if (args(0) == "-e") {
      val password = args(1)
      println(encrypt(password))
    }
    else if (args(0) == "-d") {
      val hash = args(1)
      println(decrypt(hash))
    }
  }
}
