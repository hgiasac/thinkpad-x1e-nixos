{ config, pkgs, ... }:

{
  environment = {
    systemPackages = [ pkgs.termite ];
  };   

  xdg.configFile."termite/config".text = ''
    [options]
      font = Noto Sans Mono 12
      
      [colors]
      background = rgba(10, 10, 10, 0.70)
    '';

}
