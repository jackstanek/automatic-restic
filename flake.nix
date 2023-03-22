{
  description = "Script for automatically running backups";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        name = "automatic-restic";
        script = (pkgs.writeScriptBin name (builtins.readFile ./run_backup.sh)).overrideAttrs(old: {
            buildCommand = "${old.buildCommand}\n patchShebangs $out";
          });
        postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
        deps = with pkgs; [ restic ];
      in rec {
        defaultPackage = packages."${name}";
        packages."${name}" = pkgs.symlinkJoin {
          inherit name postBuild;
          buildInputs = [ pkgs.makeWrapper ];
          paths = [ script ] ++ deps;
        };
      }
    );
}
