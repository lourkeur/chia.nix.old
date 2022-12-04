{
  lib,
  fetchFromGitHub,
  python3Packages,
  chia,
}:
python3Packages.buildPythonApplication rec {
  pname = "chia-dev-tools";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fZbb+FTs/Sn/n690NeYQaccRs/U7IeL855XvAV+o97M=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="
  '';

  nativeBuildInputs = [
    python3Packages.setuptools-scm
  ];

  # give a hint to setuptools-scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = with python3Packages; [
    (toPythonModule chia)
    pytest
    pytest-asyncio
    pytimeparse
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_spendbundles"
  ];

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "A utility for developing in the Chia ecosystem: Chialisp functions, object inspection, RPC client and more";
    license = with licenses; [asl20];
    maintainers = teams.chia.members;
    platforms = platforms.all;
  };
}
