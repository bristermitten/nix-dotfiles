{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  apple-sdk_15,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "aw-watcher-enhanced";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kepptic";
    repo = "aw-watcher-enhanced";
    rev = "715361f260af03a03467db73553dc819dfbe7e9f";
    hash = "sha256-oPjJCmAYwXCUVywJxRwZ3kuZV1KqXokMQS8vXVuy55c=";
  };

  sourceRoot = "source/rust-watcher";

  cargoHash = "sha256-eEzAHBiohaKpNOdDEkLM17jmKRnxERP8Ig1RYddtzuc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ apple-sdk_15 ];

  doCheck = false;
}
