
{ pkgs ? import <nixpkgs> {} } :
pkgs.mkShell {
  hardeningDisable = [ "all" ];
  buildInputs = with pkgs; [
    autoconf264
    automake115x
    bison
    binutils
    dejagnu
    expat
    flex
    gcc
    gdb
    gmp
    libmpc
    libxml2
    m4
    mpfr
    python
    python3
    python.pkgs.XlsxWriter
    python.pkgs.pyelftools
    python37.pkgs.GitPython
    python37Packages.requests
    python37Packages.unidiff
    texinfo
  ];
}
