# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example repository https://github.com/BirdeeHub/nixCats-nvim
# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.
# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.
{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    # LAZY WRAPPER ONLY WORKS ON UNSTABLE
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    nixCats.url = "github:heraldofsolace/nixCats-nvim";
    nixCats.inputs.nixpkgs.follows = "nixpkgs";
    nixCats.inputs.flake-utils.follows = "flake-utils";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
  };

  # see :help nixCats.flake.outputs
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    devshell,
    nixCats,
    neorg-overlay,
    ...
  } @ inputs: let
    utils = nixCats.utils;
    luaPath = "${./.}";
    forEachSystem = flake-utils.lib.eachSystem flake-utils.lib.allSystems;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      # allowUnfree = true;
    };
    # sometimes our overlays require a ${system} to access the overlay.
    # management of this variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.

    # First, we will define just our overlays per system.
    # later we will pass them into the builder, and the resulting pkgs set
    # will get passed to the categoryDefinitions and packageDefinitions
    # which follow this section.

    # this allows you to use pkgs.${system} whenever you want in those sections
    # without fear.
    system_resolved = forEachSystem (system: let
      # see :help nixCats.flake.outputs.overlays
      standardPluginOverlay = utils.standardPluginOverlay;

      # you may define more overlays in the overlays directory, and import them
      # in the default.nix file in that directory.
      # see overlays/default.nix for how to add more overlays in that directory.
      # or see :help nixCats.flake.nixperts.overlays
      dependencyOverlays = [
        (utils.mergeOverlayLists nixCats.dependencyOverlays.${system}
          ((import ./overlays inputs)
            ++ [
              (standardPluginOverlay inputs)
              # add any flake overlays here.
              neorg-overlay.overlays.default
            ]))
      ];
      # these overlays will be wrapped with ${system}
      # and we will call the same flake-utils function
      # later on to access them.
    in {inherit dependencyOverlays;});
    inherit (system_resolved) dependencyOverlays;
    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      name,
      ...
    } @ packageDef: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # propagatedBuildInputs:
      # this section is for dependencies that should be available
      # at BUILD TIME for plugins. WILL NOT be available to PATH
      # However, they WILL be available to the shell
      # and neovim path when using nix develop
      propagatedBuildInputs = {
        generalBuildInputs = with pkgs; [
        ];
      };

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags
          ripgrep
          fd
          gcc
          gopls
          pyright
          rust-analyzer
          nodePackages.typescript-language-server
          lua51Packages.lua-lsp
          clang
          clang-tools
        ];

        nix-dev = with pkgs; [
          nix-doc
          nil
          nixd
        ];

        lint = with pkgs; [
          nodePackages.eslint
        ];
        debug = with pkgs; [
          gdb
        ];
        format = with pkgs; [
          treefmt
          alejandra
          nodePackages.prettier
        ];

        org = with pkgs.lua51Packages; [
          lua
          luarocks
          plenary-nvim
          pathlib-nvim
          nui-nvim
          nvim-nio
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        lazy = with pkgs.vimPlugins; [
          lazy-nvim
        ];

        lint = with pkgs.vimPlugins; [
          nvim-lint
        ];

        general = {
          gitPlugins = with pkgs.neovimPlugins; [
            hlargs
          ];

          org = with pkgs.vimPlugins; [
            vimwiki
            neorg
            neorg-telescope
            vim-wakatime
          ];
          dev = {
            ruby = with pkgs.vimPlugins; [
              vim-rails
            ];
            nix-dev = with pkgs.vimPlugins; [
              neodev-nvim
              neoconf-nvim
            ];
          };
          general = with pkgs.vimPlugins; [
            fidget-nvim
            lualine-nvim
            gitsigns-nvim
            which-key-nvim
            comment-nvim
            vim-sleuth
            vim-fugitive
            vim-rhubarb
            vim-repeat
            vim-dadbod
            vim-dadbod-ui
            vim-eunuch
            vim-projectionist
            vim-speeddating
            indent-blankline-nvim
            wildfire-vim
            editorconfig-nvim
            lush-nvim
            vim-tmux-navigator
            alpha-nvim
            twilight-nvim
            direnv-vim
            vim-peekaboo
            kommentary
            sqlite-lua
            legendary-nvim
            bufferline-nvim
            auto-save-nvim
            dressing-nvim
            hardtime-nvim
            oil-nvim
            noice-nvim
            nvim-notify
            nui-nvim
            pkgs.nixCatsBuilds.vim-schlepp
          ];
        };
        # You can retreive information from the
        # packageDefinitions of the package this was packaged with.
        # :help nixCats.flake.outputs.categoryDefinitions.scheme
        themer = with pkgs.vimPlugins; (
          builtins.getAttr packageDef.categories.colorscheme {
            # Theme switcher without creating a new category
            "onedark" = onedark-nvim;
            # "catppuccin" = catppuccin-nvim;
            "tokyonight" = tokyonight-nvim;
          }
        );
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        custom = with pkgs.nixCatsBuilds; [];
        format = with pkgs.vimPlugins; [
          conform-nvim
        ];
        debug = with pkgs.vimPlugins; [
          pkgs.neovimPlugins.nvim-nio
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
        ];
        treesitter = with pkgs.vimPlugins; [
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
        ];
        telescope = with pkgs.vimPlugins; [
          telescope-frecency-nvim
          plenary-nvim
          telescope-nvim
          telescope-fzf-native-nvim
          pkgs.nixCatsBuilds.smart-open-nvim
        ];

        cmp = with pkgs.vimPlugins; [
          coq_nvim
          coq-artifacts
          coq-thirdparty
          nvim-lspconfig
          dropbar-nvim
          pkgs.nixCatsBuilds.guihua-lua
          pkgs.nixCatsBuilds.navigator-lua
          pkgs.nixCatsBuilds.inlay-hints-nvim
        ];
        gitPlugins = with pkgs.vimPlugins; [
          lazygit-nvim
        ];
        markdown = with pkgs.vimPlugins; [
          glow-nvim
        ];
        general = with pkgs.vimPlugins; [
          zen-mode-nvim
          nvim-web-devicons
          todo-comments-nvim
          vimtex
          chadtree
          trouble-nvim
          flash-nvim
        ];
        org = with pkgs.vimPlugins; [
        ];
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          libgit2
          gcc
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          subtest1 = {
            CATTESTVAR = "It worked!";
          };
          subtest2 = {
            CATTESTVAR3 = "It didn't work!";
          };
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages
      extraPython3Packages = {
        test = _: [];
      };
      extraLuaPackages = {
        # org = luaPkg: with luaPkg; [
        #   lua-utils-nvim nvim-nio pathlib-nvim nui-nvim plenary-nvim
        # ];
      };
    };

    # packageDefinitions:

    # Now build a package with specific categories from above
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.
    # It is directly translated to a Lua table, and a get function is defined.
    # The get function is to prevent errors when querying subcategories.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # these also recieve our pkgs variable
      aniVim = {pkgs, ...} @ misc: {
        # see :help nixCats.flake.outputs.settings
        settings = {
          # will check for config in the store rather than .config
          wrapRc = true;
          configDirName = "aniVim";
          aliases = ["neovim"];
          viAlias = true;
          vimAlias = true;
          withNodeJs = true;
          disablePythonSafePath = true;
        };
        # see :help nixCats.flake.outputs.packageDefinitions
        categories = {
          lazy = true;
          generalBuildInputs = true;
          debug = true;
          lint = true;
          format = true;
          general = true;
          gitPlugins = true;
          telescope = true;
          treesitter = true;
          org = true;
          dev = true;
          cmp = true;
          markdown = true;
          # this does not have an associated category of plugins,
          # but lua can still check for it
          lspDebugMode = false;
          # you could also pass something else:
          themer = true;
          colorscheme = "tokyonight";
        };
      };
    };
    # In this section, the main thing you will need to do is change the default package name
    # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "aniVim";
  in
    # see :help nixCats.flake.outputs.exports
    forEachSystem (system: let
      inherit (utils) baseBuilder;
      customPackager =
        baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions;
      nixCatsBuilder = customPackager packageDefinitions;
      # this is just for using utils such as pkgs.mkShell
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
      pkgs = import nixpkgs {
        inherit system;

        overlays = [devshell.overlays.default];
      };
    in {
      # these outputs will be wrapped with ${system} by flake-utils.lib.eachDefaultSystem

      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one named here.
      packages = utils.mkPackages nixCatsBuilder packageDefinitions defaultPackageName;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.devshell.mkShell {
          imports = [(pkgs.devshell.importTOML ./devshell.toml)];
          name = defaultPackageName;
          packages = [(nixCatsBuilder defaultPackageName)];
        };
      };

      # To choose settings and categories from the flake that calls this flake.
      # and you export overlays so people dont have to redefine stuff.
      inherit customPackager;
    })
    // {
      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
      overlays =
        utils.makeOverlays luaPath {
          # we pass in the things to make a pkgs variable to build nvim with later
          inherit nixpkgs dependencyOverlays extra_pkg_config;
          # and also our categoryDefinitions
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      # we also export a nixos module to allow configuration from configuration.nix
      nixosModules.default = utils.mkNixosModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          nixpkgs
          ;
      };
      # and the same for home manager
      homeModule = utils.mkHomeModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          nixpkgs
          ;
      };
      # now we can export some things that can be imported in other
      # flakes, WITHOUT needing to use a system variable to do it.
      # and update them into the rest of the outputs returned by the
      # eachDefaultSystem function.
      inherit utils categoryDefinitions packageDefinitions dependencyOverlays;
      inherit (utils) templates baseBuilder;
      keepLuaBuilder = utils.baseBuilder luaPath;
    };
}
