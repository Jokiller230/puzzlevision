{config, ...}: {
  sops = {
    age.keyFile = "/home/${config.home.username}/sops-nix/key.txt";
  };
}
