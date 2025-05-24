{ pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
    config.allowBroken = true;
  }
, ci ? false}:

let
 aliases = [ ];


in
pkgs.mkShell {
  buildInputs = with pkgs; builtins.concatLists [
    [ corretto21 maven gnumake ]
  ];

  # to run CI or DB migrations
  shellHook =  ''
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
