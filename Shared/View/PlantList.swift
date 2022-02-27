import SwiftUI

struct PlantList: View {
    var body: some View {
        List {
            ForEach(Plant.Family.allCases) { family in
                Section(family.rawValue) {
                    ForEach(family.varieties) { variety in
                        HStack {
                            Text(variety.rawValue)
                        }
                    }
                    
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct PlantList_Previews: PreviewProvider {
    static var previews: some View {
        PlantList()
    }
}
