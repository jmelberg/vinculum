//
//  Keychain.swift
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

public class Keychain: NSObject {
    class func set(key: String, value: String, expiration: TimeInterval? = nil, accessGroup: String? = nil, accessibility: CFString? = nil) throws {
        // Write a value (String) to the keychain
        guard let object = value.data(using: .utf8) else {
            throw KeychainError.utf8EncodingError
        }

        let item = KeychainItem(
            key: key,
            value: object,
            expiration: expiration,
            accessGroup: accessGroup,
            accessibility: accessibility
        )

        try writeToKeychain(item: item)

        if let seconds = item.expiration {
            buildTimeout(item.key, seconds)
        }
    }

    class func set(key: String, value: Data, expiration: TimeInterval? = nil, accessGroup: String? = nil, accessibility: CFString? = nil) throws {
        // Write a value (Data) to the keychain
        let item = KeychainItem(
            key: key,
            value: value,
            expiration: expiration,
            accessGroup: accessGroup,
            accessibility: accessibility
        )

        try writeToKeychain(item: item)

        if let seconds = item.expiration {
            buildTimeout(item.key, seconds)
        }
    }

    internal class func writeToKeychain(item: KeychainItem) throws {
        // Encode and store Keychain item
        let encodedItem = NSKeyedArchiver.archivedData(withRootObject: item)

        var q = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecValueData as String: encodedItem,
            kSecAttrAccount as String: item.key,
            kSecAttrAccessible as String: item.accessibility
        ] as [String : Any]

        if let accessGroup = item.accessGroup {
            // Access Group present
            q[kSecAttrAccessGroup as String] = accessGroup
        }

        // Delete existing (if applicable)
        SecItemDelete(q as CFDictionary)

        // Store to keychain
        let sanityCheck = SecItemAdd(q as CFDictionary, nil)
        if sanityCheck != noErr {
            throw KeychainError.failedToStore(sanityCheck.description)
        }
    }

    class func get(_ key: String) throws -> KeychainItem {
        // Return the keychain item as a string
        let q = [
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccount as String: key,
        ] as CFDictionary

        var ref: AnyObject? = nil

        let sanityCheck = SecItemCopyMatching(q, &ref)

        if sanityCheck != noErr {
            throw KeychainError.failedToRetrieve(sanityCheck.description)
        }
        if let encodedItem = ref as? Data {
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: encodedItem) as? KeychainItem else {
                throw KeychainError.failedToDecode
            }
            return item
        }
        throw KeychainError.failedToEncode(key)
    }

    class func remove(_ key: String) throws {
        let item = try self.get(key)

        let encodedItem = NSKeyedArchiver.archivedData(withRootObject: item)

        let q = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecValueData as String: encodedItem,
            kSecAttrAccount as String: item.key,
            kSecAttrAccessible as String: item.accessibility
        ] as [String : Any]

        // Delete existing (if applicable)
        let sanityCheck = SecItemDelete(q as CFDictionary)

        guard sanityCheck == errSecSuccess || sanityCheck == errSecItemNotFound else {
            throw KeychainError.failedToRemove(sanityCheck.description)
        }
    }

    class func removeAll() {
        // Remove all known keychain items
        let secItemClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ]

        for secItemClass in secItemClasses {
            let dictionary = [ kSecClass as String:secItemClass ] as CFDictionary
            SecItemDelete(dictionary)
        }
    }

    internal class func buildTimeout(_ key: String, _ seconds: TimeInterval ) {
        // Deletes the item in the keychain after 'time'
        DispatchQueue.global().asyncAfter(deadline: .now() + seconds, execute : {
            guard let _ = try? remove(key) else {
              print("Failed removing \(key) from keychain.")
              return
            }
        })
    }
}
