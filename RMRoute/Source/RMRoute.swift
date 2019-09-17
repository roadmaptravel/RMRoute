//
//  Routes.swift
//  Roadmap
//
//  Created by Niels Koole on 07/12/16.
//  Copyright © 2016 Roadmap. All rights reserved.
//

import Foundation
import UIKit

@objc public enum RMRouteAnimation: Int {
	case push, present
}

public class RMRoute: NSObject {
	private typealias Action = (UIViewController, RMRouteAnimation, [String]) -> Bool
	
	private static let shared = RMRoute()
	
	private var registry: [String : Action] = [:]
	
	private override init() { }
	
	// Use some unusual string - with characters allowed in URLs - to parameterize a url
	private static let separator = "---"
	
	private func register(path: String, with action: @escaping Action) {
		// Save route to registry
		registry[path] = action
	}
	
	private func navigate(to: String, delegate: UIViewController, animation: RMRouteAnimation) -> Bool {
		
		guard let url = URL(string: to) else {
			return false
		}

		return navigate(to: url, delegate: delegate, animation: animation)
	}
	
	private func navigate(to: URL, delegate: UIViewController, animation: RMRouteAnimation) -> Bool {
		
		guard let matchingRoute = findMatchingRoute(for: to) else  {
			return false
		}
	
		return matchingRoute.action(delegate, animation, matchingRoute.parameters)
	}
	
	private func isRegistered(url: URL) -> Bool {
		return findMatchingRoute(for: url) != nil
	}
	
	private func findMatchingRoute(for url: URL) -> (action: Action, parameters: [String])? {
		
		let urlComponents = url.pathComponents
		
		let filteredRoutes: [(url: URL, action: Action)] = registry.compactMap { (key, value) in
			guard let routeUrl = URL(string: key.replacingOccurrences(of: "[{}]", with: RMRoute.separator, options: .regularExpression)),
				routeUrl.pathComponents.count == urlComponents.count else {
				return nil
			}

			let routeQueryParameterNames = routeUrl.queryItems?.map { $0.name }
			let urlQueryParameterNames = url.queryItems?.map { $0.name }
			
			if routeQueryParameterNames != urlQueryParameterNames {
				return nil
			}
		
			return (routeUrl, value)
		}
		
		for route in filteredRoutes {
			let routeComponents = route.url.pathComponents
			
			var parameters = [String]()
			
			for i in 0 ..< routeComponents.count {
				let urlComponent = urlComponents[i]
				let routeComponent = routeComponents[i]
				
				if routeComponent.hasPrefix(RMRoute.separator) {
					parameters.append(urlComponent)
				}
				
				// Equalize the route
				// Skip it if it contains 'separator', because those components are dynamic and thus never equal
				if routeComponent.contains(RMRoute.separator) == false && urlComponent.lowercased() != routeComponent.lowercased() {
					// The components are not equal, please try next route
					break
				} else if i == routeComponents.count - 1 {
					
					url.queryItems?.forEach() {
						if let val = $0.value {
							parameters.append(val)
						}
					}
					
					// Last component -> Route found; return its action and parameters
					return (route.action, parameters)
				}
			}
		}
		
		return nil
	}
	
	// MARK: - Public accessor
	
	@objc public static func isRegistered(url: URL) -> Bool {
		return RMRoute.shared.isRegistered(url: url)
	}
	
	@objc public static func register(path: String, action: @escaping (UIViewController, RMRouteAnimation, [String]) -> Bool) {
		return RMRoute.shared.register(path: path, with: action)
	}
	
	@objc public static func navigate(to: String, delegate: UIViewController, animation: RMRouteAnimation) -> Bool {
		return RMRoute.shared.navigate(to: to, delegate: delegate, animation: animation)
	}
	
	@objc(navigatetoURL:delegate:animation:)
	public static func navigate(to: URL, delegate: UIViewController, animation: RMRouteAnimation) -> Bool {
		return RMRoute.shared.navigate(to: to, delegate: delegate, animation: animation)
	}
}

public extension UIViewController {
	
	/**
	A routing helper method on UIViewController
	
	When using `.push` as animation type, `self` is considered to have a `navigationController`.
	
	- Parameters:
	  - to: The view controller to be shown
	  - animation: The type of animation to be used (push or present)
	  - animated: Whether or not the animation should actually be visualized. Default = true
	*/
	@objc func navigate(to viewController:UIViewController, with animation: RMRouteAnimation, animated:Bool = true) {
		
		switch animation {
		case .present:
			present(viewController, animated: animated)
			break
		case .push:
			navigationController?.pushViewController(viewController, animated: animated)
			break
		}
	}
}

public extension URL {
	
	var queryItems: [URLQueryItem]? {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
			let queryItems = components.queryItems else {
				return nil
		}
		return queryItems
	}
}
