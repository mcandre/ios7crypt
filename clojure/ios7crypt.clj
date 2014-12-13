":";exec lein exec $0 ${1+"$@"}

(ns args
  (:gen-class))

(use '[clojure.string :only (join)])

(import '(java.util Random))
(def R (new Random))

(def XLAT
  '(
    0x64 0x73 0x66 0x64 0x3b 0x6b 0x66 0x6f
    0x41 0x2c 0x2e 0x69 0x79 0x65 0x77 0x72
    0x6b 0x6c 0x64 0x4a 0x4b 0x44 0x48 0x53
    0x55 0x42 0x73 0x67 0x76 0x63 0x61 0x36
    0x39 0x38 0x33 0x34 0x6e 0x63 0x78 0x76
    0x39 0x38 0x37 0x33 0x32 0x35 0x34 0x6b
    0x3b 0x66 0x67 0x38 0x37))
(def XLAT-LEN (count XLAT))

(defn encrypt [password]
  (let [len (count password)]
    (if (< len 1)
      ""
      (let [seed (int (* (.nextDouble R) 16))
            hash (format "%02d" seed)]
        (format
         "%s%s"
         hash
         (join
          ""

          (for [i (range len)]
            (let [key (nth XLAT (mod (+ seed i) XLAT-LEN))]
              (format
               "%02x"
               (bit-xor key (byte (.charAt password i))))))))))))

(defn decrypt [hash]
  (let [len (count hash)]
    (if (or (< len 1) (not= (mod len 2) 0))
      ""
      (try
        (let [seed (Integer/parseInt (.substring hash 0 2))]
          (join
           ""
           (for [i (range (/ (- len 2) 2))]
             (let [key (nth XLAT (mod (+ seed i) XLAT-LEN))
                   j (+ (* i 2) 2)
                   cipher (Integer/parseInt (.substring hash j (+ j 2)) 16)]
               (char (bit-xor key cipher))))))
        (catch NumberFormatException e
          "")))))

(defn usage []
  (println "Usage: ios7crypt.clj [OPTION]")
  (println "-e --encrypt <password>\tEncrypt a password")
  (println "-d --decrypt <hash>\tDecrypt a hash"))

(defn -main [& args]
  (if (not= (count args) 2)
    (usage)
    (let [option (nth args 0)
          value (nth args 1)]
      (if (or (= option "-e") (= option "--encrypt"))
        (println (encrypt value))
        (println (decrypt value))))))

(when (.contains (first *command-line-args*) *source-path*)
  (apply -main (rest *command-line-args*)))
