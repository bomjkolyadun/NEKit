import Foundation

/// Factory building Shadowsocks adapter.
open class ShadowsocksAdapterFactory: ServerAdapterFactory {
    let encryptAlgorithm: CryptoAlgorithm
    let password: String

    public init(serverHost: String, serverPort: Int, encryptAlgorithm: CryptoAlgorithm, password: String) {
        self.encryptAlgorithm = encryptAlgorithm
        self.password = password
        super.init(serverHost: serverHost, serverPort: serverPort)
    }

    public convenience init?(serverHost: String, serverPort: Int, encryptAlgorithm: String, password: String) {
        guard let encryptAlgorithm = CryptoAlgorithm(rawValue: encryptAlgorithm.uppercased()) else {
            return nil
        }

        self.init(serverHost: serverHost, serverPort: serverPort, encryptAlgorithm: encryptAlgorithm, password: password)
    }

    /**
     Get a Shadowsocks adapter.

     - parameter request: The connect request.

     - returns: The built adapter.
     */
    override func getAdapter(_ request: ConnectRequest) -> AdapterSocket {
        let adapter = ShadowsocksAdapter(host: serverHost, port: serverPort, encryptAlgorithm: encryptAlgorithm, password: password)
        adapter.socket = RawSocketFactory.getRawSocket()
        return adapter
    }
}
