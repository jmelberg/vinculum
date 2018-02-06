import UIKit
import XCTest
import Vinculum

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        Vinculum.removeAll()
    }
    
    func testSetStringAndRetrieveFromKeychain() {
        XCTAssertNoThrow(try Vinculum.set(key: "test-abc123", value: "abc12345"))
        guard let val = try? Vinculum.get("test-abc123") else {
            return XCTFail()
        }
        XCTAssertEqual(val!.getString()!, "abc12345")
    }
    
    func testSetStringAndRetrieveFromKeychainWithAccessGroup() {
        XCTAssertNoThrow(try Vinculum.set(key: "test-abc123-group", value: "abc12345-group", accessGroup: "com.jmelberg.demo"))
        guard let val = try? Vinculum.get("test-abc123-group") else {
            return XCTFail()
        }
        XCTAssertEqual(val!.getString()!, "abc12345-group")
    }
    
    func testSetStringAndRetrieveFromKeychainWithExpiry() {
        // Set a 2 second expirty
        let timeout = 2 as TimeInterval

        XCTAssertNoThrow(try Vinculum.set(key: "test-abc123-expiry", value: "abc12345-expiry", expiration: timeout))

        // Wait 5 seconds for timeout to succeed
        sleep(5)

        XCTAssertThrowsError(try Vinculum.get("test-abc123-expiry")) { error in
            let desc = error as! KeychainError
            XCTAssertEqual(desc.localizedDescription, "Error retrieving from Keychain: -25300")
        }
    }
    
    func testSetDataAndRetrieveFromKeychain() {
        guard let stringData = "abc12345".data(using: .utf8) else {
            return XCTFail()
        }
        XCTAssertNoThrow(try Vinculum.set(key: "test-data-abc1234", value: stringData ))
        guard let val = try? Vinculum.get("test-data-abc1234") else {
            return XCTFail()
        }
        XCTAssertEqual(val!.value, stringData)
    }
    
    func testGetUnknownKeychainItem() {
        XCTAssertThrowsError(try Vinculum.get("fakeKey")) { error in
            let desc = error as! KeychainError
            XCTAssertEqual(desc.localizedDescription, "Error retrieving from Keychain: -25300")
        }
    }
    
    func testRemoveKeychainItem() {
        guard let stringData = "abc12345".data(using: .utf8) else {
            return XCTFail()
        }
        XCTAssertNoThrow(try Vinculum.set(key: "test-data-remove-abc1234", value: stringData ))
        XCTAssertNoThrow(try Vinculum.remove("test-data-remove-abc1234"))
    }
    
    func testRemoveNonExistantKeychainItem() {
        XCTAssertThrowsError(try Vinculum.remove("test-data-remove-i-dont-exist")) { error in
            let desc = error as! KeychainError
            XCTAssertEqual(desc.localizedDescription, "Error retrieving from Keychain: -25300")
        }
    }
}
