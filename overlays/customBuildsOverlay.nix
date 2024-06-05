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

      smart-open-nvim = super.vimUtils.buildVimPlugin {
        pname = "smart-open.nvim";
        version = "2024-04-14";
        src = super.fetchFromGitHub {
          owner = "danielfalk";
          repo = "smart-open.nvim";
          rev = "0.2.x";
          sha256 = "ro4qFdEAnE5u8wt7NyIc7OHobvjRotVX+LZ0P5as8EU=";
        };
      };

      inlay-hints-nvim = super.vimUtils.buildVimPlugin {
        pname = "inlay-hints.nvim";
        version = "2024-05-28";
        src = super.fetchFromGitHub {
          owner = "MysticalDevil";
          repo = "inlay-hints.nvim";
          rev = "5526103e4b80c66234e60c8d92dad967d0e1bcd7";
          sha256 = "x5dTTEib5JsgxkHxMSU1bYyoifZ1x3nn97W4bnAF5r4=";
        };
      };
    };
  };
in
  overlay
