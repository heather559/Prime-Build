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
                HStack(spacing: 20) {
                    Button("Review Mode") { appState.navigate(to: .boardReview) }
                        .buttonStyle(.plain)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.mutedText)

                    Text("Board Mode")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.charcoal)
                        .overlay(Rectangle().fill(Theme.gold).frame(height: 2), alignment: .bottom)
                }

                HStack(spacing: 10) {
                    ForEach(BoardFilter.allCases) { filter in
                        boardFilterPill(filter)
                    }
                }

                if !sales.isEmpty {
                    section(title: "Sales", listings: sales)
                }
                if !rentals.isEmpty {
                    section(title: "Rentals", listings: rentals)
                }
                if sales.isEmpty && rentals.isEmpty {
                    Text("No listings match this filter yet.")
                        .font(Theme.body)
                        .foregroundStyle(Theme.mutedText)
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(28)
        }
    }

    private func boardFilterPill(_ filter: BoardFilter) -> some View {
        Button {
            appState.boardFilter = filter
        } label: {
            Text(filter.rawValue)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(appState.boardFilter == filter ? Theme.charcoal : Color(white: 0.94))
                .foregroundStyle(appState.boardFilter == filter ? .white : Theme.charcoal)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func section(title: String, listings: [Listing]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 16, weight: .bold))

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(listings) { listing in
                    boardCard(listing)
                }
            }
        }
    }

    private func boardCard(_ listing: Listing) -> some View {
        Button {
            appState.navigate(to: .listingDetail(listing.id))
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    PlaceholderPhoto(seed: listing.id, height: 140)

                    if let reaction = listing.reaction {
                        reactionBadge(reaction)
                            .padding(8)
                    }

                    if let status = listing.status {
                        Text(status)
                            .font(.system(size: 10, weight: .semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.gray.opacity(0.85))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(8)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(listing.address).font(.system(size: 12, weight: .semibold)).lineLimit(1)
                    Text(listing.displayPrice).font(.system(size: 14, weight: .bold))
                    Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Bed") · \(listing.baths) Bath")
                        .font(Theme.small)
                        .foregroundStyle(Theme.mutedText)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.08)))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private func reactionBadge(_ reaction: Reaction) -> some View {
        let (icon, tint): (String, Color) = {
            switch reaction {
            case .love: return ("heart.fill", Theme.gold)
            case .maybe: return ("clock.fill", .gray)
            case .pass: return ("xmark", .red)
            }
        }()
        return Image(systemName: icon)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 22, height: 22)
            .background(tint)
            .clipShape(Circle())
    }
}
