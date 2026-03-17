{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  apple-sdk_15,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "aw-watcher-lastfm";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "0xbrayo";
    repo = "aw-watcher-lastfm";
    rev = "fcda70131c6bbd8b454ebf26bbaf7d6c9e533ab6";
    hash = "sha256-xHrWoUXpqiluZgbHe0c2JX9911v1q8OSLLaohBkAIn8=";
  };

  cargoHash = "sha256-RKqQ9tWybzK7D4ucjOhyLWJbnbdM0cVOTSnQgWvSraE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ apple-sdk_15 ];

  doCheck = false;
}
