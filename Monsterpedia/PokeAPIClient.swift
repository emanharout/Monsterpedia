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
		let request = NSURLRequest(URL: url)
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			
			guard error != nil else {
				completionHandlerForGETMethod(result: nil, error: error)
				return
			}
			
			guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
				let error = NSError(domain: "taskForGETMethod", code: 9, userInfo: [NSLocalizedDescriptionKey: "Status Code from server is non-2xx"])
				if let response = response as? NSHTTPURLResponse {
					let status = response.statusCode
					print(status)
				}
				completionHandlerForGETMethod(result: nil, error: error)
				print("STATUS CODE: \(response)")
				return
			}
			
			guard let data = data else {
				let error = NSError(domain: "taskForGETMethod", code: 10, userInfo: [NSLocalizedDescriptionKey: "Data returned from server is nil"])
				print(error)
				completionHandlerForGETMethod(result: nil, error: error)
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
		print("Hello")
		do {
			let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
			print("RESULTS: \(result)")
			print("Is it me")
			completionHandler(result: result, error: nil)
		} catch let error as NSError {
			print("You're looking for?")
			completionHandler(result: nil, error: error)
		}
	}
	
	func substituteValueInString(string: String, value: String, withValue newValue: String) -> String? {
		if string.rangeOfString(value) != nil {
			let newString = string.stringByReplacingOccurrencesOfString(value, withString: newValue)
			return newString
		} else {
			return nil
		}
	}
	
	// Create URL
	// Pass into taskForGET
	// return entire JSON to completion handler
	
	func getPokemonData(monster: Monster, completionHandler: (result: AnyObject?, error: NSError?)->Void) {
		guard let path = substituteValueInString(Constants.MonsterPath, value: "{id}", withValue: "\(monster.id)") else {
			print("Failed to build URL Path")
			return
		}

		let url = buildURLFromComponents(Constants.Scheme, host: Constants.Host, path: path, query: nil)
		print(url)
		taskForGETMethod(url) { (result, error) in
			if let result = result {
				print("Result exists")
			} else {
				print("Result be nil")
			}
			if let error = error {
				print(error)
			}
			completionHandler(result: result, error: error)
		}
	}
}
