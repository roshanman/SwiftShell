import Foundation

public struct SwiftShellError: Error {
    public let sourceCode: String
    public let errorMessage: String
}

public struct Shell {
    let sourceCode: String
    
    public init(_ sourceCode: String) {
        self.sourceCode = sourceCode
    }
    
    @discardableResult
    public func run() throws -> String {
        
        let process = Process()
        let stdoutPipe = Pipe()
        let stdErrPipe = Pipe()
        
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", sourceCode]
        process.standardOutput = stdoutPipe
        process.standardError = stdErrPipe
        process.standardInput = nil

        process.launch()
        process.waitUntilExit()
        
        let errorData = stdErrPipe.fileHandleForReading.readDataToEndOfFile()
        if !errorData.isEmpty {
            let errorMessage = String(data: errorData, encoding: String.Encoding.utf8)!
            throw SwiftShellError(sourceCode: self.sourceCode, errorMessage: errorMessage)
        }
        
        let outputData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        
        return String(data: outputData, encoding: String.Encoding.utf8)!
    }
}
