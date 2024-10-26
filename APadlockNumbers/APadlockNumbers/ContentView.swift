//
//  ContentView.swift
//  APadlockNumbers
//
//  Created by Juan Manuel Moreno on 25/10/24.
//

import SwiftUI
import Combine

private var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
private let code = "534"
private var margin: CGFloat = 78

struct ContentView: View {
    var body: some View {
        PadlockView()
    }
}

struct PadlockView: View {
    @StateObject var padlockSuleyState = PadlockState()
    @StateObject var padlockYaraState = PadlockState()
    @StateObject var padlockPaulaState = PadlockState()

    var body: some View {
        VStack {
            Text("Padlock")
            PadlockScroll(state: padlockSuleyState)
            PadlockScroll(state: padlockYaraState)
            PadlockScroll(state: padlockPaulaState)
            Button("Unlock") {
                let trying = "\(String(padlockSuleyState.current))\(String(padlockYaraState.current))\(String(padlockPaulaState.current))"
                print(trying == code ? "OK" : "KO")
            }
        }
    }
}

struct PadlockScroll: View {
    
    @ObservedObject var state: PadlockState
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                VStack {
                    Button("Unlock") {
                        print(state.current)
                    }
                    HStack {
                        ForEach(numbers, id: \.self) { number in
                            ZStack {
                                Rectangle()
                                    .fill(.pink)
                                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 5)
                                    .background(GeometryReader { innerGeometry in
                                        Color.clear
                                            .preference(key: VisibilityPreferenceKey.self, value: [number: isVisible(innerGeometry)])
                                            .onPreferenceChange(VisibilityPreferenceKey.self) { visibility in
                                                print(visibility)
                                                state.current = visibility.keys.first ?? 1
                                                print(state.current)
                                            }
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
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo(numbers.first, anchor: .center)
                        }
                    }
                    .scrollTargetLayout()
                }

            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
        .background(Color.gray.opacity(0.2)) // Optional background for visibility
        .cornerRadius(10) // Optional corner radius for styling
        .contentMargins(margin, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
    
    private func isVisible(_ geometry: GeometryProxy) -> Bool {
        let frame = geometry.frame(in: .global)
        return frame.maxX < UIScreen.main.bounds.width - margin && frame.minX > margin
    }
}

struct VisibilityPreferenceKey: PreferenceKey {
    typealias Value = [Int: Bool]
    static var defaultValue: [Int: Bool] = [:]

    static func reduce(value: inout [Int: Bool], nextValue: () -> [Int: Bool]) {
        let next = nextValue()
        for (key, isVisible) in next {
            value[key] = isVisible // Update visibility status
        }
    }
}

class PadlockState: ObservableObject {
    @Published var current = 1
}

#Preview {
    ContentView()
}
