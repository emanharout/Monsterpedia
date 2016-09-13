//
//  PokeAPIClient.swift
//  Monsterpedia
//
//  Created by Emmanuoel Eldridge on 7/30/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class PokeAPIClient {
	
	static let sharedInstance = PokeAPIClient()
	
	func taskForGETMethod(url: NSURL, completionHandlerForGETMethod: (result: AnyObject?, error: NSError?)->Void) -> NSURLSessionTask {
//		let url = buildURLFromComponents(PokeAPIClient.Constants.Scheme, host: PokeAPIClient.Constants.Host, path: Constants.MonsterPath, query: nil)
		let request = NSURLRequest(URL: url)
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			
			guard error != nil else {
				completionHandlerForGETMethod(result: nil, error: error)
				return
			}
			
			guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
				let error = NSError(domain: "taskForGETMethod", code: 9, userInfo: [NSLocalizedDescriptionKey: "Status Code from server is non-2xx"])
				completionHandlerForGETMethod(result: nil, error: error)
				return
			}
			
			guard let data = data else {
				let error = NSError(domain: "taskForGETMethod", code: 10, userInfo: [NSLocalizedDescriptionKey: "Data returned from server is nil"])
				print(error)
				return
			}
			
			self.parseData(data, completionHandler: completionHandlerForGETMethod)
		}
		task.resume()
		return task
	}
	
	private init(){}
}



// MARK: Helper Methods
extension PokeAPIClient {
	func buildURLFromComponents(scheme: String, host: String, path: String, query: [String: AnyObject]?) -> NSURL {
		let urlComponents = NSURLComponents()
		urlComponents.scheme = scheme
		urlComponents.host = host
		urlComponents.path = path
		urlComponents.queryItems = [NSURLQueryItem]()
		
		if let query = query {
			for (key, value) in query {
				let query = NSURLQueryItem(name: key, value: "\(value)")
				urlComponents.queryItems?.append(query)
			}
		}
		return urlComponents.URL!
	}
	
	func parseData(data: NSData, completionHandler: (result: AnyObject?, error: NSError?)->Void) {
		do {
			let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
			completionHandler(result: result, error: nil)
		} catch let error as NSError {
			completionHandler(result: nil, error: error)
		}
	}
	
	
}
