import SwiftUI

struct HeaderView: View {
    @Binding var title: String
    @Binding var selectedTab: Int
    @Binding var isVisible: Bool
    @State private var showFilterModal = false
    @Binding  var selectedJobTypes: Set<String>
    @Binding  var selectedLocations: Set<String>
    @Binding  var selectedSeniorities: Set<String>
    @Binding  var selectedJobTitles: Set<String>
   
  
    
    
    var body: some View {
        
        if isVisible {
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    HStack {
                        if selectedTab == 0 {
                            filterButton
                        }
                        
                        notificationButton
                    }
                }
                .padding(.horizontal, 20)
            }
            .background(Color.secondaryColor)
            .ignoresSafeArea(.container, edges: .bottom)
            .sheet(isPresented: $showFilterModal) {
                FilterModalView(isPresented: $showFilterModal,
                                selectedJobTypes: $selectedJobTypes,
                                selectedLocations: $selectedLocations,
                                selectedSeniorities: $selectedSeniorities,
                                selectedJobTitles: $selectedJobTitles
                              
                               )
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        
    }
    private var hasActiveFilters: Bool {
            !selectedJobTypes.isEmpty ||
            !selectedLocations.isEmpty ||
            !selectedSeniorities.isEmpty ||
            !selectedJobTitles.isEmpty
        }
    // MARK: - Subviews
    
    private var filterButton: some View {
        Button(action: {
            showFilterModal = true
        }) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                
            }
            .foregroundColor(.black)
            .padding(12)
            .background(hasActiveFilters ? Color.blue : Color.white)
            .clipShape(Capsule())
            .shadow(radius: 2)
        }
        .padding(.leading, 10)
    }
    
    private var notificationButton: some View {
        Button(action: {
            // Notification action
        }) {
            Image(systemName: "bell")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding(12)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(radius: 2)
        }
    }
    
   
}

// MARK: - Filter Modal View

struct FilterModalView: View {
    @Binding var isPresented: Bool
    @Binding  var selectedJobTypes: Set<String>
    @Binding  var selectedLocations: Set<String>
    @Binding  var selectedSeniorities: Set<String>
    @Binding  var selectedJobTitles: Set<String>
 
    
    
    let jobTypes = ["Full-time", "Part-time", "Contract", "Freelance", "Intern"]
    let locations = ["New York", "San Francisco", "Chicago", "Austin", "Seattle", "Los Angeles","Dublin","Dundalk"]
    let seniorities = ["Junior", "Mid", "Senior", "Lead", "Intern"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    FilterSectionView(
                        title: "Job Type",
                        options: jobTypes,
                        selectedOptions: $selectedJobTypes
                    )
                    
                    FilterSectionView(
                        title: "Location",
                        options: locations,
                        selectedOptions: $selectedLocations
                    )
                    
                    FilterSectionView(
                        title: "Seniority",
                        options: seniorities,
                        selectedOptions: $selectedSeniorities
                    )
                   
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            
            
        }
    }
}

// MARK: - Filter Section View

struct FilterSectionView: View {
    let title: String
    let options: [String]
    @Binding var selectedOptions: Set<String>
    @State private var isExpanded = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        HStack {
                            Image(systemName: selectedOptions.contains(option) ? "checkmark.square.fill" : "square")
                                .foregroundColor(selectedOptions.contains(option) ? .blue : .gray)
                            Text(option)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                if selectedOptions.contains(option) {
                                    selectedOptions.remove(option)
                                } else {
                                    selectedOptions.insert(option)
                                }
                            }
                        }
                    }
                    
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Preview

//#Preview {
//    struct PreviewWrapper: View {
//        @State var title = "Search Jobs"
//        @State var selectedTab = 0
//        @State var isVisible = true
//        
//        var body: some View {
//            HeaderView(title: $title, selectedTab: $selectedTab, isVisible: $isVisible)
//        }
//    }
//    return PreviewWrapper()
//}
