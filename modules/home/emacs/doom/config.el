;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one
      display-line-numbers-type t
      org-directory "~/org/")

;; Lean toolchain (lean, lake) is managed by elan. The launchd daemon has a
;; minimal PATH, so make it visible to Emacs and subprocesses explicitly.
(let ((elan-bin (expand-file-name "~/.elan/bin")))
  (add-to-list 'exec-path elan-bin)
  (setenv "PATH" (concat elan-bin ":" (getenv "PATH"))))

;; Lean buffers (nael) already expand \forall -> ∀ via abbrevs. For other modes the
;; TeX input method does it, but it also rewrites `--', `_x' and `^x', which breaks
;; code, so it is NOT enabled by default: toggle it with `C-\' when you want it.

;; Compile popup: `SPC c c` runs `compile`, output in a bottom panel.
(set-popup-rule! "^\\*compilation\\*" :side 'bottom :size 0.3 :select nil :quit t)
(setq compilation-scroll-output 'first-error)

;; Direnv: pick up each project's devShell (hls, cargo, ...) for LSP/compile.
;; The +eglot LSP client starts after envrc has set exec-path.
(after! envrc (setq envrc-show-summary-in-minibuffer nil))

;; LSP fallback: use the project devShell (via envrc) if it provides the server,
;; otherwise `lsp-nix' runs it from the dotfiles flake's per-language shell.
(after! eglot
  (add-to-list 'eglot-server-programs
               '((haskell-mode haskell-ts-mode haskell-literate-mode)
                 "lsp-nix" "haskell" "haskell-language-server-wrapper" "--lsp"))
  (add-to-list 'eglot-server-programs
               '((rust-mode rust-ts-mode) "lsp-nix" "rust" "rust-analyzer")))

;; Discord rich presence
(use-package! elcord
  :commands elcord-mode
  :init (add-hook 'doom-first-buffer-hook #'elcord-mode)
  :config (setq elcord-idle-message "Away from Emacs"
                elcord-display-buffer-details nil))

;; Right-click context menu (Copy/Cut/Paste, LSP actions, ...) like nvim's.
;; Cmd-C/V/X/A are already bound by Doom's default module and sync with the
;; system clipboard.
(context-menu-mode 1)

;; In vterm, plain `yank' pastes into the Emacs buffer, not the shell.
(map! :after vterm :map vterm-mode-map "s-v" #'vterm-yank)
