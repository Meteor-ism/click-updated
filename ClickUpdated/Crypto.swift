import CryptoKit
import SwiftUI

extension String {
    func b64e() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }
    func b64d() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

func generatePublicKey() -> P256.KeyAgreement.PublicKey {
    return P256.KeyAgreement.PrivateKey().publicKey
}

func createSymmetricKey(_ publicKey: P256.KeyAgreement.PublicKey) -> SymmetricKey {
    let salt = "Salt".data(using: .utf8)!
    let privateKey = try! P256.KeyAgreement.PrivateKey(pemRepresentation: """
    -----BEGIN PRIVATE KEY-----
    MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgotAz4GXXI2eCFTGG
    EgFq7rH24Ya1wLwtGTi222ePmbGhRANCAARRvuS9nEXSAx2Mme2TCBa+Kj8AZxaa
    L/X3wZhb6n5Zign4NkNTooXuiBj48sIIadgvHIxRiiBjBX6gUhqJFyH/
    -----END PRIVATE KEY-----
    """)
    let sharedSecret = try! privateKey.sharedSecretFromKeyAgreement(with: publicKey)
    return sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: salt, sharedInfo: Data(), outputByteCount: 32)
}

func publicKeyToString(_ publicKey: P256.KeyAgreement.PublicKey) -> String {
    return publicKey.pemRepresentation.b64e()!
}

func stringToPublicKey(_ string: String) -> P256.KeyAgreement.PublicKey {
    return try! P256.KeyAgreement.PublicKey(pemRepresentation: string.b64d()!)
}

func encryptText(_ text: String, _ symmetricKey: SymmetricKey) -> String {
    let sealed = try! ChaChaPoly.seal(text.data(using: .utf8)!, using: symmetricKey)
    return sealed.combined.base64EncodedString()
}

func decryptText(_ encryptedText: String, _ symmetricKey: SymmetricKey) -> String {
    let sealed = try! ChaChaPoly.SealedBox(combined: Data(base64Encoded: encryptedText)!)
    return String(data: try! ChaChaPoly.open(sealed, using: symmetricKey), encoding: .utf8)!
}
