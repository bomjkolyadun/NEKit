import Foundation

/// This class just forwards data directly. It is designed to work with tun2socks.
open class DirectProxySocket: ProxySocket {
    /**
     Begin reading and processing data from the socket.

     - note: Since there is nothing to read and process before forwarding data, this just calls `delegate?.didReceiveRequest`.
     */
    override func openSocket() {
        super.openSocket()

        if let address = socket.destinationIPAddress, let port = socket.destinationPort {
            request = ConnectRequest(host: address.presentation, port: Int(port.value))

            observer?.signal(.receivedRequest(request!, on: self))
            delegate?.didReceiveRequest(request!, from: self)
        } else {
            forceDisconnect()
        }
    }

    /**
     Response to the `ConnectResponse` from `AdapterSocket` on the other side of the `Tunnel`.

     - parameter response: The response is ignored.
     */
    override func respondToResponse(_ response: ConnectResponse) {
        super.respondToResponse(response)

        observer?.signal(ProxySocketEvent.readyForForward(self))
        delegate?.readyToForward(self)
    }

    /**
     The socket did read some data.

     - parameter data:    The data read from the socket.
     - parameter withTag: The tag given when calling the `readData` method.
     - parameter from:    The socket where the data is read from.
     */
    override open func didReadData(_ data: Data, withTag tag: Int, from: RawTCPSocketProtocol) {
        super.didReadData(data, withTag: tag, from: from)
        delegate?.didReadData(data, withTag: tag, from: self)
    }

    /**
     The socket did send some data.

     - parameter data:    The data which have been sent to remote (acknowledged). Note this may not be available since the data may be released to save memory.
     - parameter withTag: The tag given when calling the `writeData` method.
     - parameter from:    The socket where the data is sent out.
     */
    override open func didWriteData(_ data: Data?, withTag tag: Int, from: RawTCPSocketProtocol) {
        super.didWriteData(data, withTag: tag, from: from)
        delegate?.didWriteData(data, withTag: tag, from: self)
    }
}
