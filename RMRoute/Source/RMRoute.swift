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
	
	private func register(path: String, with action: @escaping Action) {
		// Save route to registry
		registry[path] = action
	}
	
	private func navigate(to: String, delegate: UIViewController, animation: RMRouteAnimation) -> Bool {
		
		// Get routes with equal components
		let toComponents = to.components(separatedBy: "/")
		
		let filteredRoutes = registry.filter { return $0.0.components(separatedBy: "/").count == toComponents.count }
		
		for route in filteredRoutes {
			let routeComponents = route.0.components(separatedBy: "/")
			var parameters = [String]()
			
			for i in 0 ..< routeComponents.count {
				let toComponent = toComponents[i]
				let routeComponent = routeComponents[i]
				
				//If the component starts with `{` consider it to be a dynamic property and add it as param
				if routeComponent.hasPrefix("{") {
					parameters.append(toComponent)
				}
				
				// Equalize the route
				// Skip it if it contains '{', because those components are dynamic and thus never equal
				if routeComponent.contains("{") == false && toComponent.lowercased() != routeComponent.lowercased() {
					// The components are not equal, please try next route
					break
				} else if i == routeComponents.count - 1 {
					
					if routeComponent.hasPrefix("?") {
						
						let queryItems = URLComponents(string: to)?.queryItems
						queryItems?.forEach() { (item) in
							if let val = item.value {
								parameters.append(val)
							}
						}
					}
					
					// Last component -> Route found
					let action = route.1
					
					// Execute action handlers with
					return action(delegate, animation, parameters)
				}
			}
		}
		
		// Route not found
		return false
	}
	
	private func navigate(to: URL, delegate: UIViewController, animation: RMRouteAnimation) -> Bool {
		
		guard let action = getAction(for: to) else  {
			return false
		}
		
		var parameters = [String]()
		to.queryItems?.forEach() { (item) in
			if let val = item.value {
				parameters.append(val)
			}
		}
		
		return action(delegate, animation, parameters)
	}
	
	private func isRegistered(url: URL) -> Bool {
		return getAction(for: url) != nil
	}
	
	private func getAction(for url: URL) -> Action? {
		// Use some unusual string - with characters allowed in URLs - to parameterize a url
		let separator = "---"
		
		let toComponents = url.pathComponents
		
		let filteredRoutes = registry.filter {
			let url = URL(string: $0.0.replacingOccurrences(of: "[{}]", with: separator, options: .regularExpression))
			return url?.pathComponents.count == toComponents.count
		}
		
		for route in filteredRoutes {
			
			guard let routeURL = URL(string: route.0.replacingOccurrences(of: "[{}]", with: separator, options: .regularExpression)) else {
				return nil
			}
			
			let routeComponents = routeURL.pathComponents
			
			for i in 0 ..< routeComponents.count {
				let toComponent = toComponents[i]
				let routeComponent = routeComponents[i]
				
				// Equalize the route
				// Skip it if it contains 'separator', because those components are dynamic and thus never equal
				if routeComponent.contains(separator) == false && toComponent.lowercased() != routeComponent.lowercased() {
					// The components are not equal, please try next route
					break
				} else if i == routeComponents.count - 1 {
					
					if let routeQueryParameterNames = routeURL.queryItems?.map({ $0.name }),
						let toQueryParameterNames = url.queryItems?.map({ $0.name }),
						routeQueryParameterNames != toQueryParameterNames {
						break
					}
					
					// Last component -> Route found; return its action
					let action = route.1
					return action
				}
			}
		}
		
		// Action not found
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
	
	var queryItems:[URLQueryItem]? {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
			let queryItems = components.queryItems else {
				return nil
		}
		return queryItems
	}
}
