import SwiftUI

struct ListingDetailView: View {
    @Environment(AppState.self) private var appState
    let listing: Listing
    @State private var selectedThumbnail: Int = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                PlaceholderPhoto(seed: "\(listing.id)-\(selectedThumbnail)", aspectRatio: nil, fixedHeight: 420)

                HStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { index in
                        Button {
                            selectedThumbnail = index
                        } label: {
                            PlaceholderPhoto(seed: "\(listing.id)-\(index)", aspectRatio: nil, fixedHeight: 64)
                                .frame(width: 90)
                                .overlay(
                                    Rectangle()
                                        .stroke(selectedThumbnail == index ? Theme.champagne : .clear, lineWidth: 2)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)

                HStack(alignment: .top, spacing: 32) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(listing.fullAddress)
                            .font(Theme.display(28))
                            .tracking(28 * Theme.headingTracking)
                            .foregroundStyle(Theme.ink)

                        Text(listing.displayPrice)
                            .font(Theme.display(22))
                            .tracking(22 * Theme.priceTracking)
                            .foregroundStyle(Theme.olive)

                        Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Beds") · \(listing.baths) Bath · \(listing.sqft) sq ft · \(listing.propertyType)")
                            .font(Theme.sans(13))
                            .foregroundStyle(Theme.mutedForeground)

                        if let maintenance = listing.maintenance {
                            Text("Monthly maintenance: \(currency(maintenance))/mo")
                                .font(Theme.sans(13))
                                .foregroundStyle(Theme.mutedForeground)
                        }

                        Text(listing.description)
                            .font(Theme.sans(13))
                            .foregroundStyle(Theme.ink)
                            .padding(.top, 8)

                        Text("Listing Courtesy of \(listing.brokerName)")
                            .font(Theme.sans(11))
                            .foregroundStyle(Theme.mutedForeground)

                        Divider().overlay(Theme.line).padding(.vertical, 12)

                        Text("RLS Data display by Heather Domi Team")
                            .font(Theme.sans(11))
                            .foregroundStyle(Theme.mutedForeground)
                        Text("Listing information courtesy of RLS at REBNY. Real estate listings held by brokerage firms other than Heather Domi are marked with the RLS logo.")
                            .font(Theme.sans(9))
                            .foregroundStyle(Theme.mutedForeground)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1.7)

                    VStack(alignment: .leading, spacing: 14) {
                        Text(listing.displayPrice)
                            .font(Theme.display(19))
                            .tracking(19 * Theme.priceTracking)
                            .foregroundStyle(Theme.ink)

                        HStack(spacing: 12) {
                            ReactionButton(systemImage: "heart.fill", isActive: listing.reaction == .love) {
                                appState.setReaction(.love, for: listing.id)
                            }
                            ReactionButton(systemImage: "clock.fill", isActive: listing.reaction == .maybe) {
                                appState.setReaction(.maybe, for: listing.id)
                            }
                            ReactionButton(systemImage: "xmark", isActive: listing.reaction == .pass) {
                                appState.setReaction(.pass, for: listing.id)
                            }
                        }

                        OliveButton(title: listing.tourListed ? "Added to Tour" : "Add to Tour List") {
                            appState.toggleTour(for: listing.id)
                        }

                        InkOutlineButton(title: listing.onBoard ? "Saved to Board" : "Save to Board") {
                            appState.toggleBoard(for: listing.id)
                        }

                        Divider().overlay(Theme.line).padding(.vertical, 8)

                        HStack(spacing: 12) {
                            Circle().fill(Theme.oliveSoft).frame(width: 48, height: 48)
                                .overlay(
                                    Text("HD")
                                        .font(Theme.sans(12, weight: .semibold))
                                        .foregroundStyle(Theme.olive)
                                )
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Heather Domi").font(Theme.sans(13, weight: .semibold)).foregroundStyle(Theme.ink)
                                Text("(212) 555-0123").font(Theme.sans(11)).foregroundStyle(Theme.mutedForeground)
                                Text("heather@heatherdomi.com").font(Theme.sans(11)).foregroundStyle(Theme.mutedForeground)
                            }
                        }
                    }
                    .padding(16)
                    .frame(width: 260)
                    .background(Theme.surface)
                    .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))
                    .layoutPriority(1)
                }
                .padding(24)
                .frame(maxWidth: 1240)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .background(Theme.cream)
    }

    private func currency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}
