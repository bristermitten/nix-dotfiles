{
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "aw-watcher-utilization";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Alwinator";
    repo = "aw-watcher-utilization";
    rev = "d0d701b589dff0e1653b581b84e050d6b4369745";
    hash = "sha256-8bKMCg6I7+0nOrdOplX4VT417Lti+3PHIn3x8Ik24BU=";
  };

  nativeBuildInputs = [ python3Packages.poetry-core ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["poetry>=0.12"]' 'requires = ["poetry-core"]' \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  dependencies = with python3Packages; [
    psutil
    aw-core
    aw-client
  ];

  doCheck = false;
  pythonRelaxDeps = true;
}
