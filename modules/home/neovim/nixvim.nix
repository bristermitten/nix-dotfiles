# Neovim configuration managed using https://github.com/nix-community/nixvim
{ pkgs, ... }:
{
  # Theme
  colorschemes.onedark.enable = true;

  # presence.nvim is marked unfree in nixpkgs; nixvim evaluates its own pkgs
  nixpkgs.config.allowUnfree = true;

  vimAlias = true;
  viAlias = true;
  # Settings
  opts = {
    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;
    number = true;
    clipboard = "unnamedplus";
    updatetime = 300; # CursorHold delay, drives the diagnostic hover below
  };

  # Show the diagnostic under the cursor in a float when the cursor rests
  autoCmd = [
    {
      event = "CursorHold";
      callback.__raw = ''
        function()
          vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
        end
      '';
    }
  ];

  # Keymaps
  globals = {
    mapleader = " ";
    # julia-vim: \forall -> ∀ as you type, in every filetype (like the Lean extension).
    # Tab is left to blink-cmp.
    latex_to_unicode_file_types = ".*"; # default is Julia files only
    latex_to_unicode_auto = 1;
    latex_to_unicode_tab = "off";
  };

  extraPlugins = [ pkgs.vimPlugins.julia-vim ];

  plugins = {

    # UI
    web-devicons.enable = true;
    lualine.enable = true;
    bufferline.enable = true;
    treesitter.enable = true;
    presence.enable = true; # Discord rich presence
    toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<C-\\>]]"; # toggle from normal and terminal mode
        direction = "horizontal"; # bottom panel, like VS Code
        size = 15;
        shade_terminals = false;
      };
    };
    which-key = {
      enable = true;
    };
    noice = {
      # WARNING: This is considered experimental feature, but provides nice UX
      enable = true;
      settings.presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;

      };
    };
    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          options.desc = "file finder";
          action = "find_files";
        };
        "<leader>fg" = {
          options.desc = "find via grep";
          action = "live_grep";
        };
      };
      extensions = {
        file-browser.enable = true;
      };
    };

    # Dev
    lsp = {
      enable = true;
      keymaps = {
        silent = true;
        diagnostic = {
          "]d" = "goto_next";
          "[d" = "goto_prev";
          "<leader>e" = "open_float";
        };
        lspBuf = {
          gd = "definition";
          gr = "references";
          gI = "implementation";
          K = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
          "<leader>cf" = "format";
        };
      };
      servers = {
        # Toolchain comes from each project's Nix devShell, so no bundled package
        hls = {
          enable = true;
          package = null;
          installGhc = false;
        };
        rust_analyzer = {
          enable = true;
          package = null;
          installCargo = false;
          installRustc = false;
        };
        nil_ls.enable = true;
      };
    };

    # Completion fed by LSP
    blink-cmp = {
      enable = true;
      settings.keymap = {
        preset = "enter"; # <CR> accepts, <C-space> opens, <C-n>/<C-p> select
        "<Tab>" = [ "snippet_forward" "select_and_accept" "fallback" ];
        "<S-Tab>" = [ "snippet_backward" "fallback" ];
      };
    };
  };
}
