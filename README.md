# Vinculum
[![Version](https://img.shields.io/cocoapods/v/vinculum.svg?style=flat)](http://cocoapods.org/pods/vinculum)
[![License](https://img.shields.io/cocoapods/l/vinculum.svg?style=flat)](http://cocoapods.org/pods/vinculum)
[![Platform](https://img.shields.io/cocoapods/p/vinculum.svg?style=flat)](http://cocoapods.org/pods/vinculum)

Vinculum is a simple wrapper around common iOS Keychain interactions.

### Why name it `vinculum`?
Via [WolframMathworld](http://mathworld.wolfram.com/Vinculum.html):

> Vinculum is a horizontal line placed above multiple quantities to indicate that they form a unit.

Similarly, this library provides any developer (yes, that's you), the ability to group together passwords, access/identity tokens, PII, and other sensitive user data into a common (and secure) place. As a secure storage mechinism for iOS devices, Vinculum attempts to make access to and from the [iOS Keychain](https://developer.apple.com/library/content/documentation/Security/Conceptual/keychainServConcepts/02concepts/concepts.html) as easy as possible.

### How do you pronounce `vinculum`?

Got a macOS? Type the following in your terminal:
```
say vinculum
```

## Installation

Vinculum is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Vinculum'
```

## Write to the Keychain

```swift
let myKey = "mySecretKey"
let myValue = "HowNowBrownCow"

// Write a String to the Keychain
do {
  try Vinculum.set(key: myKey, value: myValue)
} catch let error {
  print("Error: \(error)")
}

// Write a misc object to the Keychain (must be converted to Data type)
if let myValueObj = myValue.data(using: .utf8) {
  do {
    try Vinculum.set(key: myKey, value: myValue)
  } catch let error {
    print("Error: \(error)")
  }
}
```

### Access Groups
It is simple to write a value to the keychain that is available to given [Access Group](https://developer.apple.com/documentation/security/ksecattraccessgroup).

```swift
// Write a String to the Keychain with the access group: com.example.mysite
do {
  try Vinculum.set(key: myKey, value: myValue, accessGroup: com.example.mysite)
} catch let error {
  print("Error: \(error)")
}
```

### Expiration
For ensure an item isn't stored inside of the Keychain *forever*, you set an expiration (in seconds). For example, if you're storing a JSON Web Token (`jwt`) or an access token - use the token's `expires_in` value:

```swift
do {
  try Vinculum.set(key: myKey, value: myToken, expiration: 60)
} catch let error {
  print("Error: \(error)")
}
```

> Note: This feature is intended to be used *only* for short-duration tokens, as it requires the application to be in the forground.

## Retrieve from the Keychain
```swift
if let item = try? Vinculum.get(myKey) {
  // item.key
  // item.value
  // item.expiration
  // item.accessGroup
  // item.accessibility
}
```
## Delete from the Keychain

```swift
do {
  try Vinculum.remove(myKey)
} catch let error {
  print("Error: \(error)")
}
```

## License

Vinculum is available under the MIT license. See the LICENSE file for more info.
