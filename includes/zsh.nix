{ pkgs, ...}: 
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };

    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    interactiveShellInit = ''
      # z - jump around
      source ${pkgs.fetchurl {url = "https://github.com/rupa/z/raw/2ebe419ae18316c5597dd5fb84b5d8595ff1dde9/z.sh"; sha256 = "0ywpgk3ksjq7g30bqbhl9znz3jh6jfg8lxnbdbaiipzgsy41vi10";}}
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      plugins=(git)
      source $ZSH/oh-my-zsh.sh
    '';
    promptInit = "";

    ohMyZsh = {
      enable = true;
      theme = "lambda";
      plugins = [
        "git"
        "mosh"
        "pass"
        "vi-mode"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
      ];
    };
  };

}
