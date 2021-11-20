import SwiftUI


struct SensorList: View {
    @ObservedObject var viewModel = SensorViewModel()
    @State private var selectedId: String?
    
    let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 20)
    ]
    
    
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach($viewModel.sensors) {
                        Widget(sensor: $0, selectedId: $selectedId)
                    }
                }
                .padding()
                Spacer()
            }
            .withBackgoundGradient()
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
