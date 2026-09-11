# Prime-Build — macOS

Native SwiftUI macOS app for Heather Domi | Buyer Search. This is an isolated Swift Package — no dependency on the `ios/`, `android/`, or `windows/` builds in this repo.

## Requirements

- Xcode 16+ / Swift 6 toolchain
- macOS 14+

## Run

```sh
swift run PrimeBuildMac
```

Or open `Package.swift` in Xcode and run the `PrimeBuildMac` scheme.

## Status

All 7 screens from the original product spec are implemented against local mock data:

- Search results (public + authenticated states)
- Listing detail
- Register / Login
- Buyer board — review mode (swipe) and board mode (grid + filters)

Reactions (Love/Maybe/Pass), "Add to Board," and "Add to Tour List" are wired to local app state. Neighborhood/price/beds/baths filters are live.

**Not yet wired:** real Supabase auth/data. Login and Register currently just flip a local `isAuthenticated` flag — no network calls are made, so nothing is written to the production Supabase project. Listing photos are colored placeholders, not real images.
