//
//  GnosisSafeWithDescriptions.swift
//
//  Generated by Bivrost at 1510152537.93529.
//

struct GnosisSafeWithDescriptions {

    struct ExecuteTransaction: SolidityFunction {
        static let methodId = "843f407a"
        typealias Return = Void
        typealias Arguments = (to: Solidity.Address, value: Solidity.UInt256, data: Solidity.Bytes, operation: Solidity.UInt8, nonce: Solidity.UInt256, descriptionHash: Solidity.Bytes32)

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments.to, arguments.value, arguments.data, arguments.operation, arguments.nonce, arguments.descriptionHash))"
        }

        static func decode(returnData: String) throws -> Return {}

        static func decode(argumentsData: String) throws -> Arguments {
            let source = BaseDecoder.partition(argumentsData)
            // Decode Static Types & Locations for Dynamic Types
            let to = try Solidity.Address.decode(source: source)
            let value = try Solidity.UInt256.decode(source: source)
            // Ignore location for data (dynamic type)
            _ = try source.consume()
            let operation = try Solidity.UInt8.decode(source: source)
            let nonce = try Solidity.UInt256.decode(source: source)
            let descriptionHash = try Solidity.Bytes32.decode(source: source)
            // Dynamic Types (if any)
            let data = try Solidity.Bytes.decode(source: source)
            return Arguments(to: to, value: value, data: data, operation: operation, nonce: nonce, descriptionHash: descriptionHash)
        }
    }

    struct ConfirmAndExecuteTransaction: SolidityFunction {
        static let methodId = "3515d74f"
        typealias Return = Void
        typealias Arguments = (to: Solidity.Address, value: Solidity.UInt256, data: Solidity.Bytes, operation: Solidity.UInt8, nonce: Solidity.UInt256, descriptionHash: Solidity.Bytes32)

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments.to, arguments.value, arguments.data, arguments.operation, arguments.nonce, arguments.descriptionHash))"
        }

        static func decode(returnData: String) throws -> Return {}

        static func decode(argumentsData: String) throws -> Arguments {
            let source = BaseDecoder.partition(argumentsData)
            // Decode Static Types & Locations for Dynamic Types
            let to = try Solidity.Address.decode(source: source)
            let value = try Solidity.UInt256.decode(source: source)
            // Ignore location for data (dynamic type)
            _ = try source.consume()
            let operation = try Solidity.UInt8.decode(source: source)
            let nonce = try Solidity.UInt256.decode(source: source)
            let descriptionHash = try Solidity.Bytes32.decode(source: source)
            // Dynamic Types (if any)
            let data = try Solidity.Bytes.decode(source: source)
            return Arguments(to: to, value: value, data: data, operation: operation, nonce: nonce, descriptionHash: descriptionHash)
        }
    }

    struct GetDescriptions: SolidityFunction {
        static let methodId = "3a70d54d"
        typealias Return = Solidity.VariableArray<Solidity.Bytes32>
        typealias Arguments = (from: Solidity.UInt256, to: Solidity.UInt256)

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments.from, arguments.to))"
        }

        static func decode(returnData: String) throws -> Return {
            let source = BaseDecoder.partition(returnData)
            // Decode Static Types & Locations for Dynamic Types
            // Ignore location for _descriptionHashes (dynamic type)
            _ = try source.consume()
            // Dynamic Types (if any)
            let _descriptionHashes = try Solidity.VariableArray<Solidity.Bytes32>.decode(source: source)
            return _descriptionHashes
        }

        static func decode(argumentsData: String) throws -> Arguments {
            let source = BaseDecoder.partition(argumentsData)
            // Decode Static Types & Locations for Dynamic Types
            let from = try Solidity.UInt256.decode(source: source)
            let to = try Solidity.UInt256.decode(source: source)
            // Dynamic Types (if any)
            return Arguments(from: from, to: to)
        }
    }

    struct GetDescriptionCount: SolidityFunction {
        static let methodId = "2c0542c9"
        typealias Return = Solidity.UInt256
        typealias Arguments = Void

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments))"
        }

        static func decode(returnData: String) throws -> Return {
            let source = BaseDecoder.partition(returnData)
            // Decode Static Types & Locations for Dynamic Types
            let param0 = try Solidity.UInt256.decode(source: source)
            // Dynamic Types (if any)
            return param0
        }

        static func decode(argumentsData: String) throws -> Arguments {}
    }

    struct ExecuteException: SolidityFunction {
        static let methodId = "cb279c30"
        typealias Return = Void
        typealias Arguments = (to: Solidity.Address, value: Solidity.UInt256, data: Solidity.Bytes, operation: Solidity.UInt8, exception: Solidity.Address, descriptionHash: Solidity.Bytes32)

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments.to, arguments.value, arguments.data, arguments.operation, arguments.exception, arguments.descriptionHash))"
        }

        static func decode(returnData: String) throws -> Return {}

        static func decode(argumentsData: String) throws -> Arguments {
            let source = BaseDecoder.partition(argumentsData)
            // Decode Static Types & Locations for Dynamic Types
            let to = try Solidity.Address.decode(source: source)
            let value = try Solidity.UInt256.decode(source: source)
            // Ignore location for data (dynamic type)
            _ = try source.consume()
            let operation = try Solidity.UInt8.decode(source: source)
            let exception = try Solidity.Address.decode(source: source)
            let descriptionHash = try Solidity.Bytes32.decode(source: source)
            // Dynamic Types (if any)
            let data = try Solidity.Bytes.decode(source: source)
            return Arguments(to: to, value: value, data: data, operation: operation, exception: exception, descriptionHash: descriptionHash)
        }
    }

    struct ConfirmAndExecuteTransactionWithSignatures: SolidityFunction {
        static let methodId = "affeb287"
        typealias Return = Void
        typealias Arguments = (to: Solidity.Address, value: Solidity.UInt256, data: Solidity.Bytes, operation: Solidity.UInt8, nonce: Solidity.UInt256, v: Solidity.VariableArray<Solidity.UInt8>, r: Solidity.VariableArray<Solidity.Bytes32>, s: Solidity.VariableArray<Solidity.Bytes32>, descriptionHash: Solidity.Bytes32)

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments.to, arguments.value, arguments.data, arguments.operation, arguments.nonce, arguments.v, arguments.r, arguments.s, arguments.descriptionHash))"
        }

        static func decode(returnData: String) throws -> Return {}

        static func decode(argumentsData: String) throws -> Arguments {
            let source = BaseDecoder.partition(argumentsData)
            // Decode Static Types & Locations for Dynamic Types
            let to = try Solidity.Address.decode(source: source)
            let value = try Solidity.UInt256.decode(source: source)
            // Ignore location for data (dynamic type)
            _ = try source.consume()
            let operation = try Solidity.UInt8.decode(source: source)
            let nonce = try Solidity.UInt256.decode(source: source)
            // Ignore location for v (dynamic type)
            _ = try source.consume()
            // Ignore location for r (dynamic type)
            _ = try source.consume()
            // Ignore location for s (dynamic type)
            _ = try source.consume()
            let descriptionHash = try Solidity.Bytes32.decode(source: source)
            // Dynamic Types (if any)
            let data = try Solidity.Bytes.decode(source: source)
            let v = try Solidity.VariableArray<Solidity.UInt8>.decode(source: source)
            let r = try Solidity.VariableArray<Solidity.Bytes32>.decode(source: source)
            let s = try Solidity.VariableArray<Solidity.Bytes32>.decode(source: source)
            return Arguments(to: to, value: value, data: data, operation: operation, nonce: nonce, v: v, r: r, s: s, descriptionHash: descriptionHash)
        }
    }

    struct DescriptionHashes: SolidityFunction {
        static let methodId = "f82e9529"
        typealias Return = Solidity.Bytes32
        typealias Arguments = Solidity.UInt256

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments))"
        }

        static func decode(returnData: String) throws -> Return {
            let source = BaseDecoder.partition(returnData)
            // Decode Static Types & Locations for Dynamic Types
            let param0 = try Solidity.Bytes32.decode(source: source)
            // Dynamic Types (if any)
            return param0
        }

        static func decode(argumentsData: String) throws -> Arguments {
            let source = BaseDecoder.partition(argumentsData)
            // Decode Static Types & Locations for Dynamic Types
            let param0 = try Solidity.UInt256.decode(source: source)
            // Dynamic Types (if any)
            return param0
        }
    }

    struct ConfirmTransaction: SolidityFunction {
        static let methodId = "27de55ff"
        typealias Return = Void
        typealias Arguments = (transactionHash: Solidity.Bytes32, descriptionHash: Solidity.Bytes32)

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments.transactionHash, arguments.descriptionHash))"
        }

        static func decode(returnData: String) throws -> Return {}

        static func decode(argumentsData: String) throws -> Arguments {
            let source = BaseDecoder.partition(argumentsData)
            // Decode Static Types & Locations for Dynamic Types
            let transactionHash = try Solidity.Bytes32.decode(source: source)
            let descriptionHash = try Solidity.Bytes32.decode(source: source)
            // Dynamic Types (if any)
            return Arguments(transactionHash: transactionHash, descriptionHash: descriptionHash)
        }
    }

    struct ConfirmTransactionWithSignatures: SolidityFunction {
        static let methodId = "7ad5a532"
        typealias Return = Void
        typealias Arguments = (transactionHash: Solidity.Bytes32, v: Solidity.VariableArray<Solidity.UInt8>, r: Solidity.VariableArray<Solidity.Bytes32>, s: Solidity.VariableArray<Solidity.Bytes32>, descriptionHash: Solidity.Bytes32)

        static func encodeCall(arguments: Arguments) -> String {
            return "0x\(methodId)\(BaseEncoder.encode(arguments: arguments.transactionHash, arguments.v, arguments.r, arguments.s, arguments.descriptionHash))"
        }

        static func decode(returnData: String) throws -> Return {}

        static func decode(argumentsData: String) throws -> Arguments {
            let source = BaseDecoder.partition(argumentsData)
            // Decode Static Types & Locations for Dynamic Types
            let transactionHash = try Solidity.Bytes32.decode(source: source)
            // Ignore location for v (dynamic type)
            _ = try source.consume()
            // Ignore location for r (dynamic type)
            _ = try source.consume()
            // Ignore location for s (dynamic type)
            _ = try source.consume()
            let descriptionHash = try Solidity.Bytes32.decode(source: source)
            // Dynamic Types (if any)
            let v = try Solidity.VariableArray<Solidity.UInt8>.decode(source: source)
            let r = try Solidity.VariableArray<Solidity.Bytes32>.decode(source: source)
            let s = try Solidity.VariableArray<Solidity.Bytes32>.decode(source: source)
            return Arguments(transactionHash: transactionHash, v: v, r: r, s: s, descriptionHash: descriptionHash)
        }
    }
}
