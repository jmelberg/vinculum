//
//  Vinculum.swift
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

public class Vinculum: NSObject {
    public class func set(key: String, value: String, expiration: TimeInterval? = nil, accessGroup: String? = nil, accessibility: CFString? = nil) throws {
        try Keychain.set(key: key, value: value, expiration: expiration, accessGroup: accessGroup, accessibility: accessibility)
    }

    public class func set(key: String, value: Data, expiration: TimeInterval? = nil, accessGroup: String? = nil, accessibility: CFString? = nil) throws {
        try Keychain.set(key: key, value: value, expiration: expiration, accessGroup: accessGroup, accessibility: accessibility)
    }

    public class func get(_ key: String) throws -> KeychainItem? {
        return try Keychain.get(key)
    }

    public class func remove(_ key: String) throws {
        return try Keychain.remove(key)
    }

    public class func removeAll() {
        return Keychain.removeAll()
    }
}
