{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    kubectl
  ];

  # enable kubernetes
  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = "localhost";
    easyCerts = true;
    kubelet = { 
      extraOpts = "--fail-swap-on=false";
    };

  };

 # docker seting 
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    extraOptions = "--insecure-registry ${config.networking.hostName}.local:80";
  };
}
