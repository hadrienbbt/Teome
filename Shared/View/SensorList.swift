//
//  ContentView.swift
//  Shared
//
//  Created by Hadrien Barbat on 17/11/2021.
//

import SwiftUI


struct SensorList: View {
    @ObservedObject var viewModel = SensorViewModel()
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    ForEach($viewModel.sensors) {
                        Widget(sensor: $0)
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Teome")
            .foregroundColor(.white)
            .padding()
            .withBackgoundGradient()
        }
        .onAppear {
            viewModel.fetchSensors()
        }
    }
}

struct SensorList_Previews: PreviewProvider {
    static var previews: some View {
        SensorList()
    }
}
