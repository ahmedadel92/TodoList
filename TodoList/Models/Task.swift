//
//  Task.swift
//  TodoList
//
//  Created by Ahmed Adel Al-Ahmed on 04/10/2021.
//

import Foundation

struct Task {
    let id: UUID = UUID()
    let title: String
    var isCompleted: Bool = false
}
