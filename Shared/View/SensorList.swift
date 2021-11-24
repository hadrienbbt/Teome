import SwiftUI

struct SensorList: View {
    @ObservedObject var viewModel = SensorViewModel()
    @State private var selectedId: String?
    
    let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach($viewModel.sensors) {
                        Widget(sensor: $0, selectedId: $selectedId)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .withBackgoundGradient(alignment: .leading)
            .navigationBarTitle("Sensors")
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
