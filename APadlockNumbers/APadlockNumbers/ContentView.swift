//
//  ContentView.swift
//  APadlockNumbers
//
//  Created by Juan Manuel Moreno on 25/10/24.
//

import SwiftUI

private var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
private let code = 123

struct ContentView: View {
        
    var body: some View {
//        VStack(spacing: 0) {
        VStack {
            Text("Padlock")
            PadlockCarousel()
            PadlockCarousel()
            PadlockCarousel()
            Button("Unlock") {
                print("OK")
            }
        }
    }
}

struct PadlockCarousel: View {
    
    @State private var currentPhase: ScrollTransitionPhase = .identity
    @State private var currentOpacity: Double = 1.0 // Track current opacity
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(numbers, id: \.self) { number in
                    ZStack {
                        Rectangle()
                            .fill(.pink)
                            .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 5)
                            .background(GeometryReader { innerGeometry in
                                Color.clear
                                    .preference(key: VisibilityPreferenceKey.self, value: [number: isVisible(innerGeometry)])
                                    .onPreferenceChange(VisibilityPreferenceKey.self) { visibility in
                                        print(visibility)
                                    }
//                                    .onAppear {
//                                        let midX = innerGeometry.frame(in: .global).midX
//                                        DispatchQueue.main.async {
//                                            let position = PositionNumber(number: number, xAtNumber: midX)
//                                            PositionPreferenceKey.send(position)
//                                        }
//                                    }
//                                    .onChange(of: PositionPreferenceKey.positions) { positions in
//                                        print("OK \(PositionPreferenceKey.positions)")
//                                        let midX = innerGeometry.frame(in: .global).midX
//                                        PositionPreferenceKey.doIt()
//                                        let position = PositionNumber(number: number, xAtNumber: midX)
//                                        PositionPreferenceKey.send(position)

//                                        let midX = innerGeometry.frame(in: .global).midX
//                                        DispatchQueue.main.async {
////                                            let number = PositionPreferenceKey.positions.first { $0.xAtNumber == midX}?.number
////                                            print("number is \(number)")
//                                            // Send the midX position to the preference key
//                                            let position = PositionNumber(number: number, xAtNumber: midX)
//                                            PositionPreferenceKey.send(position)
//                                        }

//                                    }

                            })
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1: 0.5)
                                    .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
                            }

                        Text(String(number))
                    }
                    
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(4, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
    
    private func isVisible(_ geometry: GeometryProxy) -> Bool {
        let frame = geometry.frame(in: .global)
        return frame.minX < UIScreen.main.bounds.width && frame.maxX > 0 // Check if the rectangle is within the screen bounds
    }
}

//struct PadlockCarousel: View {
//    let numbers = Array(1...10) // Example numbers
//    @State private var visibleNumber: Int?
//    
//    var body: some View {
//        VStack {
//            Text("Visible Number: \(visibleNumber != nil ? String(visibleNumber!) : "None")")
//                .font(.largeTitle)
//                .padding()
//
//            ScrollView(.horizontal) {
//                HStack {
//                    ForEach(numbers, id: \.self) { number in
//                        GeometryReader { geometry in
//                            ZStack {
//                                Rectangle()
//                                    .fill(Color.pink)
//                                    .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 5)
//                                    .background(GeometryReader { innerGeometry in
//                                        Color.green
//                                            .onAppear {
//                                                // Register the position of the rectangle
//                                                let midX = innerGeometry.frame(in: .global).midX
//                                                DispatchQueue.main.async {
//                                                    // Send the midX position to the preference key
//                                                    let position = Position(number: number, midX: midX)
//                                                    positionPreferenceKey.send(position)
//                                                }
//                                            }
//                                            .onChange(of: positionPreferenceKey.positions) { positions in
//                                                // Determine which rectangle is the topmost
//                                                print("OK")
//                                                let visiblePositions = positions.filter { $0.midX >= geometry.frame(in: .global).minX && $0.midX <= geometry.frame(in: .global).maxX }
//                                                if let topmost = visiblePositions.max(by: { $0.midX < $1.midX }) {
//                                                    visibleNumber = topmost.number
//                                                }
//                                            }
//
//                                    })
//                                    .scrollTransition { content, phase in
//                                        content
//                                            .opacity(phase.isIdentity ? 1 : 0.5)
//                                            .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
//                                    }
//                                
//                                Text(String(number))
//                                    .foregroundColor(.white)
//                                    .font(.largeTitle)
//                            }
//                        }
//                        .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 5)
//                    }
//                }
//            }
//        }
//    }
//}

struct PositionNumber: Equatable {
    let number: Int
    let xAtNumber: CGFloat
}

struct PositionPreferenceKey: PreferenceKey {
    static var positions: [PositionNumber] = []
    static var defaultValue: [PositionNumber] { [] }

    static func reduce(value: inout [PositionNumber], nextValue: () -> [PositionNumber]) {
        value.append(contentsOf: nextValue())
    }

    static func send(_ position: PositionNumber) {
        positions.append(position)
    }
    
    static func doIt() {
        print("doit")
    }
}

struct VisibilityPreferenceKey: PreferenceKey {
    typealias Value = [Int: Bool] // Dictionary to hold visibility status of each rectangle
    static var defaultValue: [Int: Bool] = [:]

    static func reduce(value: inout [Int: Bool], nextValue: () -> [Int: Bool]) {
        let next = nextValue()
        for (key, isVisible) in next {
            value[key] = isVisible // Update visibility status
        }
    }
}

#Preview {
    ContentView()
}
