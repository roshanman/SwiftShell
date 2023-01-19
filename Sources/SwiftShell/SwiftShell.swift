import Foundation

public struct SwiftShellError: Error {
    public let sourceCode: String
    public let error: Error
    public let terminationStatus: Int32
}

extension String: Error { }

public struct Shell {
    public let sourceCode: String
    
    public init(_ sourceCode: String) {
        self.sourceCode = sourceCode
    }
    
    @discardableResult
    public func run() throws -> String {
        
        let process = Process()
        let pipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/bin/zsh") ?? URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", sourceCode]
        process.standardOutput = pipe
        process.standardError = pipe
        process.standardInput = nil

        do {
            try process.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: String.Encoding.utf8)!

            process.waitUntilExit()
            
            return output
        } catch {
            throw SwiftShellError(
                sourceCode: sourceCode,
                error: error,
                terminationStatus: process.terminationStatus
            )
        }
    }
}
