importName: inputs: let
  overlay = self: super: {
    ${importName} = {
      vim-schlepp = super.vimUtils.buildVimPlugin {
        name = "vim-schlepp";
        src = super.fetchFromGitHub {
          owner = "zirrostig";
          repo = "vim-schlepp";
          rev = "master";
          sha256 = "NNoHvLNIIjZLNHsI3jrhbsHmSO0eOldP0s7nMBMJoXE=";
        };
      };
    };
  };
in
  overlay
