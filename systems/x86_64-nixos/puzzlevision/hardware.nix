{
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  # Some boot settings for intel CPU's
  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelModules = [
      "kvm-intel"
      "8821ce"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      rtl8821ce # Install community maintained network driver
    ];

    blacklistedKernelModules = [
      "rtw88_8821ce" # Block the default network-card driver.
    ];

    # Increase swappiness, if ZRAM swap is enabled,
    # as it doesn't come with the same "speed" caveats as standard swap.
    kernel.sysctl = mkIf config.zramSwap.enable {
      "vm.swappiness" = 50;
    };

    # Apply a few kernel parameters to combat system freezes
    kernelParams = [
      "intel_idle.max_cstate=1" # avoids deep C-state freezes
      "processor.max_cstate=1" # same effect, some kernels honor one better than the other
      "usbcore.autosuspend=-1"
    ];
  };

  # Broader firmware and hardware support
  hardware = {
    enableAllFirmware = true;
    enableAllHardware = true;
  };

  # Enable ZRAM
  zramSwap = {
    enable = true;
    priority = 0;
  };

  services = {
    # Enable TLP for power management profiles on AC and Battery
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";

        CPU_MIN_PERF_ON_AC = 70;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 20;
        CPU_MAX_PERF_ON_BAT = 50;

        USB_AUTOSUSPEND = 0;
      };
    };

    # Disable power-profiles-daemon in favor of TLP :3
    power-profiles-daemon.enable = false;

    # Kill processes before they can cause an OOM exception
    earlyoom.enable = true;
  };
}
