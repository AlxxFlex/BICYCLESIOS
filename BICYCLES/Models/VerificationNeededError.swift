//
//  VerificationNeededError.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 19/03/25.
//

import Foundation
struct VerificationNeededError: Error {
    let email: String
    let message: String
}
