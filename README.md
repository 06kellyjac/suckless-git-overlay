# Suckless Git Overlay

Provides git variants of suckless tools up to date with master.

There is CI to automatically update the overlay.

## Packages provided

- `dmenu-git`
- `dwm-git`
- `st-git`

To see what git revision or the epoch of the revision's creation you can check the [flake.lock](./flake.lock) file.

## To Use

Add the overlay to your home.nix (home-manager) or configuration.nix (NixOS):

```nix
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/06kellyjac/suckless-git-overlay/archive/master.tar.gz;
    }))
  ];
}
```

```nix
{
  pkgs ? import <nixpkgs> {
    overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/06kellyjac/suckless-git-overlay/archive/master.tar.gz;
      }))
    ];
  }
}:
{}
```

If you are using flakes to configure your system, add to your nixpkgs overlays attribute (examples will differ, the following is for home-manager):

```nix
{
  inputs.suckless-git-overlay.url = "github:06kellyjac/suckless-git-overlay";
  outputs = { self, ... }@inputs:
    let
      overlays = [ inputs.suckless-git-overlay.overlay ];
    in
      homeConfigurations = {
        macbook-pro = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }:
            {
              nixpkgs.overlays = overlays;
            };
        };
      };
}
```

Install a package:

```sh
nix-env -iA pkgs.<PACKAGE_NAME>
```

or add to home-manager/configuration.nix.

## See Also

Based on https://github.com/nix-community/neovim-nightly-overlay
