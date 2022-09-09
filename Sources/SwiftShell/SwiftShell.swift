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
        let sourceCode = """
        system <<'EOC'
        \(sourceCode)
        EOC
        """
        
        let process = Process()
        let stdinPipe = Pipe()
        let stdoutPipe = Pipe()
        let stdErrPipe = Pipe()
        
        process.launchPath = "/usr/bin/ruby"
        process.standardOutput = stdoutPipe
        process.standardInput = stdinPipe
        process.standardError = stdErrPipe
        
        let data = sourceCode.data(using: .utf8)!
        try stdinPipe.fileHandleForWriting.write(contentsOf: data)
        stdinPipe.fileHandleForWriting.closeFile()
        
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
