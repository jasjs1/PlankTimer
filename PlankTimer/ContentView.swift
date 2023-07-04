//
//  DailyPlankChallengeView.swift
//  PlankTimer
//
//  Created by Jayce Sagvold on 7/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PlankStopwatchView()) {
                    Image("PlankStopWatch-360x360")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .padding()
                }
                
                Spacer()
                
                NavigationLink(destination: PlankStopwatchView()) {
                    Image("PlankStopWatch-360x360")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
