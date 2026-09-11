import SwiftUI

struct BoardModeView: View {
    @Environment(AppState.self) private var appState

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]

    var filtered: [Listing] {
        appState.listings.filter { listing in
            switch appState.boardFilter {
            case .all: return true
            case .loved: return listing.reaction == .love
            case .maybe: return listing.reaction == .maybe
            case .passed: return listing.reaction == .pass
            case .tourSelected: return listing.tourListed
            case .unreviewed: return listing.reaction == nil
            }
        }
    }

    var sales: [Listing] { filtered.filter { $0.listingType == .sale } }
    var rentals: [Listing] { filtered.filter { $0.listingType == .rental } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 24) {
                    Button {
                        appState.navigate(to: .boardReview)
                    } label: {
                        SmallCapsText("Review Mode", size: 12, weight: .medium)
                            .foregroundStyle(Theme.mutedForeground)
                    }
                    .buttonStyle(.plain)

                    SmallCapsText("Board Mode", size: 12, weight: .semibold)
                        .foregroundStyle(Theme.ink)
                        .overlay(Rectangle().fill(Theme.champagne).frame(height: 2), alignment: .bottom)
                }

                HStack(spacing: 0) {
                    ForEach(BoardFilter.allCases) { filter in
                        FilterChip(title: filter.rawValue, isActive: appState.boardFilter == filter) {
                            appState.boardFilter = filter
                        }
                    }
                }
                .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))

                if !sales.isEmpty {
                    section(title: "Sales", listings: sales)
                }
                if !rentals.isEmpty {
                    section(title: "Rentals", listings: rentals)
                }
                if sales.isEmpty && rentals.isEmpty {
                    Text("No listings match this filter yet.")
                        .font(Theme.sans(13))
                        .foregroundStyle(Theme.mutedForeground)
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxWidth: 1400)
            .padding(.horizontal, 32)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity)
        }
        .background(Theme.cream)
    }

    private func section(title: String, listings: [Listing]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(Theme.display(18))
                .tracking(18 * Theme.headingTracking)
                .foregroundStyle(Theme.ink)

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(listings) { listing in
                    BoardCardView(listing: listing)
                }
            }
        }
    }
}
