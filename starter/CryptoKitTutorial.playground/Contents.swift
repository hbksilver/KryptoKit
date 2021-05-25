// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import CryptoKit

func getData(for item: String, of type: String) -> Data {
  let filePath = Bundle.main.path(forResource: item, ofType: type)!
  return FileManager.default.contents(atPath: filePath)!
}
//: ## Hashing data
//: ### Hashable Protocol
func hashItem(item: String) -> Int {
  var hasher = Hasher()
  item.hash(into: &hasher)
  return hasher.finalize()
}


//: ### Cryptographic Hashing
let data = getData(for: "Baby", of: "png")
UIImage(data: data)

// Create a digest of `data`:


// Dumbledore sends`data` and `digest` to Harry,
// who hashes `data` and checks that digests match.



// Get String representation of `digest`:


// Small change in `data` produces completely different digest:
String(describing: SHA256.hash(data: "Harry is a horcrux".data(using: .utf8)!))
String(describing: SHA256.hash(data: "Harry is a horcrux".data(using: .utf8)!))
//: ## HMAC: Hash-based Message Authentication Code
//: Use a symmetric cryptographic key when creating the digest
//: so the receiver knows it’s from you, or a server can check
//: that you’re authorized to upload files.
// Create a 256-bit symmetric key

// Create a keyed digest of data


// Convert signature to Data

// Dumbledore sends data and signature to Harry, who checks the signature:




//: ## Authenticated Encryption
// Create a sealed box with the encrypted data

// Send sealed box data over network connection


// Decrypt data with the same key


// What else is in the box?


// encryptedData isn't an image



//: ## Public-Key Cryptography
// Dumbledore wants to send the horcrux image to Harry.
// He signs it so Harry can verify it's from him.



// Dumbledore publishes `albusSigningPublicKeyData`.
// Dumbledore signs `data` (or `digest`) with his private key.


// Signing a digest of the data is faster:



// Dumbledore sends `data`, `digest512` and `signatureForData`
// or `signatureForDigest` to Harry, who verifies signatures
// with key created from `albusSigningPublicKeyData`.




//: ## Shared secret / Key agreement
// Dumbledore and Harry create private and public keys for
// key agreement, and publish the public keys.




// Dumbledore and Harry must agree on the salt value
// for creating the symmetric key:


// Dumbledore uses his private key and Harry's public key
// to calculate `sharedSecret` and `symmetricKey`.





// Harry uses his private key and Dumbledore's public key
// to calculate `sharedSecret` and `symmetricKey`.





// As if by magic, they produce the same symmetric key!



//: Now Dumbledore and Harry can use symmetric key cryptography to authenticate or encrypt data.
