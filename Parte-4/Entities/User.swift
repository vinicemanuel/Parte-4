//
//  User.swift
//  Parte-4
//
//  Created by Vinicius Emanuel on 07/04/21.
//

import Foundation

class User {
    static var shared = User()
    private init() {}

    var pedidos: [Pedido] = []
}
