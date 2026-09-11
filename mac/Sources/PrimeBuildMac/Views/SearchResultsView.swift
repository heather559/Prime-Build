import SwiftUI

struct SearchResultsView: View {
    @Environment(AppState.self) private var appState
    @State private var showPropertyTypeMenu = false

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]

    var filteredListings: [Listing] {
        appState.filteredSearchResults
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                filterBar

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredListings) { listing in
                        if appState.isAuthenticated {
                            FullListingCard(listing: listing)
                        } else {
                            PublicListingCard(listing: listing)
                        }
                    }
                }

                if !appState.isAuthenticated {
                    registerBanner
                }

                footer
            }
            .frame(maxWidth: 1400)
            .padding(.horizontal, 32)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity)
        }
        .background(Theme.cream)
    }

    // MARK: Price presets, scale-aware for sale vs. rental

    private var priceSteps: [Double] {
        appState.saleRentalFilter == .rental
            ? [2_000, 3_000, 4_000, 5_000, 6_000, 8_000, 10_000]
            : [500_000, 1_000_000, 1_500_000, 2_000_000, 3_000_000, 5_000_000, 10_000_000]
    }

    private func priceLabel(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        let text = formatter.string(from: NSNumber(value: value)) ?? "$0"
        return appState.saleRentalFilter == .rental ? "\(text)/mo" : text
    }

    // MARK: Filter bar (§3 "Filter bar")

    private var filterBar: some View {
        @Bindable var appState = appState

        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                saleRentalToggle

                fieldMenu(label: appState.selectedNeighborhood ?? "All Neighborhoods") {
                    Button("All Neighborhoods") { appState.selectedNeighborhood = nil }
                    Divider()
                    ForEach(MockData.neighborhoods, id: \.self) { n in
                        Button(n) { appState.selectedNeighborhood = n }
                    }
                }

                fieldMenu(label: appState.minPrice.map(priceLabel) ?? "No Min") {
                    Button("No Min") { appState.minPrice = nil }
                    Divider()
                    ForEach(priceSteps, id: \.self) { step in
                        Button(priceLabel(step)) { appState.minPrice = step }
                    }
                }

                fieldMenu(label: appState.maxPrice.map(priceLabel) ?? "No Max") {
                    Button("No Max") { appState.maxPrice = nil }
                    Divider()
                    ForEach(priceSteps, id: \.self) { step in
                        Button(priceLabel(step)) { appState.maxPrice = step }
                    }
                }

                propertyTypeMenu

                Spacer()

                OliveButton(title: "Search", height: 44) {}
                    .frame(width: 130)
            }

            HStack(spacing: 20) {
                pillGroup(label: "Beds", options: [(0, "Studio"), (1, "1"), (2, "2"), (3, "3"), (4, "4+")], selection: $appState.selectedBeds)
                pillGroup(label: "Baths", options: [(1, "1"), (2, "2"), (3, "3+")], selection: $appState.selectedBaths)
                doormanToggle
            }
        }
        .padding(16)
        .background(Theme.surface)
        .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))
    }

    private var saleRentalToggle: some View {
        HStack(spacing: 0) {
            ForEach(SaleRentalFilter.allCases, id: \.self) { filter in
                Button {
                    appState.saleRentalFilter = filter
                } label: {
                    SmallCapsText(filter.rawValue, size: 11, weight: .semibold)
                        .foregroundStyle(appState.saleRentalFilter == filter ? .white : Theme.ink)
                        .padding(.horizontal, 18)
                        .frame(height: 40)
                }
                .buttonStyle(.plain)
                .background(appState.saleRentalFilter == filter ? Theme.olive : Color.clear)
            }
        }
        .overlay(Capsule().stroke(Theme.line, lineWidth: 1))
        .clipShape(Capsule())
    }

    private func fieldMenu<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        Menu {
            content()
        } label: {
            HStack {
                Text(label)
                    .font(Theme.sans(12))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 9)).foregroundStyle(Theme.mutedForeground)
            }
            .padding(.horizontal, 12)
            .frame(width: 150, height: 44)
        }
        .menuStyle(.borderlessButton)
        .background(Theme.surface)
        .overlay(RoundedRectangle(cornerRadius: Theme.hairlineRadius).stroke(Theme.line, lineWidth: 1))
    }

    private var propertyTypeMenu: some View {
        Menu {
            ForEach(MockData.propertyTypes, id: \.self) { type in
                Button {
                    if appState.selectedPropertyTypes.contains(type) {
                        appState.selectedPropertyTypes.remove(type)
                    } else {
                        appState.selectedPropertyTypes.insert(type)
                    }
                } label: {
                    HStack {
                        Text(type)
                        if appState.selectedPropertyTypes.contains(type) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            if !appState.selectedPropertyTypes.isEmpty {
                Divider()
                Button("Clear") { appState.selectedPropertyTypes.removeAll() }
            }
        } label: {
            HStack {
                Text(appState.selectedPropertyTypes.isEmpty ? "Property Type" : "\(appState.selectedPropertyTypes.count) Selected")
                    .font(Theme.sans(12))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 9)).foregroundStyle(Theme.mutedForeground)
            }
            .padding(.horizontal, 12)
            .frame(width: 150, height: 44)
        }
        .menuStyle(.borderlessButton)
        .background(Theme.surface)
        .overlay(RoundedRectangle(cornerRadius: Theme.hairlineRadius).stroke(Theme.line, lineWidth: 1))
    }

    private func pillGroup(label: String, options: [(Int, String)], selection: Binding<Set<Int>>) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(Theme.sans(11, weight: .medium))
                .foregroundStyle(Theme.mutedForeground)

            HStack(spacing: 2) {
                ForEach(options, id: \.0) { value, title in
                    FilterChip(title: title, isActive: selection.wrappedValue.contains(value)) {
                        if selection.wrappedValue.contains(value) {
                            selection.wrappedValue.remove(value)
                        } else {
                            selection.wrappedValue.insert(value)
                        }
                    }
                }
            }
            .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))
        }
    }

    private var doormanToggle: some View {
        HStack(spacing: 8) {
            Text("Doorman")
                .font(Theme.sans(11, weight: .medium))
                .foregroundStyle(Theme.mutedForeground)

            HStack(spacing: 2) {
                ForEach(DoormanFilter.allCases) { option in
                    FilterChip(title: option.rawValue, isActive: appState.doormanFilter == option) {
                        appState.doormanFilter = option
                    }
                }
            }
            .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))
        }
    }

    private var registerBanner: some View {
        HStack {
            Text("Register to see addresses, square footage, fees, and full listing details")
                .font(Theme.sans(13, weight: .medium))
                .foregroundStyle(Theme.ink)
            Spacer()
            OliveButton(title: "Create Free Account", height: 40) {
                appState.navigate(to: .register)
            }
            .frame(width: 200)
        }
        .padding(20)
        .background(Theme.oliveSoft)
        .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))
    }

    private var footer: some View {
        VStack(spacing: 6) {
            Divider().overlay(Theme.line)
            Text("Listing information courtesy of RLS at REBNY")
                .font(Theme.sans(10))
                .foregroundStyle(Theme.mutedForeground)
            Text("The data relating to real estate displayed on this site comes in part from RLS. Real estate listings held by brokerage firms other than Heather Domi are marked with the RLS logo and detailed information about them includes the name of the listing broker.")
                .font(Theme.sans(9))
                .foregroundStyle(Theme.mutedForeground)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }
}
