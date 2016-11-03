import Foundation

/// Factory building SOCKS5 adapter.
open class SOCKS5AdapterFactory: ServerAdapterFactory {
    override public init(serverHost: String, serverPort: Int) {
        super.init(serverHost: serverHost, serverPort: serverPort)
    }

    /**
     Get a SOCKS5 adapter.

     - parameter request: The connect request.

     - returns: The built adapter.
     */
    override func getAdapter(_ request: ConnectRequest) -> AdapterSocket {
        let adapter = SOCKS5Adapter(serverHost: serverHost, serverPort: serverPort)
        adapter.socket = RawSocketFactory.getRawSocket()
        return adapter
    }
}
