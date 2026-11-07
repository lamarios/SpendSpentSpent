{ pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
    config.allowBroken = true;
    config.permittedInsecurePackages = [
      "gradle-7.6.6"
    ];
  }
, ci ? false}:

let
 aliases = [ ];


in
pkgs.mkShell {
  buildInputs = with pkgs; builtins.concatLists [
    [ jdk25 maven gnumake mkdocs git http-server ]
  ];

  # to run CI or DB migrations
  shellHook =  ''

    APP_DIR="${toString ./.}/src/main/app"

    echo "Setting up submodules"
    git submodule init
    git submodule update

    FLUTTER_SUBMODULE="$APP_DIR/submodules/flutter"

    # The flutter submodule downloads prebuilt binaries (dart sdk, engine tools) that are linked
    # against a generic linux loader, which NixOS doesn't have. Point them to the nix one instead.
    patch_flutter_submodule() {
      [ -e /etc/NIXOS ] || return 0
      local interpreter="$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)"
      find "$FLUTTER_SUBMODULE/bin/cache/dart-sdk/bin" "$FLUTTER_SUBMODULE/bin/cache/artifacts/engine" \
        -type f -executable ! -name '*.so' ! -name '*.nixpatch' 2>/dev/null | while read -r f; do
        current="$(patchelf --print-interpreter "$f" 2>/dev/null)" || continue
        if [ "$current" != "$interpreter" ]; then
          # patch a copy and swap it in, the binary might be in use (IDE analysis server for example)
          cp -p "$f" "$f.nixpatch" \
            && patchelf --set-interpreter "$interpreter" \
              --add-rpath "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}" "$f.nixpatch" \
            && mv -f "$f.nixpatch" "$f" || rm -f "$f.nixpatch"
        fi
      done
    }

    if [ -e /etc/NIXOS ]; then
      echo "Patching flutter submodule binaries"
      # First call downloads the dart sdk if it's missing (and fails to run it), second one
      # fetches the desktop engine artifacts so they can be patched before the first build.
      "$FLUTTER_SUBMODULE/bin/flutter" --version >/dev/null 2>&1
      patch_flutter_submodule
      "$FLUTTER_SUBMODULE/bin/flutter" precache --linux >/dev/null 2>&1
      patch_flutter_submodule
    fi

    if "$FLUTTER_SUBMODULE/bin/flutter" --version >/dev/null 2>&1; then
      echo "Adding flutter submodule to path"
      export PATH="$FLUTTER_SUBMODULE/bin:$PATH"
    fi

    echo "Setting up pre-commit hook"
    (cd "$APP_DIR" && dart run tools/setup_git_hooks.dart)

    flutter config --jdk-dir ${pkgs.jdk21}/lib/openjdk

    echo -e "\nAll done 🎉 \nAvailable aliases:"
  ''+
          pkgs.lib.concatStrings (map (x: ''echo "${x.name}: ${x.description}";'') aliases);

  ####################################################################
  # Without  this, almost  everything  fails with  locale issues  when
  # using `nix-shell --pure` (at least on NixOS).
  # See
  # + https://github.com/NixOS/nix/issues/318#issuecomment-52986702
  # + http://lists.linuxfromscratch.org/pipermail/lfs-support/2004-June/023900.html
  ####################################################################

  LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
}

# vim: set tabstop=2 shiftwidth=2 expandtab:
