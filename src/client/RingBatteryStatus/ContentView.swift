//
//  ContentView.swift
//  RingBatteryStatus
//
//  Created by Justin Middler on 24/11/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Add Widget in 'Widgets' to see battery percentage.")
                .foregroundColor(.white)
                .bold()
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.gray, .primary]), startPoint: .top, endPoint: .bottom))

    }
}
