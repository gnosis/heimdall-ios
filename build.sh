source '.env'

xcodebuild clean && \
xcodebuild test \
    -sdk iphonesimulator \
    -project Heimdall.xcodeproj \
    -scheme Heimdall \
    -destination 'platform=iOS Simulator,name=iPhone X,OS=11.0' \
    CODE_SIGNING_REQUIRED=NO \
    GNS_INFURA_KEY="$GNS_INFURA_KEY"
