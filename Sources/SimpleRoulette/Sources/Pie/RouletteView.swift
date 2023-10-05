//
//  RouletteViewSwiftUI.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI

/// ``RouletteView`` is a `View` in `SwiftUI` framework.
///
/// ``RouletteView`` contains multiple ``PartData`` which has each element of Roulette.
///
/// You can use it like the following way.
///
///
///       struct SelectionView: View {
///             var body: some View {
///                 RouletteView(
///                     parts: [
///                         PartData(content: .label("Swift"), area: .flex(2)),
///                         PartData(content: .label("Dart"), area: .flex(1)),
///                     ]
///                 )
///                 .startOnAppear()
///             }
///       }
///
public struct RouletteView: View {
    
    private let model: RouletteModel

    @State private var currentAngle: Angle = .init()
    @State private var radius: CGFloat = 0
    @State private var center: CGPoint = .zero
    @State private var length: CGFloat
    @State private var startsAnimate: Bool = false

    let stopView: AnyView
    
    public var body: some View {
        RouletteInternalView(stopView: stopView, length: length)
            .environmentObject(model)
    }

    /// Initialization
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - model: please pass ``RouletteModel`` instance
    ///     which manages many stufffs of ``RouletteView``.
    ///     - stopView: If you want to customize `stopView`, please pass `AnyView` to this parameter.
    ///     Default value is nil which means `Image(systemName: "arrowtriangle.down.fill")`
    ///     is used as a `stopView`.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        model: RouletteModel,
        stopView: AnyView? = nil,
        length: CGFloat = 320
    ) {
        self._length = State(initialValue: length)
        self.model = model
        if let stopView = stopView {
            self.stopView = stopView
        } else {
            self.stopView = AnyView(
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(.title))
                    .fixedSize()
            )
        }
    }

    /// Initialization
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - parts: please pass `Array` of ``PartData`` instance
    ///     which corresponds to each element inside Roulette.
    ///     - stopView: If you want to customize `stopView`, please pass `AnyView` to this parameter.
    ///     Default value is nil which means `Image(systemName: "arrowtriangle.down.fill")`
    ///     is used as a `stopView`.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        parts: [PartData],
        stopView: AnyView? = nil,
        length: CGFloat = 320
    ) {
        let model = RouletteModel(parts: parts)
        self.init(model: model, stopView: stopView, length: length)
    }

    /// Method that starts Roulette!
    ///
    /// This method is kind of syntax suger of ``RouletteModel/start(speed:isContinue:automaticallyStopAfter:)``.
    ///
    /// - Parameters:
    ///     - speed: You can set arbitrary speed with ``RouletteSpeed``
    ///     By default, ``RouletteSpeed/random()`` is set.
    ///     - isContinue: if this value is `true`, We recognize that current situation is `pause` and will resume the rotation.
    ///     If you called ``RouletteModel/pause()``, please pass `true` to this parameter.
    ///     Default value is `false`.
    ///     - automaticallyStopAfter: this value should be set to the duration (seconds) we want Roulette running.
    ///     Default value is `nil` which means it will not automatically stop unless calling ``RouletteView/stop()``
    ///     - didFinish: a closure that handles after Roulette has been finished.
    ///     Default value is `nil` which means nothing will happen when Roulette stops.
    ///     I recommend you to handle some operation like showing the result on View.
    @ViewBuilder
    public func startOnAppear(
        speed: RouletteSpeed = .random(),
        isContinue: Bool = false,
        automaticallyStopAfter: Double? = nil,
        didFinish: ((PartData) -> Void)? = nil
    ) -> some View {
        Group {
            if let didFinish {
                onAppear {
                    model.start(
                        speed: speed,
                        isContinue: isContinue,
                        automaticallyStopAfter: automaticallyStopAfter
                    )
                }
                .onReceive(model.onDecidePublisher) { part in
                    guard let part else {
                        return
                    }
                    didFinish(part)
                }
            } else {
                onAppear {
                    model.start(
                        speed: speed,
                        isContinue: isContinue,
                        automaticallyStopAfter: automaticallyStopAfter
                    )
                }
            }
        }
    }

    /// Method that stops Roulette.
    ///
    /// This method is kind of syntax suger of ``RouletteModel/stop()``.
    /// - Note: This method does not immediately stop Roulette.
    /// a delay which makes us feel more realistic Roulette happens.
    public func stop() {
        model.stop()
    }
}

#Preview {
   struct Preview: View {
      @State
      var rouletteModel = RouletteModel(
         parts: [
            PartData(content: .label("A"), area: .flex(1)),
            PartData(content: .label("B"), area: .flex(1)),
            PartData(content: .label("C"), area: .flex(1)),
            PartData(content: .label("D"), area: .flex(1)),
            PartData(content: .label("E"), area: .flex(1)),
            PartData(content: .label("F"), area: .flex(1)),
            PartData(content: .label("G"), area: .flex(1)),
            PartData(content: .label("H"), area: .flex(1)),
            PartData(content: .label("I"), area: .flex(1)),
            PartData(content: .label("J"), area: .flex(1)),
            PartData(content: .label("K"), area: .flex(1)),
            PartData(content: .label("L"), area: .flex(1)),
            PartData(content: .label("M"), area: .flex(1)),
            PartData(content: .label("N"), area: .flex(1)),
            PartData(content: .label("O"), area: .flex(1)),
            PartData(content: .label("P"), area: .flex(1)),
            PartData(content: .label("Q"), area: .flex(1)),
            PartData(content: .label("R"), area: .flex(1)),
            PartData(content: .label("S"), area: .flex(1)),
            PartData(content: .label("T"), area: .flex(1)),
            PartData(content: .label("U"), area: .flex(1)),
            PartData(content: .label("V"), area: .flex(1)),
            PartData(content: .label("W"), area: .flex(1)),
            PartData(content: .label("X"), area: .flex(1)),
            PartData(content: .label("Y"), area: .flex(1)),
            PartData(content: .label("Z"), area: .flex(1)),
         ]
      )

      var body: some View {
         Form {
            RouletteView(model: self.rouletteModel)

            Section {
               Button("Start") {
                  self.rouletteModel.start()
               }

               Button("Stop") {
                  self.rouletteModel.stop()
               }

               Button("Jump to 'X'") {
                  withAnimation {
                     self.rouletteModel.stop(at: Angle(degrees: 359))
                  }
               }
            }
         }
      }
   }

   return Preview()
}
