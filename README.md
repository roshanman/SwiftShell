# SwiftShell
SwiftShell is a package which provides tools for shell scripting in Swift.


## Overview

For example, you can write:
```
let output: String = try Shell("echo Hello SwiftShell | sed 's/SwiftShell/World/g'").run()
print(output)
```
