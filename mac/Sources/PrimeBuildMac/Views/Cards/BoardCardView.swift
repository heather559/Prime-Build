import SwiftUI

/// §3: board grid card — adds an "Agent Pick" star badge, an "On Tour" badge,
/// an optional greyed-out status overlay with backdrop blur, and a compact
/// reaction row + tour-toggle icon button pair.
struct BoardCardView: View {
    @Environment(AppState.self) private var appState
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                appState.navigate(to: .listingDetail(listing.id))
            } label: {
                ZStack(alignment: .topTrailing) {
                    PlaceholderPhoto(seed: listing.id)

                    if let status = listing.status {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .overlay(Rectangle().fill(Theme.ink.opacity(0.25)))
                            .overlay(
                                SmallCapsText(status, size: 11, weight: .semibold)
                                    .foregroundStyle(.white)
                            )
                    }

                    VStack(alignment: .trailing, spacing: 6) {
                        if listing.isAgentPick {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill").font(.system(size: 9))
                                Text("agent pick").font(Theme.sans(9, weight: .semibold)).tracking(9 * Theme.smallCapsTracking)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.champagne)
                            .clipShape(Capsule())
                        }
                        if listing.tourListed {
                            Text("on tour")
                                .font(Theme.sans(9, weight: .semibold))
                                .tracking(9 * Theme.smallCapsTracking)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Theme.olive)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(8)

                    Pill(text: listing.neighborhood)
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(listing.address)
                    .font(Theme.sans(12, weight: .medium))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                Text(listing.displayPrice)
                    .font(Theme.display(15))
                    .tracking(15 * Theme.priceTracking)
                    .foregroundStyle(Theme.ink)
                Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Bed") · \(listing.baths) Bath")
                    .font(Theme.sans(11))
                    .foregroundStyle(Theme.mutedForeground)
            }
            .padding(10)

            Divider().overlay(Theme.line)

            HStack(spacing: 8) {
                ReactionButton(systemImage: "heart.fill", isActive: listing.reaction == .love, size: 22) {
                    appState.setReaction(.love, for: listing.id)
                }
                ReactionButton(systemImage: "clock.fill", isActive: listing.reaction == .maybe, size: 22) {
                    appState.setReaction(.maybe, for: listing.id)
                }
                ReactionButton(systemImage: "xmark", isActive: listing.reaction == .pass, size: 22) {
                    appState.setReaction(.pass, for: listing.id)
                }

                Spacer()

                Button {
                    appState.toggleTour(for: listing.id)
                } label: {
                    Image(systemName: listing.tourListed ? "car.fill" : "car")
                        .font(.system(size: 12))
                        .foregroundStyle(listing.tourListed ? Theme.olive : Theme.mutedForeground)
                }
                .buttonStyle(.plain)
            }
            .padding(10)
        }
        .cardShell()
    }
}
