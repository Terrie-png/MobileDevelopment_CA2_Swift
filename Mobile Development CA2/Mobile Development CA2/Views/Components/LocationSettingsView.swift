import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestCurrentLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation() // Request single location update
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

struct MapLocationPicker: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var searchText = ""
    @State private var showSearchResults = false
    @State private var mapSelection: MKMapItem?
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isConfirming = false
    @State private var showingLocationAlert = false
    @Binding var selectedLocationName: String
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var model
    
    @StateObject private var locationManager = LocationManager()
    var controller: AuthController = AuthController.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Map View
            Map(position: $position, selection: $mapSelection) {
                if let selectedLocation {
                    Marker("Selected Location", coordinate: selectedLocation)
                        .tint(.blue)
                }
                
                // Show current location if available
                if let currentLocation = locationManager.currentLocation {
                    Annotation("My Location", coordinate: currentLocation) {
                        ZStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 24, height: 24)
                            Circle()
                                .fill(.white)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
            }
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .mapStyle(.standard)
            .onChange(of: mapSelection) {
                if let mapSelection {
                    selectedLocation = mapSelection.placemark.coordinate
                    Task {
                        await fetchLookAroundScene()
                    }
                }
            }
            
            // Search Bar
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search location", text: $searchText)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .onSubmit {
                            Task {
                                await searchLocations()
                                showSearchResults = true
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                            showSearchResults = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Current Location Button
                    Button {
                        handleCurrentLocationTap()
                    } label: {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding(12)
                .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .padding()
                
                Spacer()
                
                // Location Preview Card
                if let selectedLocation, let lookAroundScene {
                    LocationPreviewCard(scene: lookAroundScene) {
                        isConfirming = true
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            
            // Search Results
            if showSearchResults {
                SearchResultsView(
                    searchText: $searchText,
                    mapSelection: $mapSelection,
                    position: $position,
                    showSearchResults: $showSearchResults,
                    selectedLocationName: $selectedLocationName
                )
                .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .confirmationDialog("Confirm Location", isPresented: $isConfirming) {
            Button("Confirm") {
                confirmLocation()
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Location Access Required",
               isPresented: $showingLocationAlert) {
            Button("Settings", role: .none) {
                openAppSettings()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please enable location access in Settings to use this feature")
        }
    }
    
    private func handleCurrentLocationTap() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestCurrentLocation()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestCurrentLocation()
            if let currentLocation = locationManager.currentLocation {
                position = .camera(MapCamera(
                    centerCoordinate: currentLocation,
                    distance: 1000,
                    heading: 0,
                    pitch: 0
                ))
            }
        case .denied, .restricted:
            showingLocationAlert = true
        @unknown default:
            break
        }
    }
    
    private func confirmLocation() {
        guard let userModel: UserModel = controller.getUserModel(modelContext: model) else {
            print("Getting usermodel going error")
            return
        }
        
        if let selectedLocation {
            userModel.geoLatitude = selectedLocation.latitude
            userModel.geoLongitude = selectedLocation.longitude
        }
        
        if let mapSelection {
            selectedLocationName = mapSelection.name ?? "Selected Location"
            userModel.location = selectedLocationName
        }
        
        do {
            try model.save()
            dismiss()
        } catch {
            print("Unable to save model")
        }
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func searchLocations() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.resultTypes = .address
        
        do {
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            SearchResultsView.searchResults = response.mapItems
        } catch {
            print("Search error: \(error.localizedDescription)")
        }
    }
    
    private func fetchLookAroundScene() async {
        if let mapSelection {
            lookAroundScene = try? await MKLookAroundSceneRequest(mapItem: mapSelection).scene
        } else {
            lookAroundScene = nil
        }
    }
}

// Rest of your code (SearchResultsView, LocationPreviewCard, LocationSettingsView) remains the same...

struct SearchResultsView: View {
    @Binding var searchText: String
    @Binding var mapSelection: MKMapItem?
    @Binding var position: MapCameraPosition
    @Binding var showSearchResults: Bool
    @Binding var selectedLocationName: String
    @Environment(\.colorScheme) private var colorScheme
    
    static var searchResults: [MKMapItem] = []
    
    var body: some View {
        VStack {
            if searchText.isEmpty {
                Text("Recent Searches")
                    .font(.headline)
                    .padding(.top)
                // You could add recent searches here
            } else {
                List {
                    ForEach(Self.searchResults, id: \.self) { item in
                        Button {
                            mapSelection = item
                            position = .item(item)
                            showSearchResults = false
                            selectedLocationName = item.name ?? "Selected Location"
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown")
                                    .font(.headline)
                                Text(item.placemark.title ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(maxHeight: 300)
        .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .padding()
    }
}

struct LocationPreviewCard: View {
    let scene: MKLookAroundScene?
    var confirmAction: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            if let scene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: confirmAction) {
                Text("Confirm Location")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 10)
        .padding()
    }
}

// Usage Example:
struct LocationSettingsView: View {
    @State private var currentLocation = "Select Location"
    @State private var showMapPicker = false
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Current Location Display
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("Current Location")
                            .font(.subheadline)
                            .foregroundColor(.gray)


                        Text(currentLocation)
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                    
                    Button {
                        showMapPicker = true
                    } label: {
                        Text("Change")
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
        
            .sheet(isPresented: $showMapPicker) {
                MapLocationPicker(selectedLocationName: $currentLocation)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }.onAppear(){
            loadUserLocation()
        }
    }
    
    func loadUserLocation(){
        guard let userModel = AuthController.shared.getUserModel(modelContext: context) else {
            print("No user model found")
            return
        }
        
        currentLocation = userModel.location ?? "Select Location"
    }
}

// Preview
struct LocationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSettingsView()
    }
}
