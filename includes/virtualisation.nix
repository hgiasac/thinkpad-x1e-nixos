{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    kubectl
  ];
  
  # environment.variables = {
  #   "KUBECONFIG" = "/etc/kubernetes/cluster-admin.kubeconfig";
  # };

  # enable kubernetes
  # services.kubernetes = {
  #   roles = ["master" "node"];
  #   masterAddress = "localhost";
    # easyCerts = true;
  #   kubelet = { 
  #     extraOpts = "--fail-swap-on=false";
  #   };

  # };

  virtualisation.libvirtd.enable = true;

 # docker setting 
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    # extraOptions = "--insecure-registry ${config.networking.hostName}.local:80";
  };
}
