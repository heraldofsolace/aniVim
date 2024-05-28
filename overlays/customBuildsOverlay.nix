importName: inputs: let
  overlay = self: super: {
    ${importName} = {
      vim-schlepp = super.vimUtils.buildVimPlugin {
        pname = "vim-schlepp";
        version = "2018-05-04";
        src = super.fetchFromGitHub {
          owner = "zirrostig";
          repo = "vim-schlepp";
          rev = "master";
          sha256 = "NNoHvLNIIjZLNHsI3jrhbsHmSO0eOldP0s7nMBMJoXE=";
        };
      };

      guihua-lua = super.vimUtils.buildVimPlugin {
        pname = "guihua.lua";
        version = "2024-05-28";
        src = super.fetchFromGitHub {
          owner = "ray-x";
          repo = "guihua.lua";
          rev = "a53b76514ad42d92a821d75d712ef71e71898fcf";
          sha256 = "/yWYsgD/MIzcXIlGr5IncoI4uzf627ufyhjhJUq/+9I=";
        };
        buildPhase = ''
          cd lua/fzy && make
          cd ../..
        '';
      };

      navigator-lua = super.vimUtils.buildVimPlugin {
        pname = "navigator.lua";
        version = "2024-05-25";
        src = super.fetchFromGitHub {
          owner = "ray-x";
          repo = "navigator.lua";
          rev = "877a45747332085ba469f27f5f643ffc4840bb45";
          sha256 = "TP1Fmu6LJFioPskUMWBG+rUNcaxejSF3Fqr5nT6htAY=";
        };
      };
    };
  };
in
  overlay
