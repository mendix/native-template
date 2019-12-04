import Foundation

/*
 * A class that given a URL can validate if it is accessible.
 * Used to validate the existance of the Native Bundler but could
 * be used for any other similar case.
 */
class URLValidator: NSObject, URLSessionDataDelegate {
    static func validate(_ url: URL, onCompletion: ((_ valid: Bool) -> Void)?) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig, delegate: URLValidatorDelegate(onCompletion), delegateQueue: .main)
        session.dataTask(with: url).resume()
    }
}

class URLValidatorDelegate: NSObject, URLSessionDataDelegate {
    let completionHandler: ((_ valid: Bool) -> Void)?

    init(_ onCompletion: ((_ valid: Bool) -> Void)? ) {
        completionHandler = onCompletion
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.completionHandler?(false)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }

        DispatchQueue.main.async {
            self.completionHandler?(httpResponse.statusCode == 200)
        }

        session.finishTasksAndInvalidate()
    }
}
