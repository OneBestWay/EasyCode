//
//  StringExtension.swift
//  NetWork
//
//  Created by GK on 2017/1/11.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation

extension String {
    //输入的文字音译
    func transliterationToPinYin() -> String {
        let str = NSMutableString(string: self) as CFMutableString
        var cfRange = CFRangeMake(0, CFStringGetLength(str))
        //转变为拉丁文
        let latinSuccess = CFStringTransform(str, &cfRange, kCFStringTransformToLatin, false)
        
        //去掉音调
        if latinSuccess {
            let combiningMarksSuccess = CFStringTransform(str, &cfRange, kCFStringTransformStripCombiningMarks, false)
            if combiningMarksSuccess {
                //转为小写
                CFStringLowercase(str, nil)
                //去掉空格
                CFStringTrimWhitespace(str)
            }
        }
        return str as String
    }
    //首字母大写
    func wordFirstLetterUpperCase() -> String {
        
        let str = NSMutableString(string: self) as CFMutableString
        var cfRange = CFRangeMake(0, CFStringGetLength(str))
        
        CFStringTransform(str, &cfRange, "Any-Title" as CFString, false)
        return str as String
    }
    //保证输出的都是ASCII字符
    func transferToASCII() -> String {
        
        let str = NSMutableString(string: self) as CFMutableString
        var cfRange = CFRangeMake(0, CFStringGetLength(str))
        
        CFStringTransform(str, &cfRange, "Any-Latin; Latin-ASCII; [:^ASCII:] Remove" as CFString, false)
        return str as String
    }
    //去掉首尾空格
    func  removeWhiteSpaceAndNewLine() -> String {
        let whitespace = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    //去掉所有的空格
    func removeAllWhiteSpace() -> String {
        let words = self.tokenize()
        let resultString = words.joined(separator: "")
        return resultString
    }
    //分词
    func separatedByCharacter() -> [String] {
        
        var characters = CharacterSet.whitespacesAndNewlines
        let punctuation = CharacterSet.punctuationCharacters
        
        characters.formUnion(punctuation)
        characters.remove(charactersIn: "'")
        
        let words = self.components(separatedBy: characters).filter({ x in !x.isEmpty
        })
        
        return words
    }
    
    func tokenize() -> [String] {
        let inputRange = CFRangeMake(0, self.utf16.count)
        let flag = UInt(kCFStringTokenizerUnitWord)
        let locale = CFLocaleCopyCurrent()
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, self as CFString!, inputRange, flag, locale)
        var tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        var tokens: [String] = []
        
        while tokenType == CFStringTokenizerTokenType.normal {
            let currentTokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let subString = self.substringWithRange(aRange: currentTokenRange)
            tokens.append(subString)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        return tokens
    }
    private func substringWithRange(aRange: CFRange) -> String {
        let range = NSMakeRange(aRange.location, aRange.length)
        let subString = (self as NSString).substring(with: range)
        return subString
    }
    
    func separateString() -> [String] {
        var words = [String]()
        let range = self.startIndex ..< self.endIndex
        self.enumerateSubstrings(in: range, options: String.EnumerationOptions.byWords) {
            w,_,_,_ in
            guard  let word = w else { return }
            words.append(word)
        }
        return words
    }
    func linguisticTokenize() -> [String] {
        let options: NSLinguisticTagger.Options = [.omitWhitespace,.omitPunctuation,.omitOther]
        let schemes = [NSLinguisticTagSchemeLexicalClass]
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        let range = NSMakeRange(0, (self as NSString).length)
        tagger.string = self
        
        var tokens: [String] = []
        
        tagger.enumerateTags(in: range, scheme: NSLinguisticTagSchemeLexicalClass, options: options) { (tag, tokenRange,_,_) in
            let token = (self as NSString).substring(with: tokenRange)
            tokens.append(token)
        }
        return tokens
    }
    
}
extension String {
    static func UUIDString() -> String {
        return UUID().uuidString
    }
}

extension String {
    func MD5() -> String {

        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deinitialize(count: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format: "%02x", byte)
        }
        return hexString
    }
}



































