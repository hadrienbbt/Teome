//
//  WidgetDetails.swift
//  Teome
//
//  Created by Hadrien Barbat on 20/11/2021.
//

import SwiftUI

struct WidgetDetails: View {
    @Binding var sensor: Sensor
    
    var body: some View {
        VStack {

        }
        .foregroundColor(.white)
        .withBackgoundGradient()
        
    }
}

struct WidgetDetails_Previews: PreviewProvider {
    static var previews: some View {
        WidgetDetails(sensor: .constant(Sensor.sampleHumidity))
    }
}
