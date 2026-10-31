//
//  Route.swift
//  TheLaunch
//
//  Created by deema bakhyer on 31/10/2026.
//


//
//  Router.swift
//  TheLaunch
//

import SwiftUI
import Observation

enum Route: Hashable {
    case addTask
    case editTask(TaskItem)
}

@Observable
final class Router {
    var path: [Route] = []
    func push(_ route: Route) { path.append(route) }
    func popToRoot() { path.removeAll() }
}