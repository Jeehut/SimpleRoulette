//
//  RouletteAngle.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/31.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

extension Roulette {
    public struct Angle {
        /// Radian
        public var value: Double {
            accuracy.value
        }
        
        var accuracy: AccurateDouble
        
        /// initializer with radian
        /// - Parameters:
        ///   - radian: radian. range [0, 2pi) but if fromTop is true, [-1/2pi, 3/2pi)
        ///   - fromTop: flag if zero is from top (pi / 2). default is false.
        public init(radian: Double, fromTop: Bool = false) {
            accuracy = .init(value: radian)
            calculateRadian(fromTop: fromTop)
        }
        
        /// initializer with degree.
        /// - Parameters:
        ///   - degree: degree. range [0, 360) but if fromTop is true, [-90, 270)
        ///   - fromTop: flag if zero is from top (pi / 2). default is false.
        public init(degree: Double, fromTop: Bool = false) {
            accuracy = .init(value: degree.radian())
            calculateRadian(fromTop: fromTop)
        }
        
        private
        mutating func calculateRadian(fromTop: Bool) {
            if fromTop {
            } else {                
                accuracy.subtract(Double.pi * 1/2, mutate: true)
            }
        }
    }
}
