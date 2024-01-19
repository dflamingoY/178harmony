import cryptoFramework from '@ohos.security.cryptoFramework'
import util from '@ohos.util';
import LogUtil from './LogUtil';

let pri_pem =
  "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" +
  "LXcI1bwOt3SvC6luWjFShSNlmJb2Hf4=";

let pub_pem = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwgOmq7Nr68dlGFlrZC7l" +
"nmOgHrXgZ2wEr1xuz3njKRac2Xa91yLt8hxirpZDDnEQNW1iDnqCNZpxaAMzm98j" +
"KdT6pywXQ7R0Tnb8GcJm8DZnKYa5BOqJXTrYRgaf0eQbjz8QxmZ2AcPXHjwACzAP" +
"0GQx4OEx2GYZI8/Be8GxftunJ8FQB8wCvMw/YE7yBLbcxgeJYe7JmQdyHC5f8TCR" +
"K4j+2JCpoXeWVSSXdG+AZYnboZAuBz7FvYv2Kj6yNRlDPHzuXWvF/MD33dOyFRnZ" +
"H29/c+ntt3ZlLBznWRJi2HKTrH7CViy4lQEK8ybHmQ/+PmuYfoJxZrvBYcPmHbap" +
"tK7BY9zOJnCbMzYAU8GdANv+ESnOTkWl1dkagJh9xUtpqc77h48OI+Sxldd0wmKo" +
"xq6acun8NOVyMmY1bXrPeL5SF8qpcRO7iAJ2nNeS12vSw3IEslmqu/9oOswcD3rr" +
"GT+IEvgr8qVdWQZSg9aFPFb8oKak21YJo86TXVR/cYoKKTubAR1G9GR2sT7YKTt7" +
"/Fs4mUQSN2A8g9fP+pRrFfgFE0G2Qfb1nkwtBS+7UpGqqqYRVeTWK+QxVPCbmYJJ" +
"Di1ohg8f4luhr9OphQt/oZSD52Di+UBPaqKJN1ix/rKEvv/VDne3zPAIeWjnohaJ" +
"Fz0cXj1kYMgJ45e3qWMrKXECAwEAAQ==";


export class RsaUtil {
  static encrypt(encrypt: string[]) {
    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    let decoder = cryptoFramework.createCipher("RSA1024|PKCS1");
    var base64 = new util.Base64()
    let cipherData;
    let keyPair;
    rsaGenerator.generateKeyPair(function (err, newKeyPair) {
      keyPair = newKeyPair;
      cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null, function (err, data) {
        encrypt.forEach((value: string) => {
          let input = { data: base64.encodeSync(this.stringToUint8Array(encrypt)) };
          cipher.doFinal(input, function (err, data) {
            cipherData = data;
            decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null, function (err, data) {
              decoder.doFinal(cipherData, function (err, data) {
                if (input.data.toString() === data.data.toString()) {
                  return;
                }
              });
            });
          });
        })
      });
    });
  }

  static decrypt(encrypt: string[]) {

    /*let decoder = cryptoFramework.createCipher("RSA1024|PKCS1");
    var base64 = new util.Base64()
    base64.encode(this.stringToUint8Array(pub_pem))
      .then((value) => {
        cryptoFramework.createAsyKeyGenerator("RSA1024")
          .convertKey({
            data: value
          }, null*//*{
            data: value
          }*//*, (error, data) => {
            if (error) {
              AlertDialog.show({ message: "Convert keypair fail " + error.code });
            } else
              AlertDialog.show({ message: "Convert KeyPair success" });
          })
      })*/
    /*.then((pari) => {
      try {
        encrypt.forEach((value: string) => {
          let input = { data: base64.encodeSync(this.stringToUint8Array(value)) };
          decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, pari.priKey, null, function (err, data) {
            decoder.doFinal(input, function (err, data) {
              LogUtil.d("West", `解密结果： ${data}`)
            });
          });
        })
      } catch (e) {
        LogUtil.d("West", `解密结果 catch： ${e}`)
      }
    }).catch((err: Error) => {
    LogUtil.d("West", `解密 catch： ${err.message}`)
  })*/

    /*
        let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
        let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
        let decoder = cryptoFramework.createCipher("RSA1024|PKCS1");
        let plainText = "this is cipher text";
        let input = {data : this.stringToUint8Array(plainText) };
        let cipherData;
        let keyPair;
        rsaGenerator.generateKeyPair(function (err, newKeyPair) {
          keyPair = newKeyPair;
          cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null, function (err, data) {
            cipher.doFinal(input, function (err, data) {
              AlertDialog.show({ message : "EncryptOutPut is " + data.data} );
              cipherData = data;
              decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null, function (err, data) {
                decoder.doFinal(cipherData, function (err, data) {
                  if (input.data.toString() === data.data.toString()) {
                    AlertDialog.show({ message : "decrype success"} );
                    return;
                  }
                  AlertDialog.show({ message : "decrype fail"} );
                });
              });
            });
          });
        });*/


  }

  static stringToUint8Array(str: string) {
    var arr = [];
    for (var i = 0, j = str.length; i < j; ++i) {
      arr.push(str.charCodeAt(i));
    }
    var tmpArray = new Uint8Array(arr);
    return tmpArray;
  }
}
