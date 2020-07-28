{ pkgs ? import <nixpkgs> {} } :

with pkgs;
let
outputcheck = python2Packages.buildPythonApplication rec {
  pname = "outputcheck";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "OutputCheck";
    rev = "e0f533d3c5af2949349856c711bf4bca50022b48";
    sha256 = "1y27vz6jq6sywas07kz3v01sqjd0sga9yv9w2cksqac3v7wmf2a0";
  };
  prePatch = "echo ${version} > RELEASE-VERSION";

  meta = with stdenv.lib; {
    description = "A tool for checking tool output inspired by LLVM's FileCheck";
    homepage    = "https://github.com/stp/OutputCheck";
    license     = licenses.bsd3;
  };
};
in
pkgs.mkShell {
  hardeningDisable = [ "all" ];
  buildInputs = [
    binutils
    gcc
    gdb
    glibc.static
    lit
    m4
    outputcheck
  ];
}