//
//  RouletteModel.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// ``RouletteDataDelegate`` is delegate that manages all of ``PartData`` which are shown at ``RouletteView``.
public protocol RouletteDataDelegate: AnyObject {

    /// Total degree of Roulette.
    /// - Note: This is usually 360° degree.
    var total: Double {
        get
    }

    /// all of ``PartData`` which are used in Roulette should be included in ``allParts``.
    var allParts: [PartData] {
        get
    }
}

/// ``RouletteModel`` is a model that interact with ``View`` and manage state of Roulette.
public final class RouletteModel: ObservableObject {
    @Published public var parts: [PartData] = []
    @Published public var state: RouletteState = .start


    private var whenToStopHandler: (() -> Void)?
    private let worker: RouletteWorker = .init()
    private let onDecide: PassthroughSubject<PartData?, Never>
    public var onDecidePublisher: AnyPublisher<PartData?, Never> {
        onDecide.eraseToAnyPublisher()
    }
    
    public init(
        onDecide: PassthroughSubject<PartData?, Never> = .init(),
        parts: [PartData]
    ) {
        self.onDecide = onDecide
        self.parts = parts

        updateDelegate()
    }

    public func updateParts(_ parts: [PartData]) {
        self.parts = parts
        updateDelegate()
    }

    private func updateDelegate() {
        for i in 0..<parts.count {
            parts[i].delegate = self
        }
    }

    /// Method that starts Roulette!
    ///
    /// - Parameters:
    ///     - speed: You can set arbitrary speed with ``RouletteSpeed``
    ///     By default, ``RouletteSpeed/random()`` is set.
    ///     - isContinue: if this value is `true`, We recognize that current situation is `pause` and will resume the rotation.
    ///     If you called ``RouletteModel/pause()``, please pass `true` to this parameter.
    ///     Default value is `false`.
    ///     - automaticallyStopAfter: this value should be set to the duration (seconds) we want Roulette running.
    ///     Default value is `nil` which means it will not automatically stop unless calling ``RouletteModel/stop()``
    public func start(
        speed _speed: RouletteSpeed = .random(),
        isContinue: Bool = false,
        automaticallyStopAfter: Double? = nil
    ) {
        assert(!(isContinue && automaticallyStopAfter != nil))
        if state.isAnimating {
            return
        }
        onDecide.send(nil)
        if case let RouletteState.pause(angle, speed) = state, isContinue {
            startFromCheckPoint(angle: angle, speed: speed)
        } else {
            startCompletely(speed: _speed, automaticallyStopAfter: automaticallyStopAfter)
        }
    }

    private func startCompletely(
        speed: RouletteSpeed,
        automaticallyStopAfter: Double?
    ) {
        state = .run(angle: .zero, speed: speed)
        worker.start(speed: speed, automaticallyStopAfter: automaticallyStopAfter) { degrees in
            if case RouletteState.run = self.state {
                self.state = .run(angle: .degrees(degrees), speed: speed)
            }
        } onEnd: {
            self.stop()
        }
    }

    private func startFromCheckPoint(angle: Angle, speed: RouletteSpeed) {
        state = .run(angle: angle, speed: speed)
        worker.start(speed: speed, from: angle.degrees, automaticallyStopAfter: nil) { degrees in
            if case RouletteState.run = self.state {
                self.state = .run(angle: .degrees(degrees), speed: speed)
            }
        } onEnd: {
            self.stop()
        }
    }

    /// Method that restarts Roulette.
    public func restart() {
        guard case let RouletteState.pause(angle, speed) = state else {
            return
        }
        startFromCheckPoint(angle: angle, speed: speed)
    }

    /// Method that pause Roulette.
    public func pause() {
        if !state.isAnimating {
            return
        }
        guard case let RouletteState.run(angle, speed) = state else {
            return
        }
        state = .pause(angle: angle, speed: speed)
        whenToStopHandler = nil
        worker.pause()
    }

    /// Method that stops Roulette.
    public func stop() {
        if !state.isAnimating {
            return
        }
        guard case let RouletteState.run(angle, _) = state else {
            return
        }
        worker.stop()
        var degrees = angle.degrees
        #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
        print("Pure Angle degreees: \(degrees)")
        #endif
        
        while degrees >= 360 {
            degrees -= 360
        }
        
        #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
        print("Processed Angle degreees: \(degrees)")
        #endif

        for part in parts {
            let start = part.startAngle.degrees + degrees
            let end = part.endAngle.degrees + degrees
            #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
            print("label: \(part.label)")
            print("start: \(start)")
            print("end: \(end)")
            #endif

            // Angle of ▼
            let stopDegree: Double = 270 + 360 * Double(Int(start) / 360)

            if start <= stopDegree && end >= stopDegree {
                state = .stop(location: part, angle: angle)
                onDecide.send(part)
                objectWillChange.send()
                return
            }
        }
    }

    /// Method that manually sets the Roulette to a target angle position.
    public func stop(at angle: Angle) {
        self.worker.stop()

        let degrees = angle.degrees.truncatingRemainder(dividingBy: 360)
        let partAtAngle = self.parts.first(where: { $0.startAngle.degrees <= degrees && $0.endAngle.degrees >= degrees })!

        self.state = .stop(location: partAtAngle, angle: angle)
        self.onDecide.send(partAtAngle)
        self.objectWillChange.send()
    }

    func update<State, V: Equatable>(to state: inout State, keypath: WritableKeyPath<State, V>, _ value: V) {
        if state[keyPath: keypath] != value {
            state[keyPath: keypath] = value
        }
    }
}

extension RouletteModel: RouletteDataDelegate {
    public var total: Double {
        Double.pi * 2
    }

    public var allParts: [PartData] {
        parts
    }
}
