import Foundation
import SwiftShell


do {
    
    try Shell("for i in $(seq 1 10);do echo $i; sleep 1; done").runAndIgnore()
    
    let output1 = try Shell("echo Hello SwiftShell").run()
    print(output1)
    
    let output2 = try Shell("echo Hello SwiftShell | sed 's/SwiftShell/World/g'").run()
    print(output2)
    
    let output3 = try Shell("ls -la ~/Desktop").run()
    print(output3)
    
    let output4 = try Shell("find ~/Desktop -maxdepth 2 -name '*.swift'").run()
    print(output4)

    print(try Shell("error command").run())
} catch {
    print(error)
}
