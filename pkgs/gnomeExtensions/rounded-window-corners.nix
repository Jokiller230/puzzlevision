{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  pname = "rounded-window-corners";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "flexagoon";
    repo = pname;
    rev = "61c326e3d6cba36fe3d07cf1c15e6c74d3f9abb1";
    sha256 = "sha256-jS6G9wSKSXAxNhCmuew6pTcYa1gTZqbfrcAZ0ky4vkc=";
  };

  buildInputs = with pkgs; [ nodejs_22 gettext just ];

  installPhase = ''
    runHook preInstall

    just install

    mkdir -p $out/share/gnome-shell/extensions
    cp ~/.local/share/gnome-shell/extensions/rounded-window-corners@fxgn $out/share/gnome-shell/extensions/rounded-window-corners@fxgn

    runHook postInstall
  '';
}