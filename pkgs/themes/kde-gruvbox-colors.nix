{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kde-gruvbox-colors";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jokiller230";
    repo = pname;
    rev = "438a23c571e22c1bf416c229afac78ad64e81f17";
    sha256 = "sha256-5iRfWqqtv+ImDN96PuWaS3nuK8AHjfa4DGc8vCkLi4U=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -R color-schemes konsole $out/share

    runHook postInstall
  '';
}