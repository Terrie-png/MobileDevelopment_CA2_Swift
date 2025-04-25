import SwiftUI
import MapKit
import CoreLocationUI

struct MapLocationPicker: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var searchText = ""
    @State private var showSearchResults = false
    @State private var mapSelection: MKMapItem?
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isConfirming = false
    @Binding var selectedLocationName: String
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var model
    @State private var visibleRegion: MKCoordinateRegion?
    
    // Location manager for getting current location
    @StateObject private var locationManager = LocationManager()
    
    var controller: AuthController = AuthController.shared
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Main Map View
                Map(position: $position, selection: $mapSelection) {
                    if let selectedLocation {
                        Marker("Selected Location", coordinate: selectedLocation)
                            .tint(.blue)
                    }
                    
                    UserAnnotation()
                }
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                .mapStyle(.standard)
                .onMapCameraChange { context in
                    visibleRegion = context.region
                }
                .onTapGesture { screenCoord in
                    handleMapTap(at: screenCoord, mapSize: geometry.size)
                }
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
                    HStack{
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
                            
                        }
                        .padding(12)
                        .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                        .padding()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    
                    
                    Spacer()
                    
                    // Location Preview Card or Selection Actions
                    if let selectedLocation {
                        if let lookAroundScene {
                            LocationPreviewCard(scene: lookAroundScene) {
                                isConfirming = true
                            }
                            .transition(.move(edge: .bottom))
                        } else {
                            // Show a simple confirmation card when no look around scene is available
                            SimpleLocationConfirmCard(locationName: selectedLocationName) {
                                isConfirming = true
                            }
                            .transition(.move(edge: .bottom))
                        }
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
                
                // Current Location Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        LocationButton(.currentLocation) {
                            if let userLocation = locationManager.userLocation {
                                selectedLocation = userLocation
                                position = .camera(MapCamera(centerCoordinate: userLocation, distance: 1000))
                                lookupLocationName(for: userLocation)
                            }
                        }
                        .labelStyle(.iconOnly)
                        .symbolVariant(.fill)
                        .tint(.blue)
                        .clipShape(Circle())
                        .padding()
                    }
                }
            }
            
            .onAppear {
                locationManager.requestLocation()
            }
            .confirmationDialog("Confirm Location", isPresented: $isConfirming) {
                Button("Confirm") {
                    guard let userModel: UserModel = controller.getUserModel(modelContext: model) else {
                        print("Getting usermodel going error")
                        return
                    }
                    if let selectedLocation {
                        userModel.geoLatitude = selectedLocation.latitude
                        userModel.geoLongitude = selectedLocation.longitude
                    }
                    
                    userModel.location = selectedLocationName
                    
                    do {
                        try model.save()
                        dismiss()
                    } catch {
                        print("Unable to save model")
                        return
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    private func searchLocations() async {
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = searchText
        request.resultTypes = [.pointOfInterest, .address]
        
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
    
    private func handleMapTap(at point: CGPoint, mapSize: CGSize) {
        
        guard let region = visibleRegion else { return }
        let minimumZoomLevel: CLLocationDegrees = 0.05
            guard region.span.latitudeDelta <= minimumZoomLevel else {
                print("Map is not zoomed in enough to select a location")
                return
            }
//        let relativeX = point.x / mapSize.width
//        let relativeY = point.y / mapSize.height
//        let latDelta = region.span.latitudeDelta * (0.5 - relativeY) * 2
//        let lonDelta = region.span.longitudeDelta * (relativeX - 0.5) * 2
        let coordinate = CLLocationCoordinate2D(
            latitude: region.center.latitude ,//+ latDelta,
            longitude: region.center.longitude //+ lonDelta
        )
        selectedLocation = coordinate
        lookupLocationName(for: coordinate)
    }
    
    private func lookupLocationName(for coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                selectedLocationName = "Selected Location"
                return
            }
            
            if let placemark = placemarks?.first {
                // Create a formatted address
                let name = placemark.name ?? ""
                let thoroughfare = placemark.thoroughfare ?? ""
                let subThoroughfare = placemark.subThoroughfare ?? ""
                let locality = placemark.locality ?? ""
                
                if !name.isEmpty {
                    selectedLocationName = name
                } else if !thoroughfare.isEmpty {
                    selectedLocationName = [subThoroughfare, thoroughfare, locality]
                        .filter { !$0.isEmpty }
                        .joined(separator: " ")
                } else {
                    selectedLocationName = "Selected Location"
                }
                
                // Create a MapItem for the LookAround preview
                let item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                item.name = selectedLocationName
                mapSelection = item
            }
        }
    }
}

// Location Manager Class for getting current device location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

// Simple confirmation card for when LookAround isn't available
struct SimpleLocationConfirmCard: View {
    var locationName: String
    var confirmAction: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                
                Text(locationName)
                    .font(.headline)
                    .lineLimit(2)
                
                Spacer()
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

// Usage Example:
struct LocationSettingsView: View {
    @State private var currentLocation = "Select Location"
    @State private var showMapPicker = false
    @Binding var isVisible: Bool
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationStack {
            ZStack{
                Color.secondaryColor.ignoresSafeArea()
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
                isVisible = false
            }
            
        }
    }
    
    
    func loadUserLocation(){
        guard let userModel = AuthController.shared.getUserModel(modelContext: context) else {
            print("No user model found")
            return
        }
        
        if (userModel.location != ""){
            currentLocation = userModel.location ?? currentLocation
        }
    }
}

