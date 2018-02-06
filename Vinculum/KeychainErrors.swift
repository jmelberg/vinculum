//
//  KeychainError.swift
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

public enum KeychainError: Error {
    case utf8EncodingError
    case failedToStore(Any)
    case failedToRetrieve(Any)
    case failedToDecode
    case failedToEncode(String)
    case failedToRemove(String)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .utf8EncodingError:
                return NSLocalizedString("Error converting data object to UTF8", comment: "")
            case .failedToStore(reason: let reason):
                return NSLocalizedString("Error storing to Keychain: \(reason)", comment: "")
            case .failedToRetrieve(reason: let reason):
                return NSLocalizedString("Error retrieving from Keychain: \(reason)", comment: "")
            case .failedToDecode:
                return NSLocalizedString("Error decoding keychain item", comment: "")
            case .failedToEncode(key: let key):
                return NSLocalizedString("Error encoding keychain item to Data type with key: \(key)", comment: "")
            case .failedToRemove(reason: let reason):
                return NSLocalizedString("Error removing keychain item: \(reason)", comment: "")
        }
    }
}

