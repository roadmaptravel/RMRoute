//
//  Routes.swift
//  Roadmap
//
//  Created by Niels Koole on 07/12/16.
//  Copyright © 2016 Roadmap. All rights reserved.
//

import Foundation
import UIKit

@objc enum RMRouteAnimation: Int {
	case push = 0
	case present = 1
}

class RMRoute: NSObject {
	
	private static let shared = RMRoute()
	
	private var registry:[String:(UIViewController, RMRouteAnimation, [AnyObject]) -> Void] = [:]
	
	private func register(path: String, action: (UIViewController, RMRouteAnimation, [AnyObject]) -> Void) {
		// Save route to registry
		registry[path] = action
	}
	
	private func navigate(to: String, delegate: UIViewController, animation: RMRouteAnimation) -> Bool {
		
		// Get routes with equal components
		let toComponents = to.componentsSeparatedByString("/")
		let filteredRoutes = registry.filter { return $0.0.componentsSeparatedByString("/").count == toComponents.count }
		
		for route in filteredRoutes {
			let routeComponents = route.0.componentsSeparatedByString("/")
			var parameters = [String]()
			
			for i in 0 ..< routeComponents.count {
				let toComponent = toComponents[i]
				let routeComponent = routeComponents[i]
				
				if routeComponent.hasPrefix("{") {
					parameters.append(toComponent)
				}
				
				// Equalize the route
				if routeComponent.hasPrefix("{") == false && toComponent != routeComponent {
					// The components are not equal, please try next route
					break
				} else if i == routeComponents.count - 1 {
					// Last component -> Route found
					let action = route.1
					
					// Execute action handlers with
					action(delegate, animation, parameters)
					
					return true
				}
			}
		}
		
		// Route not found
		return false
	}
	
	// MARK: - Public accessor
	
	static func register(path: String, action: (UIViewController, RMRouteAnimation, [AnyObject]) -> Void) {
		return RMRoute.shared.register(path, action: action)
	}
	
	static func navigate(to: String, delegate: UIViewController, animation: RMRouteAnimation) -> Bool {
		return RMRoute.shared.navigate(to, delegate: delegate, animation: animation)
	}
}

