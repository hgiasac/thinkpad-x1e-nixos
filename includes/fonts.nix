{ pkgs, ... }:
{
  
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
    powerline-fonts
  ];
 
  fonts.fontconfig = {
    dpi = 240;
    # penultimate.enable = false;
    defaultFonts = {
      monospace = [ "Noto Sans Mono Regular" ];        
      sansSerif = [ "Noto Sans Display Regular" ];
      serif     = [ "Noto Serif Regular" ];
    };
  };
 
   
}
