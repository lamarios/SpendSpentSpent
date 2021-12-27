flutter clean \
        && rm ios/Podfile.lock pubspec.lock || true\
        && rm -rf ios/Pods ios/Runner.xcworkspace || true \
        && flutter build ios --release
