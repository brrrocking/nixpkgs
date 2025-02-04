{ lib, stdenv, fetchFromGitHub, autoconf, automake, sqlite, pkg-config, dovecot, libtool, xapian, icu64 }:
stdenv.mkDerivation rec {
  pname = "dovecot-fts-xapian";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = version;
    sha256 = "sha256-UAH6IF6iEzzXY2Zl/1aeRnFwb73K5Fgp0WWEgo7ZdFM=";
  };

  buildInputs = [ dovecot xapian icu64 sqlite ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  preConfigure = ''
    export PANDOC=false
    autoreconf -vi
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  meta = with lib; {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    changelog = "https://github.com/grosjo/fts-xapian/releases";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ julm symphorien ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/dovecot_fts_xapian.x86_64-darwin
  };
}
