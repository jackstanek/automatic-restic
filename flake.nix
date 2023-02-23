{
 description = "Script for automatically running backups";

 inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
           flake-utils.url = "github:numtide/flake-utils";
           };

 outputs = { self, nixpkgs, flake-utils }:
   flake-utils.lib.simpleFlake {
     inherit self nixpkgs;
     name = "automatic-restic";
   };
 }
