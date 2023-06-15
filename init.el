;; Packages ====================================================================
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
	     '("gnu"   . "https://elpa.gnu.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
	use-package-expand-minimally t))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Themes
(use-package horizon-theme)
(use-package zenburn-theme)
(use-package doom-themes)
(use-package alect-themes)
;; Evil stuff
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-insert-state-cursor '()))
(use-package evil-commentary)
(use-package evil-mc)
(use-package evil-mc-extras)
(use-package key-chord
  :init
  (setq key-chord-two-keys-delay 0.5))
(use-package general)
(use-package which-key)
;; Ido smex etc.
(use-package ido-completing-read+)
(use-package ido-hacks)
(use-package ido-yes-or-no)
(use-package amx)
(use-package fzf)
;; Completion
(use-package company)
(use-package lsp-mode
  :hook (
	 (c++-mode . lsp-deferred)
	 (c-mode . lsp-deferred)
	 (rust-mode . lsp-deferred)
	 (typescript-mode . lsp-deferred)
	 (python-mode . lsp-deferred)))
(use-package lsp-ui)
(use-package flycheck)
;; Git
(use-package magit)
;; Languages
(use-package rust-mode)
(use-package jupyter)
;; =============================================================================

;; General Settings ============================================================
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes") ;; Load theme path
(load-theme 'gruber-darker t) ;; Theme
(setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)
;; (setq user-font "jetbrainsmono nerd font 20")
(setq user-font "iosevka 20")
(set-frame-font user-font nil t) ;; Font
;; (set-face-attribute 'default nil :weight 'bold)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(setq ring-bell-function 'ignore)
(setq-default c-basic-offset 4) ; indents 4 chars
(setq-default tab-width 4) ; and 4 char wide for TAB
(setq-default indent-tabs-mode nil) ; And force use of spaces
(global-display-fill-column-indicator-mode) ;; Fill Column
(setq-default fill-column 80)
(global-display-line-numbers-mode)
(setq-default display-line-numbers 'relative)
(setq display-line-numbers-type 'relative)
(setq inhibit-startup-screen t)
(setq initial-scratch-message ";; EMACS")
(add-hook 'window-setup-hook 'toggle-frame-maximized t) ;; Start maximized
(setq magit-auto-revert-mode nil)
;; =============================================================================

;; Modes =======================================================================
(electric-pair-mode) ; Delimiter pairs
(turn-on-font-lock) ; same as syntax on in Vim

;; Ido
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
(ido-ubiquitous-mode 1)
(ido-yes-or-no-mode 1)
(ido-hacks-mode 1)
(setq ido-max-window-height 1)
(setq ido-create-new-buffer 'always)
(define-key ido-common-completion-map (kbd "TAB") 'ido-next-match)
(define-key ido-common-completion-map (kbd "<backtab>") 'ido-prev-match)

;; Evil 
(define-key evil-normal-state-map (kbd "C-r") 'undo-redo)
(evil-mode 1)

;; Which-key
(which-key-mode)

;; Evil commentary
(evil-commentary-mode)
(global-evil-mc-mode)

;; Amx
(amx-initialize)

;; Lsp-ui
(lsp-ui-mode)
(setq lsp-headerline-breadcrumb-enable nil)
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/Users/nukem/Library/Python/3.10/bin")

;; Company
(add-hook 'after-init-hook 'global-company-mode)

;; Beacon
(beacon-mode)

;; =============================================================================

;; Keybinds ====================================================================
;; Font size manip
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-mode)

;; Leader bindings
(general-evil-setup)
(setq general-override-mode-map (make-sparse-keymap))
(general-create-definer leader-def :prefix "SPC")

;; Spacemacs config file binding
(defun config-file ()
  "Open the init file."
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(leader-def 'normal "fed" 'config-file)

;; Jk for evil esc
(general-imap "j"
  (general-key-dispatch 'self-insert-command
    :timeout 0.25
    "k" 'evil-normal-state))

;; File nav
(leader-def 'normal "ff" 'ido-find-file)
(leader-def 'normal "fb" 'ido-switch-buffer)
(leader-def 'normal "fz" 'fzf-find-file)
(leader-def 'normal "fg" 'fzf-grep)

;; Magit
(leader-def 'normal "ms" 'magit-status)
(leader-def 'normal "ml" 'magit-log)
(leader-def 'normal "mC" 'magit-commit)
(leader-def 'normal "mc" 'magit-checkout)

;; Compilation
(leader-def 'normal "cc" 'project-compile)

;; Dired
(leader-def 'normal "dd" 'dired)

;; Switch to last buffer
(defun switch-last-buffer ()
  "Toggle between last 2 buffers"
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(leader-def 'normal "l" 'next-buffer)
(leader-def 'normal "h" 'previous-buffer)
(leader-def 'normal "<tab>" 'switch-last-buffer)

;; Amx
(global-set-key (kbd "M-x") 'amx)
(global-set-key (kbd "M-X") 'amx-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; MC
(global-set-key (kbd "C-;")    'evil-mc-make-all-cursors)
(global-set-key (kbd "C-<")    'evil-mc-find-prev-cursor)
(global-set-key (kbd "C->")    'evil-mc-find-next-cursor)


(setq mac-command-modifier 'meta) ;; Mac cmd M-x
(setq mac-allow-anti-aliasing t)
(setq ns-auto-hide-menu-bar t)
(setq default-frame-alist '((undecorated . t))) 

;; Lsp
(define-key evil-normal-state-map (kbd "K") 'lsp-describe-thing-at-point)

;; Company
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "<tab>") #'company-select-next)
  (define-key company-active-map (kbd "<S-tab>") #'company-select-previous))
;; =============================================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("49cd634a5d2e294c281348ce933d2f17c19531998a262cbdbe763ef2fb41846b" "45b84ddcc65bdf01d9cc76061a9473e3291d82c9209eac0694fbbb81c57b92fd" "5e5771e6ea0c9500aa87e987ace1d9f401585e22a976777b6090a1554f3771c6" "dbade2e946597b9cda3e61978b5fcc14fa3afa2d3c4391d477bdaeff8f5638c5" "801a567c87755fe65d0484cb2bded31a4c5bb24fd1fe0ed11e6c02254017acb2" "1ebdc6eee73f94084f1a7211d6e462c29a6fc902ceb38c450eadba0e984da193" "ce784eb8135893a19e5553ed94cc694320b05228ce712a64b2fb69c0c54161b9" "e9d47d6d41e42a8313c81995a60b2af6588e9f01a1cf19ca42669a7ffd5c2fde" "f8f2ae09e73f172576c29006cfabee7fbd7b629e13e1a45fa35934c71396ca55" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "944d52450c57b7cbba08f9b3d08095eb7a5541b0ecfb3a0a9ecd4a18f3c28948" "251ed7ecd97af314cd77b07359a09da12dcd97be35e3ab761d4a92d8d8cf9a71" "8d8207a39e18e2cc95ebddf62f841442d36fcba01a2a9451773d4ed30b632443" "443e2c3c4dd44510f0ea8247b438e834188dc1c6fb80785d83ad3628eadf9294" "f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" "285323ee319ff52fb6cf3a3474345bfe25c58a6157a07b484e06d9d3316f81cf" "9c6bc2872127f307728098e69c5538aa8b5964816f0775267a6282675baed9d1" "457d1653fac8aed803a9b0b4a1772bb621eeb38fe50babce3890975ecfa342d2" "2dd4951e967990396142ec54d376cced3f135810b2b69920e77103e0bcedfba9" "4dcf06273c9f5f0e01cea95e5f71c3b6ee506f192d75ffda639d737964e2e14e" "d445c7b530713eac282ecdeea07a8fa59692c83045bf84dd112dd738c7bcad1d" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "7356632cebc6a11a87bc5fcffaa49bae528026a78637acd03cae57c091afd9b9" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "987b709680284a5858d5fe7e4e428463a20dfabe0a6f2a6146b3b8c7c529f08b" "c48551a5fb7b9fc019bf3f61ebf14cf7c9cdca79bcb2a4219195371c02268f11" "7710cb6c03c7a7ce333dcdf93eb00b5285f36f89df20e8c3e56c7d4f17f701d9" "e0d42a58c84161a0744ceab595370cbe290949968ab62273aed6212df0ea94b4" "3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "3cc2385c39257fed66238921602d8104d8fd6266ad88a006d0a4325336f5ee02" "dfdad17fb5c142b5a37b9c09bd42a06233c4e2ee3f361863f1e6fd181e43306d" "ec0a8caf37e3df9c0911ee8e83068dde5808270687751de995c17609150bf342" "da2f0fa47b07c64108022918f9fd3dc1e744cd4b3c266d67d5d858e9f6fb8be7" "7887cf8b470098657395502e16809523b629249060d61607c2225d2ef2ad59f5" "96a4406cca483476d3ce524052bcdd69889a2109c5c3e60be0c8951534d1e0e1" "8b930a6af47e826c12be96de5c28f1d142dccab1927f196589dafffad0fc9652" "8f663b8939be3b54d70a4c963d5d0f1cfd278f447cb4257df6c4571fb8c71bca" "d7b64d02c7a0aca3906ab7338d73b5d5b69b05dfc22bbc041956a2a26481a5fa" "1752a799b84cf9897f7c97bb16a139d77cf76b008209d246a35793c23f58dff4" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" "5e3fc08bcadce4c6785fc49be686a4a82a356db569f55d411258984e952f194a" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "0c83e0b50946e39e237769ad368a08f2cd1c854ccbcd1a01d39fdce4d6f86478" "24168c7e083ca0bbc87c68d3139ef39f072488703dcdd82343b8cab71c0f62a7" "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7" "46b2d7d5ab1ee639f81bde99fcd69eb6b53c09f7e54051a591288650c29135b0" "5d59bd44c5a875566348fa44ee01c98c1d72369dc531c1c5458b0864841f887c" "78e6be576f4a526d212d5f9a8798e5706990216e9be10174e3f3b015b8662e27" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "de6591bddc8aa5c9758f9d4e3f67c2b78a7eeafdc2d03112b8c07fc934302b2f" "a8f160f9ba59231fa57563440d39d5a398644cdbb73f7254fb2f9c53014fa7aa" "e2095cd2350502ac3dc68350f0a27485f1edb99b6fc40a782618e1d35bf9d079" "e6a7b628460ea9c569228b3368fe0a8d11c615eeb4a0dccd253dbf548e63a835" "72422a99ddf421fc8d705332fd565c90405e73c2ec7ca10427792238ec2ff902" "f74e8d46790f3e07fbb4a2c5dafe2ade0d8f5abc9c203cd1c29c7d5110a85230" "4ff1c4d05adad3de88da16bd2e857f8374f26f9063b2d77d38d14686e3868d8d" "2078837f21ac3b0cc84167306fa1058e3199bbd12b6d5b56e3777a4125ff6851" "ba9c91bc43996f2fa710e4b5145d9de231150103e142acdcf24adcaaf0db7a17" "8a332a2fbbd95db0e0ad05c6cb9a42800d4dab92af960cafbe3c553357e1f3c6" "36ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" "f79733dc64e06aeb5370a80bc93391d9ec0300f9be684a4940b63ba77a35931a" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "afa47084cb0beb684281f480aa84dab7c9170b084423c7f87ba755b15f6776ef" "9b4ae6aa7581d529e20e5e503208316c5ef4c7005be49fdb06e5d07160b67adc" "60ada0ff6b91687f1a04cc17ad04119e59a7542644c7c59fc135909499400ab8" "631c52620e2953e744f2b56d102eae503017047fb43d65ce028e88ef5846ea3b" "02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" "171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b" "957a573d5c7cb49c2f033b9d5a6f77445c782307e2d7ffca0d9b5b8141c49843" "72a81c54c97b9e5efcc3ea214382615649ebb539cb4f2fe3a46cd12af72c7607" "ba4ab079778624e2eadbdc5d9345e6ada531dc3febeb24d257e6d31d5ed02577" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e"))
 '(package-selected-packages
   '(lua-mode meson-mode github-dark-vscode-theme github-modern-theme github-theme which-key magit tao-theme cyberpunk-2019-theme cyberpunk-theme minimap minibar vscode-dark-plus-theme beacon gruvbox-theme standard-themes alect-themes helm fzf monokai-pro-theme monokai-alt-theme monokai-theme naysayer-theme solarized-theme ef-themes solo-jazz-theme modus-themes ample-theme swiper ivy ein jupyter ido-hacks powerline horizon-theme atom-dark-theme doom-themes atom-one-dark-theme ancient-one-dark-theme typescript-mode csv csv-mode use-package rust-mode lsp-ui key-chord ido-completing-read+ general flycheck evil-mc-extras evil-commentary company amx)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family user-font))))
 '(fixed-pitch-serif ((t (:family user-font)))))


