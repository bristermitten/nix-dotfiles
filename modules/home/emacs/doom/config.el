;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one
      display-line-numbers-type t
      org-directory "~/org/")

;; Lean toolchain (lean, lake) is managed by elan. The launchd daemon has a
;; minimal PATH, so make it visible to Emacs and subprocesses explicitly.
(let ((elan-bin (expand-file-name "~/.elan/bin")))
  (add-to-list 'exec-path elan-bin)
  (setenv "PATH" (concat elan-bin ":" (getenv "PATH"))))

;; Type \forall and get ∀, like the Lean VS Code extension and julia-vim in nvim.
;; nael (Lean 4) ships its own abbrevs; the TeX input method covers Haskell etc.
(add-hook! 'haskell-mode-hook #'(lambda () (set-input-method "TeX")))
(add-hook! 'haskell-ts-mode-hook #'(lambda () (set-input-method "TeX")))

;; Compile popup: `SPC c c` runs `compile`, output in a bottom panel.
(set-popup-rule! "^\\*compilation\\*" :side 'bottom :size 0.3 :select nil :quit t)
(setq compilation-scroll-output 'first-error)

;; Direnv: pick up each project's devShell (hls, cargo, ...) for LSP/compile.
;; The +eglot LSP client starts after envrc has set exec-path.
(after! envrc (setq envrc-show-summary-in-minibuffer nil))
