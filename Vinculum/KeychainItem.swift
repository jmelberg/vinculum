//
//  KeychainItem.swift
//
//  Created by Jordan Melberg on 1/21/18.
//  Copyright (c) 2018 Jordan Melberg. All rights reserved.
//
//    The MIT License (MIT)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import Foundation

public class KeychainItem: NSObject, NSCoding {
    public var key: String
    public var value: Data
    public var expiration: TimeInterval?
    public var accessGroup: String?
    public var accessibility: CFString

    init(key: String, value: Data, expiration: TimeInterval? = nil, accessGroup: String? = nil, accessibility: CFString? = nil) {
        self.key = key
        self.value = value
        self.expiration = expiration
        self.accessGroup = accessGroup
        self.accessibility = accessibility != nil ? accessibility! : kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    }

    required public convenience init?(coder decoder: NSCoder) {
        self.init(
            key: decoder.decodeObject(forKey: "key") as! String,
            value: decoder.decodeObject(forKey: "value") as! Data,
            expiration: decoder.decodeObject(forKey: "expiration") as? TimeInterval,
            accessGroup: decoder.decodeObject(forKey: "accessGroup") as? String,
            accessibility: (decoder.decodeObject(forKey: "accessibility") as! CFString)
        )
    }

    public func encode(with coder: NSCoder) {
        coder.encode(self.key, forKey: "key")
        coder.encode(self.value, forKey: "value")
        coder.encode(self.expiration, forKey: "expiration")
        coder.encode(self.accessGroup, forKey: "accessGroup")
        coder.encode(self.accessibility, forKey: "accessibility")
    }

    public func getString() -> String? {
        guard let item = String(data: self.value, encoding: .utf8) else {
            return nil
        }
        return item
    }
}
