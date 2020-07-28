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
    python.pkgs.XlsxWriter
    python.pkgs.pyelftools
    texinfo
  ];
}