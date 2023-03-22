{
  description = "Script for automatically running backups";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        defaultPackage =
          with import nixpkgs { system = "${system}"; };
          stdenv.mkDerivation {
            name = "automatic-restic";
            src = self;
            buildInputs = [ restic ];
            installPhase = "mkdir -p $out/bin; install -t $out/bin run_backup.sh";
          };
        apps.automatic-restic = flake-utils.lib.mkApp {
          drv = defaultPackage;
          exePath = "/bin/run_backup.sh";
        };
        defaultApp = apps.automatic-restic;
      }
    );
}
