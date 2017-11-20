# Heimdall Documentation & Architecture

This document describes the architecture & design decisions of the Heimdall iOS app.

## Secret Keys

Secret keys should never be committed to the repository, as it is public & open source. Instead, we add the secrets to a file `env-vars.sh`. This file is ignored in git and needs to be created by the developer themselves. A `env-vars.sh.example` is committed to the repo and shows the general structure and env vars that need to be set for the app to work. Developers should copy the example file to `env-vars.sh` and add their keys to it. 

Travis CI automatically injects the correct environment variables so no need to have a `env-vars.sh` there.

During an Xcode pre-compile script phase, the `env-vars.sh` is sourced. These keys are then passed to [Sourcery](https://github.com/krzysztofzablocki/Sourcery). 

Script:

    #check if env-vars.sh exists
    if [ -f ./env-vars.sh ]
    then
    source ./env-vars.sh
    fi
    #no `else` case needed if the CI works as expected
    mint run krzysztofzablocki/Sourcery@0.9.0 "sourcery --templates ./Heimdall/Other --sources . --output ./Heimdall/Other --args infurakey=$GNS_INFURA_KEY"

New keys need to be added to `Secrets.stencil` which is the template file for `Secrets.generated.swift` (ignored in git). That file is compiled with Xcode and exposes an enum with the keys. They also need to be added to Travis CI as a hidden variable (as our repo & travis is open & readable by everyone.

## Dependencies

For complete information on dependencies and their versions check out the `Cartfile`.

### [BigInt](https://github.com/attaswift/BigInt) For Numbers

All numbers that are used for Solidity & Ethereum cross compat need to be instances of `BigInt` or `BigUInt`, as Ethereum supports integers up to 256 bits, which is bigger than the largest int in Swift.

### [PureLayout](https://github.com/PureLayout/PureLayout) for AutoLayout

For creating constraints in code, we use PureLayout. It is not a full DSL, rather a set of methods that allow for easy creation of constraints. 

## EtherAmount

Amounts of ether should always be returned as instances of `EtherAmount`. This struct can be used to format ether amounts and it codifies the denomications of ether. 

You can either instantiate an instance with the denomination given, e.g. `EtherAmount(wei: BigInt(1_000_000))` or `EtherAmount(ether: BigInt(1))` or you can use the extension provided on BigInt that allows you to create instances in a natural language way.

Code example:

    // Create an amount of 1 million Wei
    let amountOfWei = BigInt(1_000_000).wei
    print(amountOfWei.description) // prints "1000000 Wei"
    print(amountOfWei.descriptionAsWei) // prints "1000000 Wei"
    print(amountOfWei.descriptionAsEther) // prints "0.0000 Ξ"
    
    // Create an amount of 1 Ether
    let amountOfEther = BigInt(1).ether
    print(amountOfEther.description) // prints "1.0000 Ξ"
    print(amountOfEther.descriptionAsWei) // prints "1000000000000000000 Wei"
    print(amountOfEther.descriptionAsEther) // prints "1.0000 Ξ"

## Architecture Patterns

### General Architecture

MVVM with Coordinators implements a kind of graph. The highest level is the `AppCoordinator`, which is created by the `AppDelegate`, which then transfers all control to it. `AppCoordinator` is the root of the coordinator graph.

Coordinators can start as many child coordinators as they want. For example, the `LoggedInCoordinator` is `TabBarCoordinator`, which has many `TabCoordinator` children.

Coordinators then present view controllers. This is done by creating the view model for the view controllers and instantiating them with it. View controllers then instantiate their UIView subclass.

Everything is connected with Reactive glue (from leaf to root):

View controllers bind the view properties (e.g. label texts) to view model outputs (e.g. `Property<String>`). They also connect view actions (e.g. button taps) to view model inputs (`SafePublishSubject<Void>`).

View models take model properties and changes and bind them to their outputs. Also they observe their inputs and act accordingly (e.g. updating & storing a model object).

Coordinators that created the view models bind to their outputs that they cannot handle themselves (stuff that needs navigation/coordination). For example the `SafeListViewModel` exposes an `addSafe` `PublishSubject`. The `SafeListCoordinator` observes this subject (see code excerpt in Coordinators section). In case of a new event there, it starts the `AddSafe` flow, which is a new coordinator. On a successful result from the AddSafe flow, the coordinator adds a new safe to the store which the view model then immediately picks up and displays.

### Coordinators

Heimdall uses the Coordinator pattern as described in [this fantastic article](http://khanlou.com/2015/10/coordinators-redux/). The UPTech team has demonstrated a [nice MVVM-Rx way](https://blog.uptech.team/taming-great-complexity-mvvm-coordinators-and-rxswift-8daf8a76e7fd) of using it, which we are using in a version modified for `ReactiveKit`.

The base class for all coordinators is `BaseCoordinator` which outlines the general flow and handling for coordinators. It has a `start()` method, which returns a `ReactiveKit.Signal` of its associated `CoordinationResult` type. This allows coordinators to represent complete flows of actions (e.g. adding a safe) which can easily be chained.

Example from `SafeListCoordinator.start()`:

    safeListViewModel
        .addSafe
        .flatMapLatest { _ in
            self.coordinate(to: 
                AddSafeCoordinator(navigationController: self.navigationController))
        }
        .flatMap { (result: AddSafeCoordinator.CoordinationResult) -> Safe? in
            guard case .safe(let newSafe) = result else {
                return nil
            }
            return newSafe
        }
        .observeNext { safe in
            _ = try? safeStore.add(safe)
        }
        .dispose(in: disposeBag)

This listens for the `addSafe` Signal in the ViewModel, navigates to the `AddSafe` flow, which is free to present alerts or view controllers, and then acts according to the result (either `.cancel` or `.safe(Safe)`).

### UI 

Heimdall does not use storyboards or Xib files for anything (except for the launchscreen). 

UI is created completely in code with AutoLayout in `UIView` subclasses. Heimdall includes two helper classes for this process, `AutolayoutView` & `AutolayoutScrollView`. These should be subclassed and then you should override `setupSubviews()` and `setupInitialConstraints()` for your subviews and their constraints.

As we create all UI in code, our ViewControllers only assign the  correct instance of their view to their `view` property in `loadView()`. This is facilitated with a generic `SeparatedViewController<ViewType>` class, which already does initializes and assigns an instance of `ViewType`. That `ViewType` needs to have an empty initialiser (for easy creation). Initialising any `UIView` or `UIViewController` subclass with a coder or a nib file is not possible, the app will crash.

Example `SafeListView`:

    
    class SafeListView: AutoLayoutView {
        let tableView = UITableView()
    
        override func setupSubviews() {
            addSubview(tableView)
            tableView.register(ReactiveUITableViewCell.self,
                               forCellReuseIdentifier: String(describing: ReactiveUITableViewCell.self))
        }
    
        override func setupInitialConstraints() {
            tableView.autoPinEdgesToSuperviewEdges()
        }
    }

Example `SafeListViewController`:

    class SafeListViewController: SeparatedViewController<SafeListView> [...] {
        let viewModel: SafeListViewModel
    
        init(viewModel: SafeListViewModel) {
            self.viewModel = viewModel
            super.init()
    
            // Bind ViewModel inputs/outputs here
            // Example:
            viewModel.items.bind(to: customView.tableView) {
                [...]
            }
        }
    
        required init?(coder aDecoder: NSCoder) { dieFromCoder() }
    
    }

`SeparatedViewController` already instantiates and correctly assigns the view type you specialise on. The view is available as `customView` without casting from `UIView`. 

### Storage & Models

The app includes multiple storage options. 

There is a class for secure storage (`SecureDataStore`), backed by the keychain, which are currently used for securing the credentials of the authenticated user. 
There is also a class for regular disk storage (`DiskStore`), currently backed by json files on the disk. 
Both implement the protocol `DataStore` which is a simple key value store.

There is also a higher level store (`AppDataStore<Element>`), which can be backed by anything implementing `DataStore` and allows for storage of lists of `Element`s. Elements need to implement the protocol `Storable` which only exposes a `storageKey` property which has to be unique in the app.

Models (e.g. `Token`) are simple Swift structs that implement `Storable` (which also required `Codable` & `Equatable`).

Example Model:

    struct Token: Storable {
        let address: String
        let name: String
        let symbol: String
        let decimals: Int
        let whitelisted: Bool
    
        static var storageKey: String {
            return "Token"
        }
    }
    
    // MARK: - Equatable
    extension Token: Equatable {
        static func == (lhs: Token, rhs: Token) -> Bool {
            return lhs.address == rhs.address
        }
    }

This, in combination with `let tokenStore = AppDataStore<Token>(store: storageBackend)`, is all that is needed to store elements on the disk and react to changes (AppDataStore exposes a signal when the contents change).

Stores should be created once and passed from top coordinators to bottom coordinators and view models, otherwise changes are not picked up and it might come to race conditions when two stores accessing the same models want to write at the same time. 

### Dependency Injection

In Heimdall we use constructor dependency injection. This means you should create stores & network clients in a higher level than where you're using it and pass it into the object via constructor.

For example if a ViewModel needs access to an instance of `AppDataStore<Token>`, you should create that store in the object that creates the view model (e.g. the coordinator). Then you inject that in to the view model. 

This pattern allows the ViewModel to be easily tested by injecting a mock.

If you need certain stores multiple times in your application at different locations and you want to get notified of changes that occur in other locations, you should create them only one and pass them down from level to level to the place where they are needed. This is necessary because the stores do not listen to storage backend events. Change events are only propagated in the same store instance.

For example if you need the token store in the `TokenListViewModel` and the `SafeListViewModel`, create it in the `LoggedInCoordinator`, as that is the coordinator that creates both the `TokenListCoordinator` and the `SafeListCoordinator`.

### Helpers

Heimdall includes some helpers for easier handling of some things.

#### ReactiveUITableViewCell

A regular UITableViewCell subclass including a ReactiveKit `DisposeBag` which is disposed in `prepareForReuse`. Use this directly if you only need to default styles or to create subclasses for specific tables.

#### `die(_ error:)`

Call `die(_ error: Swift.Error)` from any point in the application if you encounter a terminal failure. It will print out the error nicely and also put it in the device log (not only `stderr`) via `NSLog()`. You can define the error for example as a subtype of your model:

    struct Credentials: Codable {
        enum Error: String, Swift.Error {
            case invalidMnemonicPhrase
        }
        [...]
    }
    
    // some other place:
    die(Credentials.Error.invalidMnemonicPhrase)

