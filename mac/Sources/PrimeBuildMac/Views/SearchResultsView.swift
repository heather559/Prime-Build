import SwiftUI

struct SearchResultsView: View {
    @Environment(AppState.self) private var appState

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]

    var filteredListings: [Listing] {
        appState.filteredSearchResults
    }

    var body: some View {
        @Bindable var appState = appState

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                filterBar

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredListings) { listing in
                        ListingCardView(listing: listing, showFullDetails: appState.isAuthenticated)
                    }
                }

                if !appState.isAuthenticated {
                    registerBanner
                }

                footer
            }
            .padding(28)
        }
    }

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

    private var filterBar: some View {
        @Bindable var appState = appState

        return HStack(spacing: 16) {
            Picker("", selection: $appState.saleRentalFilter) {
                ForEach(SaleRentalFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 160)

            Picker("Neighborhood", selection: $appState.selectedNeighborhood) {
                Text("All Neighborhoods").tag(String?.none)
                ForEach(MockData.neighborhoods, id: \.self) { n in
                    Text(n).tag(String?.some(n))
                }
            }
            .frame(width: 180)

            Picker("Min", selection: $appState.minPrice) {
                Text("No Min").tag(Double?.none)
                ForEach(priceSteps, id: \.self) { step in
                    Text(priceLabel(step)).tag(Double?.some(step))
                }
            }
            .frame(width: 110)

            Picker("Max", selection: $appState.maxPrice) {
                Text("No Max").tag(Double?.none)
                ForEach(priceSteps, id: \.self) { step in
                    Text(priceLabel(step)).tag(Double?.some(step))
                }
            }
            .frame(width: 110)

            Picker("Beds", selection: $appState.minBeds) {
                Text("Any").tag(Int?.none)
                Text("Studio").tag(Int?.some(0))
                Text("1").tag(Int?.some(1))
                Text("2").tag(Int?.some(2))
                Text("3").tag(Int?.some(3))
                Text("4+").tag(Int?.some(4))
            }
            .frame(width: 100)

            Picker("Baths", selection: $appState.minBaths) {
                Text("Any").tag(Int?.none)
                Text("1").tag(Int?.some(1))
                Text("2").tag(Int?.some(2))
                Text("3+").tag(Int?.some(3))
            }
            .frame(width: 90)

            Spacer()

            Button("Search") {}
                .buttonStyle(.plain)
                .font(.system(size: 13, weight: .semibold))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Theme.gold)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(16)
        .background(Color(white: 0.97))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var registerBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Register to see addresses, square footage, fees, and full listing details")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.charcoal)
            }
            Spacer()
            Button("Create Free Account") {
                appState.navigate(to: .register)
            }
            .buttonStyle(.plain)
            .font(.system(size: 13, weight: .semibold))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Theme.gold)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(20)
        .background(Theme.cream)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var footer: some View {
        VStack(spacing: 4) {
            Divider()
            Text("Listing information courtesy of RLS at REBNY")
                .font(Theme.small)
                .foregroundStyle(Theme.mutedText)
            Text("The data relating to real estate displayed on this site comes in part from RLS. Real estate listings held by brokerage firms other than Heather Domi are marked with the RLS logo and detailed information about them includes the name of the listing broker.")
                .font(.system(size: 10))
                .foregroundStyle(Theme.mutedText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }
}
