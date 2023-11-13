# FDANetwork

FDANetwork is a Swift 5.8 library for making network requests. It provides a simple and easy-to-use API for sending HTTP requests and handling responses.

## Installation
Add this SPM dependency to your project:
```
https://github.com/Sfresneda/FDANetwork
```

## Usage
Here's an example of how to use FDANetwork to send a GET request:

```swift
import FDANetwork

let executor = NetworkRequestsExecutor(session: URLSession.shared)) 

let baseUrl = "https://jsonplaceholder.typicode.com"
let getRequest = FDARequest.baseUrl(baseUrl).get("posts")
 
do {
    let response: SomeCodableModel = try await executor.execute(request: getRequest)
    // do something with your response
} catch {
    // handle error
}
```

## License
This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details

## Author
Sergio Fresneda - [sfresneda](https://github.com/Sfresneda)