OPTS=""
if [ -z ${DRONE_TAG+x} ]; then
  echo "No build number, using default"
else
  echo "Build number: ${DRONE_TAG}"
  OPTS="--build-number ${DRONE_TAG}"
fi

flutter clean \
        && rm ios/Podfile.lock pubspec.lock || true\
        && rm -rf ios/Pods ios/Runner.xcworkspace || true \
        && flutter build ios --release ${OPTS}
