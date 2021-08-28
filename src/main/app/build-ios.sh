flutter clean \
        && rm ios/Podfile.lock pubspec.lock || true\
        && rm -rf ios/Pods ios/Runner.xcworkspace || true \
        && flutter build ios --no-sound-null-safety --release
