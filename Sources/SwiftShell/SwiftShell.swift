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
    public func run() throws -> (exitCode: Int32, output: String) {
        
        let process = Process()
        let pipe = Pipe()
        
        process.executableURL = URL(string: "file:///bin/zsh") ?? URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", sourceCode]
        process.standardOutput = pipe
        process.standardError = pipe
        process.standardInput = nil

        do {
            try process.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: String.Encoding.utf8)!

            process.waitUntilExit()
            
            return (process.terminationStatus, output)
        } catch {
            throw SwiftShellError(
                sourceCode: sourceCode,
                error: error,
                terminationStatus: process.terminationStatus
            )
        }
    }
    
    @discardableResult
    public func runAndExpectZero() throws -> String {
        let (exitCode, output) = try run()
        guard exitCode == 0 else {
            throw SwiftShellError(
                sourceCode: sourceCode,
                error: output,
                terminationStatus: exitCode
            )
        }
        return output
    }
    
    public func runAndIgnore() throws {
        let process = Process()
        
        process.executableURL = URL(string: "file:///bin/zsh") ?? URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", sourceCode]
        
        try process.run()
        
        process.waitUntilExit()
    }
}
