import SwiftUI

struct ListingDetailView: View {
    @Environment(AppState.self) private var appState
    let listing: Listing
    @State private var selectedThumbnail: Int = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                PlaceholderPhoto(seed: "\(listing.id)-\(selectedThumbnail)", height: 380)

                HStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { index in
                        Button {
                            selectedThumbnail = index
                        } label: {
                            PlaceholderPhoto(seed: "\(listing.id)-\(index)", height: 64)
                                .frame(width: 90)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(selectedThumbnail == index ? Theme.gold : .clear, lineWidth: 2)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)

                HStack(alignment: .top, spacing: 32) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(listing.fullAddress)
                            .font(.system(size: 26, weight: .bold))
                        Text(listing.displayPrice)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Theme.gold)

                        Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Beds") · \(listing.baths) Bath · \(listing.sqft) sq ft · \(listing.propertyType)")
                            .font(Theme.body)
                            .foregroundStyle(Theme.mutedText)

                        if let maintenance = listing.maintenance {
                            Text("Monthly maintenance: \(currency(maintenance))/mo")
                                .font(Theme.body)
                                .foregroundStyle(Theme.mutedText)
                        }

                        Text(listing.description)
                            .font(Theme.body)
                            .foregroundStyle(.black)
                            .padding(.top, 8)

                        Text("Listing Courtesy of \(listing.brokerName)")
                            .font(Theme.small)
                            .foregroundStyle(Theme.mutedText)

                        Divider().padding(.vertical, 12)

                        Text("RLS Data display by Heather Domi Team")
                            .font(Theme.small)
                            .foregroundStyle(Theme.mutedText)
                        Text("Listing information courtesy of RLS at REBNY. Real estate listings held by brokerage firms other than Heather Domi are marked with the RLS logo.")
                            .font(.system(size: 10))
                            .foregroundStyle(Theme.mutedText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 14) {
                        Text(listing.displayPrice)
                            .font(.system(size: 20, weight: .bold))

                        HStack(spacing: 16) {
                            reactionButton(.love, "heart.fill")
                            reactionButton(.maybe, "clock.fill")
                            reactionButton(.pass, "xmark")
                        }

                        Button(listing.tourListed ? "Added to Tour ✓" : "Add to Tour List") {
                            appState.toggleTour(for: listing.id)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(listing.tourListed ? Theme.mutedText : Theme.gold)
                        .foregroundStyle(.white)
                        .font(.system(size: 13, weight: .semibold))
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                        Button(listing.onBoard ? "Saved to Board ✓" : "Save to Board") {
                            appState.toggleBoard(for: listing.id)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.charcoal, lineWidth: 1))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.charcoal)

                        Divider().padding(.vertical, 8)

                        HStack(spacing: 12) {
                            Circle().fill(Color(white: 0.85)).frame(width: 48, height: 48)
                                .overlay(Text("HD").font(.system(size: 12, weight: .bold)))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Heather Domi").font(.system(size: 13, weight: .semibold))
                                Text("(212) 555-0123").font(Theme.small).foregroundStyle(Theme.mutedText)
                                Text("heather@heatherdomi.com").font(Theme.small).foregroundStyle(Theme.mutedText)
                            }
                        }
                    }
                    .padding(16)
                    .frame(width: 260)
                    .background(Color(white: 0.97))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(24)
            }
        }
    }

    private func reactionButton(_ reaction: Reaction, _ systemImage: String) -> some View {
        Button {
            appState.setReaction(reaction, for: listing.id)
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 18))
                .foregroundStyle(listing.reaction == reaction ? Theme.gold : Theme.mutedText)
                .frame(width: 36, height: 36)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black.opacity(0.1)))
        }
        .buttonStyle(.plain)
    }

    private func currency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}
