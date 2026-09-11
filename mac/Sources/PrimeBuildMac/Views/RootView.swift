import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 0) {
            NavBar()

            Group {
                switch appState.route {
                case .search:
                    SearchResultsView()
                case .listingDetail(let id):
                    if let listing = appState.listing(id: id) {
                        ListingDetailView(listing: listing)
                    } else {
                        SearchResultsView()
                    }
                case .register:
                    RegisterView()
                case .login:
                    LoginView()
                case .boardReview:
                    BoardReviewView()
                case .boardMode:
                    BoardModeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.contentBackground)
        }
    }
}
