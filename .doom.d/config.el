;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Chris Buccola"
      user-mail-address "chbuccola@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Fira Code" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13)
      doom-big-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-city-lights)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)



;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(use-package! exwm)
(use-package! xelb)
(use-package! emms)

;; EXWM config (edited DistroTube config)
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
(require 'exwm-systemtray)
(exwm-systemtray-enable)
(require 'exwm-randr)
(exwm-randr-enable)
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (start-process-shell-command
              "xrandr" nil "xrandr --output DisplayPort-0 --primary --mode 1920x1080 --rate 144 --left-of DisplayPort-2
                                   --output DisplayPort-2 --mode 1920x1080 --rate 144")))
(setq exwm-workspace-number 10
      exwm-randr-workspace-monitor-plist '(1 "DisplayPort-0"
                                           2 "DisplayPort-2"))

(setq exwm-input-prefix-keys '(?\M-x
                               ?\M-:)
      exwm-input-simulation-keys '(([?\s-F] . [?\C-f])
                                   )
      exwm-input-global-keys '(([?\M-\s-7] . (lambda (command)
                                             (interactive (list (read-shell-command "$ ")))
                                             (start-process-shell-command command nil command)))
                               ;; splits
                               ([?\s-v] . evil-window-vsplit)
                               ([?\s-z] . evil-window-split)
                               ;; managing workspaces
                               ([?\s-w] . exwm-workspace-switch)
                               ([?\s-W] . exwm-workspace-swap)
                               ([?\s-\C-w] . exwm-workspace-move)
                               ;; essential programs
                               ([?\s-d] . dired)
                               ([?\s-e] . eshell)
                               ([s-return] . jz/exwm-start-alacritty)
                               ([s-S-return] . (lambda (command)
                                               (interactive (list (read-shell-command "$ ")))
                                               (start-process-shell-command command nil command)))
                               ([?\s-X] . jz/exwm-session-manager)
                               ;; killing buffers and windows
                               ([?\s-b] . ibuffer)
                               ([?\s-B] . kill-current-buffer)
                               ([?\s-C] . +workspace/close-window-or-workspace)
                               ;; change window focus with super+h,j,k,l
                               ([?\s-h] . evil-window-left)
                               ([?\s-j] . evil-window-next)
                               ([?\s-k] . evil-window-prev)
                               ([?\s-l] . evil-window-right)
                               ;; move windows around using SUPER+SHIFT+h,j,k,l
                               ([?\s-H] . +evil/window-move-left)
                               ([?\s-J] . +evil/window-move-down)
                               ([?\s-K] . +evil/window-move-up)
                               ([?\s-L] . +evil/window-move-right)
                               ;; move window to far left or far right with SUPER+CTRL+h,l
                               ([?\s-\C-h] . side-left-window)
                               ([?\s-\C-j] . side-bottom-window)
                               ([?\s-\C-l] . side-right-window)
                               ([?\s-\C-d] . side-window-delete-all)
                               ([?\s-\C-r] . resize-window)
                               ;; switch workspace with SUPER+{0-9}
                               ([?\s-0] . (lambda () (interactive) (exwm-workspace-switch-create 0)))
                               ([?\s-1] . (lambda () (interactive) (exwm-workspace-switch-create 1)))
                               ([?\s-2] . (lambda () (interactive) (exwm-workspace-switch-create 2)))
                               ([?\s-3] . (lambda () (interactive) (exwm-workspace-switch-create 3)))
                               ([?\s-4] . (lambda () (interactive) (exwm-workspace-switch-create 4)))
                               ([?\s-5] . (lambda () (interactive) (exwm-workspace-switch-create 5)))
                               ([?\s-6] . (lambda () (interactive) (exwm-workspace-switch-create 6)))
                               ([?\s-7] . (lambda () (interactive) (exwm-workspace-switch-create 7)))
                               ([?\s-8] . (lambda () (interactive) (exwm-workspace-switch-create 8)))
                               ([?\s-9] . (lambda () (interactive) (exwm-workspace-switch-create 9)))
                               ;; move window workspace with SUPER+SHIFT+{0-9}
                               ([?\s-\)] . (lambda () (interactive) (exwm-workspace-move-window 0)))
                               ([?\s-!] . (lambda () (interactive) (exwm-workspace-move-window 1)))
                               ([?\s-@] . (lambda () (interactive) (exwm-workspace-move-window 2)))
                               ([?\s-#] . (lambda () (interactive) (exwm-workspace-move-window 3)))
                               ([?\s-$] . (lambda () (interactive) (exwm-workspace-move-window 4)))
                               ([?\s-%] . (lambda () (interactive) (exwm-workspace-move-window 5)))
                               ([?\s-^] . (lambda () (interactive) (exwm-workspace-move-window 6)))
                               ([?\s-&] . (lambda () (interactive) (exwm-workspace-move-window 7)))
                               ([?\s-*] . (lambda () (interactive) (exwm-workspace-move-window 8)))
                               ([?\s-\(] . (lambda () (interactive) (exwm-workspace-move-window 9)))
                               ;; SUPER+/ switches to char-mode (needed to pass commands in XWindows sometimes)
                               ;; SUPER+? switches us back to line-mode
                               ([?\s-/] . exwm-input-release-keyboard)
                               ([?\s-?] . exwm-reset)
                               ;; setting some toggle commands
                               ([?\s-f] . exwm-floating-toggle-floating)
                               ([?\s-m] . exwm-layout-toggle-mode-line)
                               ([f11] . exwm-layout-toggle-fullscreen)))

(defun jz/exwm-start-alacritty ()
  (interactive)
  (start-process-shell-command "alacritty" nil "alacritty"))

;; (defun jz/exwm-start-lxsession ()
;;   (interactive)
;; (start-process-shell-command "lxsession" nil "lxsession"))

(defun jz/exwm-start-picom ()
  (interactive)
  (start-process-shell-command "picom" nil "picom"))

;; (defun jz/exwm-start-dmenu ()
;;   (lambda (command)
;;   (interactive (list (read-shell-command "$ ")))
;;   (start-process-shell-command command nil command)))

(defun jz/exwm-disable-mouse-accel-1 ()
  (interactive)
  (start-process-shell-command "xinput --set-prop 7 'libinput Accel Speed' -1" nil "xinput --set-prop 7 'libinput Accel Speed' -1"))
(defun jz/exwm-disable-mouse-accel-2 ()
  (interactive)
  (start-process-shell-command "xinput --set-prop 8 'libinput Accel Speed' -1" nil "xinput --set-prop 8 'libinput Accel Speed' -1"))
(defun jz/exwm-disable-mouse-accel-3 ()
  (interactive)
  (start-process-shell-command "xinput --set-prop 9 'libinput Accel Speed' -1" nil "xinput --set-prop 9 'libinput Accel Speed' -1"))

(defun jz/exwm-144hz ()
  (interactive)
  (start-process-shell-command "xrandr --output DisplayPort-2 --mode 1920x1080 --rate 144" nil "xrandr --output DisplayPort-2 --mode 1920x1080 --rate 144"))

(defun jz/exwm-session-manager ()
  (interactive)
  (start-process-shell-command "alacritty -e .local/share/bin/session.sh" nil "alacritty -e .local/share/bin/session.sh"))

;; (defun jz/exwm-start-nm-applet ()
;;   (interactive)
;;   (start-process-shell-command "nm-applet" nil "nm-applet"))

(defun jz/exwm-start-volumeicon ()
  (interactive)
  (start-process-shell-command "volumeicon" nil "volumeicon"))

(after! exwm
  ;; (jz/exwm-start-lxsession)
  (jz/exwm-start-picom)
  (jz/exwm-disable-mouse-accel-1)
  (jz/exwm-disable-mouse-accel-2)
  (jz/exwm-disable-mouse-accel-3)
  (jz/exwm-144hz)
  ;; (jz/exwm-start-nm-applet)
  (jz/exwm-start-volumeicon)
  (setq display-time-day-and-date t
        display-time-format "%a %b %d, %Y (%H:%M)")
  (display-time-mode 1))

;; EMMS stuff
(add-to-list 'load-path "~/.emacs.d/.local/straight/build-27.1/emms/")
(require 'emms-setup)
(emms-all)
(emms-default-players)
(setq emms-source-file-default-directory "~/Music/")

