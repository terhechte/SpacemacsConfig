;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

;; Dirty way to add custom dir
(progn (cd "~/.spacemacsConfig") (normal-top-level-add-subdirs-to-load-path) (cd "~"))

;; TODO:
;; C-n / C-p for auto-completion windows (right now, use M-n, M-p instead)
;; figure out why C-g sometimes doesn't work
;; this is sticky this 

;; do m-x accents and then a" will enter the ä ö
(defun accents ()
  (interactive)
  (set-language-environment "UTF-8")
  (activate-input-method "latin-1-alt-postfix"))


;; Force railwaycats emacs to open drag and drop files
;; in a new frame instead of replacing the currently selected buffer
(defun my-dnd-open-local-file (uri _action)
  (let* ((f (dnd-get-local-file-name uri t)))
    (if (and f (file-readable-p f))
      (find-file-other-frame f)
      (error "Can not read %s" uri))))

(defadvice mac-ae-open-documents (around my-mac-ae-open-documents)
  "Temporarily replace `dnd-open-local-file`"
  (progn
    (advice-add 'dnd-open-local-file :around #'my-dnd-open-local-file)
    ad-do-it
    (advice-remove 'dnd-open-local-file #'my-dnd-open-local-file)))


(defun dotspacemacs/layers ()
  "Configuration Layers declaration."
  (setq-default
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (ie. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     auto-completion
     ;; better-defaults
     emacs-lisp
     (git :variables
          git-gutter-use-fringe t)
     markdown
     org
     ;; shell
     syntax-checking
     osx

     ;; Add support for my most used languages
     clojure
     python
     dash ; todo, create a keybinding for dash-at-point
     javascript
     html

     )
   ;; List of additional packages that will be installed wihout being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages then consider to create a layer, you can also put the
   ;; configuration in `dotspacemacs/config'.
   dotspacemacs-additional-packages
   '(
     company
     switch-window
     swift-mode
     ac-dabbrev
     dabbrev
     simpleclip
     restclient
     company-mode
     )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '()
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Either `vim' or `emacs'. Evil is always enabled but if the variable
   ;; is `emacs' then the `holy-mode' is enabled at startup.
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer.
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed.
   dotspacemacs-startup-banner 'official
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'."
   dotspacemacs-startup-lists '(recents projects)
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(zenburn
                         solarized-light
                         solarized-dark
                         leuven
                         monokai)
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it.
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f) is replaced.
   dotspacemacs-use-ido nil
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content.
   dotspacemacs-enable-paste-micro-state nil
   ;; Guide-key delay in seconds. The Guide-key is the popup buffer listing
   ;; the commands bound to the current keystrokes.
   dotspacemacs-guide-key-delay 0.4
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil ;; to boost the loading time.
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up.
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX."
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'.
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'.
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line.
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen.
   dotspacemacs-smooth-scrolling t
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible value is `all',
   ;; `current' or `nil'. Default is `all'
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now.
   dotspacemacs-default-package-repository nil
   )
  ;; User initialization goes here

  ;; mouse-2 will be Option+Click and mouse-3 will be Cmd+Click
  (setq mac-emulate-three-button-mouse t)

  ;; Load Swift Org Mode and customize the org mode languages

  (require 'ob-swift)
  (org-babel-do-load-languages
    'org-babel-load-languages
    '((python . t)(sh . t)(R . t)(C . t)(clojure . t)(lisp . t) (sql . t) (js . t)  (emacs-lisp . t) (css . t)(swift . t)  ))

  ;; fontification in source blocks
  (setq org-src-fontify-natively t)
  ;; add swift-mode to fontification
  (add-to-list 'org-src-lang-modes (cons "swift" 'swift))
  ;; C-' to enter source block edit mode!

  ;; Swift Company Mode
  ;(require 'company-sourcekit)
  (require 'flyspell-lazy)
  (flyspell-lazy-mode 1)
  (setq dnd-open-file-other-window 1)
  )

(defun dotspacemacs/config ()
  "Configuration function.
 This function is called at the very end of Spacemacs initialization after
layers configuration."

  ;; Sane indent for lisp & clojure. otherwise even simple
  ;; things quickly become code skyscrapers when working with cljs and om
  (setq lisp-indent-offset 2)

  (define-key evil-insert-state-map "\C-g" 'evil-normal-state)

  (define-key evil-insert-state-map "\C-e" 'end-of-line)
  (define-key evil-visual-state-map "\C-e" 'evil-end-of-line)

  (define-key evil-insert-state-map "\C-n" 'evil-next-line)
  (define-key evil-insert-state-map "\C-p" 'evil-previous-line)

  (define-key evil-insert-state-map "\C-y" 'yank)
  (define-key evil-insert-state-map "\C-k" 'kill-line)

  (define-key evil-normal-state-map (kbd "C-.") 'execute-extended-command)
  (define-key evil-insert-state-map (kbd "C-.") 'execute-extended-command)

  (global-set-key (kbd "s-o") 'find-file)
  (global-set-key (kbd "s-p") 'find-file-at-point)
  (global-set-key (kbd "s-t") 'helm-projectile-find-file)
  (global-set-key (kbd "s-n") 'new-frame)

  ;; Share symmetric keys when opening encrypted fiels
  (setq epa-file-cache-passphrase-for-symmetric-encryption t)


  ;; Open new files (dropped onto emacs) in a new frame/window
  (setq ns-pop-up-frames t)

  ;; When drag/dropping files onto emacs, don't insert into the buffer,
  ;; but open the files
  (global-set-key [ns-drag-file] 'ns-find-file)

  ;; window-splitting
  (global-set-key (kbd "s-1") 'delete-other-windows)
  (global-set-key (kbd "s-2") 'split-window-horizontally)
  (global-set-key (kbd "s-3") 'split-window-vertically)
  (global-set-key (kbd "s-4") 'delete-other-windows-vertically)
  (global-set-key (kbd "s-5") 'delete-window)

  (global-set-key (kbd "s--") 'text-scale-decrease) 
  (global-set-key (kbd "s-=") 'text-scale-increase) 

  (global-set-key (kbd "<s-return>" ) 'completion-at-point)

  ;; Simple clip makes it possible to not overwrite clipboard during yanking
  ;; https://github.com/rolandwalker/simpleclip
  (cua-mode)
  (simpleclip-mode 1)

  ;; Remove the C-g binding for smartparens. I use C-g instead of esc or ctrl-c
  ;; to exit insert mode. With smartparens occupying it, I often couldn't
  ;; exit insert mode. Awful feeling
  (eval-after-load "smartparens-mode"
    '(progn
       (define-key sp-pair-overlay-keymap (kbd "C-g") nil)
       (define-key sp-wrap-overlay-keymap (kbd "C-g") nil)))

  ;; Emacs check if we have a region, then eval that, otherwise the left sexp
  (defun eval-region-or-left-sexp ()
    (interactive)
    (if (and transient-mark-mode mark-active)
        (progn ; there is a text selection
          (eval-region (region-beginning) (region-end)))
      (progn ; user did not have text selection feature on
        (eval-last-sexp-1 nil))))

  (defun sql-eval-region ()
    (interactive)
    (when (and transient-mark-mode mark-active)
      (progn ; there is a text selection
        (sql-send-region (region-beginning) (region-end)))))

  (defun my-fast-eval ()
    (interactive)
    (cond ((eq major-mode 'clojure-mode) (cider-eval-last-sexp))
          ((eq major-mode 'sql-mode) (sql-eval-region))
          ((eval-region-or-left-sexp))))
  (global-set-key (kbd "C-'") 'my-fast-eval)

  (global-set-key (kbd "s-w") 'delete-frame)
  (global-set-key (kbd "s-a") 'mark-whole-buffer)
  (global-set-key (kbd "s-l") 'goto-line)
  (global-set-key (kbd "s-'") 'switch-window)

  ;; Custom Stuff
  (evil-leader/set-key "or" 'recentf-open-files)
  (evil-leader/set-key "oi" 'imenu)
  (evil-leader/set-key "o/" 'evilnc-comment-or-uncomment-lines)

  (evil-leader/set-key "os" 'spotify-next-track)
  (evil-leader/set-key "oa" 'spotify-info-track)



  (defun get-buf-url (url)
    (interactive "surl to fetch:")
    (url-retrieve url
                  (lambda (status) (switch-to-buffer (current-buffer)))))

  (defun switch-to-previous-buffer ()
    (interactive)
    (switch-to-buffer (other-buffer (current-buffer) 1)))

  ;; a simple function that generates a new random buffer,
  ;; so that I can easily create a scratch buffer
  (defvar new-buffer-counter 0 "the counter where the new new-buffer tracks the buf number")
  (defun new-buffer ()
    (interactive)
    (let ((new-buffer-name (format "new-buffer-%i" new-buffer-counter)))
      (get-buffer-create new-buffer-name)
      (setq new-buffer-counter (+ 1 new-buffer-counter))
      (switch-to-buffer new-buffer-name)))

  (evil-leader/set-key "on" 'new-buffer)
  (evil-leader/set-key "op" 'switch-to-previous-buffer)

  (defun evil-select-lisp-form ()
    (interactive)
    (evil-visual-char)
    (evil-jump-item))

  (global-set-key (kbd "C-5") 'evil-select-lisp-form)


  ;; Activate all words omnicompletion like in vim
  ;; particularly handy for text files, todo lists. However not always
  ;; useful since it sucks in code where it mixes up syntax with comments
  ;; so we have a dedicated functino that enables it
  (defun omnicompletion-like-vim ()
    (interactive)
    (require 'dabbrev)
    (require 'ac-dabbrev)
    (auto-complete-mode))

  ;; Set the same selection color as native OSX
  (set-face-attribute 'region nil :background "#0069D9")

  ;; enable flycheck for swift
  ;; disable for now, flycheck doesn't work yet with complex projects
  ;; (i.e. frameworks, etc)
  ;;(add-to-list 'flycheck-checkers 'swift)

)

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
