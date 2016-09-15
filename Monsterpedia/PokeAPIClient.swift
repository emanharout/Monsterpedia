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
	
	func taskForGETMethod(_ url: URL, completionHandlerForGETMethod: @escaping (_ result: AnyObject?, _ error: NSError?)->Void) -> URLSessionTask {
		let request = URLRequest(url: url)
		let session = URLSession.shared
		let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
			
			guard error == nil else {
				completionHandlerForGETMethod(nil, error as NSError?)
				return
			}
			
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
				let error = NSError(domain: "taskForGETMethod", code: 9, userInfo: [NSLocalizedDescriptionKey: "Status Code from server is non-2xx"])
				completionHandlerForGETMethod(nil, error)
				return
			}
			
			guard let data = data else {
				let error = NSError(domain: "taskForGETMethod", code: 10, userInfo: [NSLocalizedDescriptionKey: "Data returned from server is nil"])
				completionHandlerForGETMethod(nil, error)
				return
			}
			self.parseData(data, completionHandler: completionHandlerForGETMethod)
		}) 
		task.resume()
		return task
	}
	
	fileprivate init(){}
}



// MARK: Helper Methods
extension PokeAPIClient {
	func buildURLFromComponents(_ scheme: String, host: String, path: String, query: [String: AnyObject]?) -> URL {
		var urlComponents = URLComponents()
		urlComponents.scheme = scheme
		urlComponents.host = host
		urlComponents.path = path
		urlComponents.queryItems = [URLQueryItem]()
		
		if let query = query {
			for (key, value) in query {
				let query = URLQueryItem(name: key, value: "\(value)")
				urlComponents.queryItems?.append(query)
			}
		}
		return urlComponents.url!
	}
	
	func parseData(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?)->Void) {
		do {
			let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
			completionHandler(result as AnyObject?, nil)
		} catch let error as NSError {
			completionHandler(nil, error)
		}
	}
	
	func substituteValueInString(_ string: String, value: String, withValue newValue: String) -> String? {
		if string.range(of: value) != nil {
			let newString = string.replacingOccurrences(of: value, with: newValue)
			return newString
		} else {
			return nil
		}
	}
	
	// Create URL
	// Pass into taskForGET
	// return entire JSON to completion handler
	
	func getPokemonData(_ monster: Monster, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?)->Void) {
		guard let path = substituteValueInString(Constants.MonsterPath, value: "{id}", withValue: "\(monster.id)") else {
			print("Failed to build URL Path")
			return
		}

		let url = buildURLFromComponents(Constants.Scheme, host: Constants.Host, path: path, query: nil)
		print(url)
		taskForGETMethod(url) { (result, error) in
			completionHandler(result, error)
		}
	}
}
