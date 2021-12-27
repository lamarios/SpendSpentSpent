OPTS=""
if [ -z ${DRONE_TAG+x} ]; then
  echo "Build number: ${DRONE_TAG}"
  OPTS="--build-number ${DRONE_TAG}"
else
  echo "No build number, using default"
fi

flutter clean \
        && rm ios/Podfile.lock pubspec.lock || true\
        && rm -rf ios/Pods ios/Runner.xcworkspace || true \
        && flutter build ios --release ${OPTS}
