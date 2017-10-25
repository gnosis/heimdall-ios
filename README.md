# heimdall-ios [![Build Status](https://travis-ci.org/gnosis/heimdall-ios.svg?branch=master)](https://travis-ci.org/gnosis/heimdall-ios)
🔐 App to manage and interact with Gnosis MultiSig Wallets https://wallet.gnosis.pm

## Getting Started
### Install Tools

#### [Mint 🌱](https://github.com/yonaskolb/mint)

Mint is a package manager for Swift command line tools. We use this to install & run [Bivrost](https://github.com/gnosis/bivrost-swift).

See [here](https://github.com/yonaskolb/mint#installing) for installing Mint.

#### [Carthage](https://github.com/Carthage/Carthage)

We use Carthage for dependency management. It involves less friction than e.g. Cocoapods.

See [here](https://github.com/Carthage/Carthage#installing-carthage) for installing Carthage.

#### [SwiftLint](https://github.com/realm/SwiftLint)

SwiftLint is run via Mint in an Xcode build phase. No need to install anything apart from Mint. We are currently using version 0.23.1 (specified in build phase). The first build will take significantly longer, as Mint is downloading and compiling SwiftLint.

### Style Guide

If something is underspecified, refer to this [Style Guide](https://github.com/raywenderlich/swift-style-guide) or SwiftLint's defaults.

### Dependencies

Dependencies are currently checked into the repo at `Carthage/Checkouts`. Built frameworks (`Carthage/Build`) are ignored as they are not cross platform yet (due to [this issue](https://github.com/Carthage/Carthage#dwarfs-symbol-problem)).

To get started with development or after an update by another developer, simply run:

    $ carthage bootstrap --platform iOS

This will build all dependencies without updating them. After that, the Xcode project (`Heimdall.xcodeproj`) should just build.

## Notes

- External programs are run via [Mint](https://github.com/yonaskolb/mint).
- Code Quality is maintained with [SwiftLint](https://github.com/realm/SwiftLint) installed via Mint.
- Contract classes are generated via [Bivrost](https://github.com/gnosis/bivrost-swift) when `Contracts/*` are updated. Use `generate-solidity.sh` for this. As they do not update often, we check them into the repo.

