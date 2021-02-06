{
  description = "suckless git overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    dmenu = { url = "git://git.suckless.org/dmenu"; flake = false; };
    dwm = { url = "git://git.suckless.org/dwm"; flake = false; };
    st = { url = "git://git.suckless.org/st"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    {
      overlay = final: prev:
        let
          pkgs = nixpkgs.legacyPackages.${prev.system};
          inherit (pkgs) lib;
          getSrcDate = src: builtins.substring 0 8 src.lastModifiedDate;

          overrideSuckless = name: pkg: src: pkg.overrideAttrs (old:
            let inherit (old) meta; in {
              pname = name + "-git";
              version = getSrcDate src;
              inherit src;
              meta = with lib; meta // {
                description = meta.description + " - development version";
                maintainers = meta.maintainers ++ [ maintainers.jk ];
              };
            }
          );
          overrideSucklessPkg = name: overrideSuckless name pkgs.${name} inputs.${name} ;
        in
        {
          dmenu-git = overrideSucklessPkg "dmenu";
          dwm-git = overrideSucklessPkg "dwm";
          st-git = overrideSucklessPkg "st";
        };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (flake-utils.lib) mkApp;
        pkgs = import nixpkgs { overlays = [ self.overlay ]; inherit system; };
      in
      rec {
        packages = with pkgs; { inherit dmenu-git dwm-git st-git; };

        apps = with pkgs; {
          dmenu-git = mkApp { drv = dmenu-git; name = "dmenu"; };
          dwm-git = mkApp { drv = dwm-git; name = "dwm"; };
          st-git = mkApp { drv = st-git; name = "st"; };
        };
      }
    );
}
