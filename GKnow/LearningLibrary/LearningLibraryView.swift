import SwiftUI
//

struct LearningLibraryView: View {
    // Create instances of the content structs
    let symbols = LibraryContents.symbolNames()
    let relationships = LibraryContents.relationships()
    
    @State private var searchText = ""
    @State private var selectedItem: LibraryItem? = nil
    @State private var showDetailView = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header with search bar
                HStack {
                    Text("Learning Library")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("search", text: $searchText)
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(width: UIHelper.relativeWidth(0.3))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        // Individuals section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Individuals")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: UIHelper.relativeWidth(0.25), maximum: UIHelper.relativeWidth(0.3)), spacing: 16)
                            ], spacing: 16) {
                                // Use a simpler approach with ForEach
                                let individualSymbols = [
                                    symbols.male,
                                    symbols.female,
                                    symbols.abortion,
                                    symbols.pregancy,
                                    symbols.miscarriage
                                ]
                                
                                ForEach(0..<individualSymbols.count, id: \.self) { index in
                                    let symbol = individualSymbols[index]
                                    EnhancedCardView(
                                        title: symbol[0],
                                        image: symbol[1],
                                        description: symbol[2],
                                        onReadMore: {
                                            selectedItem = LibraryItem(title: symbol[0], image: symbol[1], description: symbol[2])
                                            showDetailView = true
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Relationship Lines section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Relationship Lines")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: UIHelper.relativeWidth(0.25), maximum: UIHelper.relativeWidth(0.3)), spacing: 16)
                            ], spacing: 16) {
                                // Use a simpler approach for relationships
                                let relationshipArray = [
                                    relationships.marriage,
                                    relationships.dating,
                                    relationships.harmony,
                                    relationships.friendship,
                                    relationships.child,
                                    relationships.abuse,
                                    relationships.fusion,
                                    relationships.focus,
                                    relationships.affair,
                                    relationships.divorce
                                ]
                                
                                ForEach(0..<relationshipArray.count, id: \.self) { index in
                                    let relationship = relationshipArray[index]
                                    EnhancedCardView(
                                        title: relationship[0],
                                        image: relationship[1],
                                        description: relationship[2],
                                        onReadMore: {
                                            selectedItem = LibraryItem(title: relationship[0], image: relationship[1], description: relationship[2])
                                            showDetailView = true
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .padding(.vertical)
            .background(Color.white)
            
            // Show detail view as an overlay when a card is selected
            if showDetailView, let item = selectedItem {
                LibraryDetailView(item: item, isPresented: $showDetailView)
                    .transition(.opacity)
                    .zIndex(1)
                    .navigationTitle("")
                    .navigationBarBackButtonHidden(true)
            }
        }
        .navigationBarHidden(true)
    }
}
