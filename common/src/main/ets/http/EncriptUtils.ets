import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { isEmpty } from '../utils';


const ivParameter: string = "zmtq20210512vpro";
const sKey: string = "zmtq20210512vpro";
const PROTO_ENCRYPT_KEY: string = "zmtq";

function genIvParamsSpec() {
  let dataIv = stringToUint8Array(ivParameter)
  let ivBlob: cryptoFramework.DataBlob = { data: dataIv };
  let ivParamsSpec: cryptoFramework.IvParamsSpec = {
    algName: "IvParamsSpec",
    iv: ivBlob
  };
  return ivParamsSpec;
}

// 加密消息
async function encryptMessagePromise(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('AES128|CBC|PKCS7');
  let iv = genIvParamsSpec();
  await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, iv);
  let cipherData = await cipher.doFinal(plainText);
  return cipherData;
}

// 解密消息
async function decryptMessagePromise(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('AES128|CBC|PKCS7');
  let iv = genIvParamsSpec();
  await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, iv);
  let decryptData = await decoder.doFinal(cipherText);
  return decryptData;
}

async function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
  let symKey = await aesGenerator.convertKey(symKeyBlob);
  console.info('convertKey success');
  return symKey;
}

export async function toAESEncrypt(content: string) {
  try {
    let keyData = stringToUint8Array(sKey)
    let symKey = await genSymKeyByData(keyData)
    let plainText: cryptoFramework.DataBlob = { data: stringToUint8Array(content) }
    let encryptText = await encryptMessagePromise(symKey, plainText)
    return encryptText.data
  } catch (error){
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    console.error('error failed ' + code + " == " + message);
  }
  return null
}

export async function toAESDecrypt(array: Uint8Array) {
  try {
    let keyData = stringToUint8Array(sKey)
    let symKey = await genSymKeyByData(keyData);
    let contentData: cryptoFramework.DataBlob = { data: array }
    let decryptText = await decryptMessagePromise(symKey, contentData);
    return uint8ArrayToString(decryptText.data)
  } catch (error){
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    console.error('error failed ' + code + " == " + message);
  }
  return ''
}

export function toBase64Encrypt(array: Uint8Array) {
  try {
    let base64Helper = new util.Base64Helper
    return base64Helper.encodeToStringSync(array)
  } catch (error){
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    console.error('error failed ' + code + " == " + message);
  }
  return ''
}

export function toBase64Decrypt(content: string) {
  try {
    let base64Helper = new util.Base64Helper
    return base64Helper.decodeSync(content)
  } catch (error){
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    console.error('error failed ' + code + " == " + message);
  }
  return ''
}

export function toXor(content: string) {
  let data: Uint8Array = stringToUint8Array(content)
  try {
    let len: number = data.length
    let lenKey: number = PROTO_ENCRYPT_KEY.length
    let i: number = 0
    let j: number = 0
    while (i < len) {
      if (j >= lenKey) {
        j = 0;
      }
      let keyChar = PROTO_ENCRYPT_KEY.charCodeAt(j)
      data[i] = (data[i] ^ keyChar)
      i++;
      j++;
    }
  } catch (error){
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    console.error('error failed ' + code + " == " + message);
  }
  return data
}

export async function getMd5(value: string): Promise<string> {
  return new Promise((resolve, reject) => {
    if (isEmpty(value)) {
      resolve(value)
    }
    let md: cryptoFramework.Md = cryptoFramework.createMd('MD5')
    md.update({ data: stringToUint8Array(value) }).then(() => {
      return md.digest()
    }).then((data: cryptoFramework.DataBlob) => {
      let hexString: string = uint8ArrayToHexString(data.data)
      resolve(hexString)
    }).catch((error: BusinessError) => {
      console.error("Utils: toMd5, error: " + error);
      resolve(value)
    })
  })
}

export function uint8ArrayToHexString(data: Uint8Array): string {
  let hexString: string = '';
  data.forEach((value: number, index: number) => {
    hexString += value.toString(16).padStart(2, '0').toUpperCase()
  })
  return hexString
}


export async function aesCBC(): Promise<string> {
  try {
    let keyData = stringToUint8Array(sKey)
    let symKey = await genSymKeyByData(keyData);
    let message: string = "This is a test";
    let plainText: cryptoFramework.DataBlob = { data:  stringToUint8Array(message)};
    let encryptText = await encryptMessagePromise(symKey, plainText);

    let testData = uint8ArrayToString(encryptText.data)
    console.info('decrypt encryptText: ' + testData);

    let encryptData: cryptoFramework.DataBlob = {data: stringToUint8Array(testData)};

    let decryptText = await decryptMessagePromise(symKey, encryptData);

    console.info('decrypt plainText: ' + uint8ArrayToString(decryptText.data));

    // if (plainText.data.toString() === decryptText.data.toString()) {
    //   console.info('decrypt ok');
    //   console.info('decrypt plainText: ' + uint8ArrayToString(decryptText.data));
    // } else {
    //   console.error('decrypt failed');
    // }

    return testData

  } catch (error){
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;

    console.error('error failed ' + code + " == " + message);
  }
  return ''
}

//string转Uint8Array
export function stringToUint8Array(str: string): Uint8Array {
  let arr: Array<number> = [];
  for (let i = 0, j = str.length; i < j; i++) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

export function uint8ArrayToString(unit: Uint8Array): string {
  return Array.from(unit).map(charCode => String.fromCharCode(charCode)).join('');
}

export function uint8ArrayToString2(uint8Array: Uint8Array): string {
  const textDecoder = util.TextDecoder.create("utf-8")
  return textDecoder.decodeWithStream(uint8Array, { stream: false })
}