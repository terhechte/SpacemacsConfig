;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

;; Dirty way to add custom dir
(progn (cd "~/.spacemacsConfig") (normal-top-level-add-subdirs-to-load-path) (cd "~"))


(defun new-empty-frame()
  (interactive)
  (let ((new-buffer-name (format "new-buffer-%i" new-buffer-counter)))
    (make-frame '((width . 95) (height . 50)))
    (get-buffer-create new-buffer-name)
    (setq new-buffer-counter (+ 1 new-buffer-counter))
    (switch-to-buffer new-buffer-name)))

(defun kill-maybe-empty-frame()
  (interactive)
  (if (and (= (buffer-size) 0)
        (string-prefix-p "new-buffer-" (buffer-name)))
    (kill-buffer (current-buffer)))
  (delete-frame))

;; do m-x accents and then a" will enter the ä ö
(defun accents ()
  (interactive)
  (set-language-environment "UTF-8")
  (activate-input-method "latin-1-alt-postfix"))


;; Force railwaycats emacs to open drag and drop files
;; in a new frame instead of replacing the currently selected buffer
;; We're overwriting it right now, as defadvice seems to not work
(defun dnd-open-local-file (uri _action)
  (let* ((f (dnd-get-local-file-name uri t)))
    (if (and f (file-readable-p f))
      (find-file-other-frame f)
      (error "Can not read %s" uri))))

;; Interesting, it seems fira mono is the *fastest* font for Emacs on OSX
;(set-face-font 'default "Fira Mono-12")

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
       (git :variables git-gutter-use-fringe t)
       markdown
       org
       rust
       emoji
       ;swift
       syntax-checking
       osx

       ;; Add support for my most used languages
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
       switch-window
       dabbrev
       simpleclip
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
    ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
    ;; possible. Set it to nil if you have no way to use HTTPS in your
    ;; environment, otherwise it is strongly recommended to let it set to t.
    ;; This variable has no effect if Emacs is launched with the parameter
    ;; `--insecure' which forces the value of this variable to nil.
    ;; (default t)
    dotspacemacs-elpa-https t
    ;; Maximum allowed time in seconds to contact an ELPA repository.
    dotspacemacs-elpa-timeout 5
    ;; If non nil then spacemacs will check for updates at startup
    ;; when the current branch is not `develop'. (default t)
    dotspacemacs-check-for-update t
    ;; Either `vim' or `emacs'. Evil is always enabled but if the variable
    ;; is `emacs' then the `holy-mode' is enabled at startup.
                                        ;dotspacemacs-editing-style 'vim
    dotspacemacs-editing-style 'hybrid
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
    dotspacemacs-startup-lists '(recents projects bookmarks)
    ;; List of themes, the first of the list is loaded when spacemacs starts.
    ;; Press <SPC> T n to cycle to the next theme in the list (works great
    ;; with 2 themes variants, one dark and one light)
    dotspacemacs-themes '(
                           ;; Default Theme
                           misterioso
                           ;; Good Dark Themes
                           spacemacs-dark
                           wombat
                           ;; Good Bright Themes
                           adwaita
                           dichromacy
                           )
    ;; If non nil the cursor color matches the state color.
    dotspacemacs-colorize-cursor-according-to-state 1
    ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
    ;; size to make separators look not too crappy.
    dotspacemacs-default-font '("M+ 1mn light"
                                 :size 16
                                 :weight normal
                                 :width normal
                                 :powerline-scale 1.0)
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
    ;; If non nil `Y' is remapped to `y$'. (default t)
    dotspacemacs-remap-Y-to-y$ t
    ;; Name of the default layout (default "Default")
    dotspacemacs-default-layout-name "Default"
    ;; If non nil the default layout name is displayed in the mode-line.
    ;; (default nil)
    dotspacemacs-display-default-layout t
    ;; If non nil then the last auto saved layouts are resume automatically upon
    ;; start. (default nil)
    dotspacemacs-auto-resume-layouts nil
    ;; Location where to auto-save files. Possible values are `original' to
    ;; auto-save the file in-place, `cache' to auto-save the file to another
    ;; file stored in the cache directory and `nil' to disable auto-saving.
    ;; (default 'cache)
    dotspacemacs-auto-save-file-location 'cache
    ;; Maximum number of rollback slots to keep in the cache. (default 5)
    dotspacemacs-max-rollback-slots 5
    ;; If non nil then `ido' replaces `helm' for some commands. For now only
    ;; `find-files' (SPC f f) is replaced.
    dotspacemacs-use-ido nil
    ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
    ;; several times cycle between the kill ring content.
    dotspacemacs-enable-paste-micro-state t
    ;; Guide-key delay in seconds. The Guide-key is the popup buffer listing
    ;; the commands bound to the current keystrokes.
    dotspacemacs-guide-key-delay 0.4
    ;; If non nil a progress bar is displayed when spacemacs is loading. This
    ;; may increase the boot time on some systems and emacs builds, set it to
    ;; nil ;; to boost the loading time.
    dotspacemacs-loading-progress-bar nil
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
    ;dotspacemacs-mode-line-unicode-symbols nil
    ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
    ;; scrolling overrides the default behavior of Emacs which recenters the
    ;; point when it reaches the top or bottom of the screen.
    dotspacemacs-smooth-scrolling t
    ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
    ;; derivatives. If set to `relative', also turns on relative line numbers.
    ;; (default nil)
    dotspacemacs-line-numbers 'relative
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

  )

(defun dotspacemacs/user-config ()
  "Configuration function.
 This function is called at the very end of Spacemacs initialization after
layers configuration."


  (require 'swift-mode)
(require 'memoize)
(require 'all-the-icons)
(require 'spaceline-all-the-icons)

  ;; Sane indent for lisp & clojure. otherwise even simple
  ;; things quickly become code skyscrapers when working with cljs and om
  (setq lisp-indent-offset 2)

  (define-key evil-insert-state-map "\C-g" 'evil-normal-state)
  (define-key evil-hybrid-state-map "\C-g" 'evil-normal-state)

  (define-key evil-insert-state-map "\C-e" 'end-of-line)
  (define-key evil-visual-state-map "\C-e" 'evil-end-of-line)

  (define-key evil-insert-state-map "\C-n" 'evil-next-line)
  (define-key evil-insert-state-map "\C-p" 'evil-previous-line)

  (define-key evil-insert-state-map "\C-y" 'yank)
  (define-key evil-insert-state-map "\C-k" 'kill-line)

  (define-key evil-normal-state-map (kbd "C-.") 'execute-extended-command)
  (define-key evil-insert-state-map (kbd "C-.") 'execute-extended-command)
  (define-key evil-hybrid-state-map (kbd "C-.") 'execute-extended-command)

  (define-key evil-emacs-state-map (kbd "C-.") 'execute-extended-command)

  (global-set-key (kbd "s-o") 'find-file)
  (global-set-key (kbd "s-p") 'find-file-at-point)
  (global-set-key (kbd "s-t") 'helm-projectile-find-file)
  (global-set-key (kbd "s-n") 'new-empty-frame)

  ;; Share symmetric keys when opening encrypted fiels
  (setq epa-file-cache-passphrase-for-symmetric-encryption t)

  ;; When drag/dropping files onto emacs, don't insert into the buffer,
  ;; but open the files
  (setq ns-pop-up-frames t)
  (global-set-key [ns-drag-file] 'ns-find-file)

  ;; window-splitting
  (global-set-key (kbd "s-1") 'delete-other-windows)
  (global-set-key (kbd "s-2") 'split-window-horizontally)
  (global-set-key (kbd "s-3") 'split-window-vertically)
  (global-set-key (kbd "s-4") 'delete-other-windows-vertically)
  (global-set-key (kbd "s-5") 'delete-window)

  (global-set-key (kbd "<s-return>" ) 'completion-at-point)

  ;; Simple clip makes it possible to not overwrite clipboard during yanking
  ;; https://github.com/rolandwalker/simpleclip
  (simpleclip-mode 1)

  ;; Remove the C-g binding for smartparens. I use C-g instead of esc or ctrl-c
  ;; to exit insert mode. With smartparens occupying it, I often couldn't
  ;; exit insert mode. Awful feeling
  ;;(eval-after-load "smartparens-mode"
  ;;  '(progn
  ;;     (define-key sp-pair-overlay-keymap (kbd "C-g") nil)
  ;;     (define-key sp-wrap-overlay-keymap (kbd "C-g") nil)))

  ;; Emacs check if we have a region, then eval that, otherwise the left sexp
  (defun eval-region-or-left-sexp ()
    (interactive)
    (if (and transient-mark-mode mark-active)
      (progn ; there is a text selection
        (eval-region (region-beginning) (region-end)))
      (progn ; user did not have text selection feature on
        (eval-last-sexp nil))))

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

  (global-set-key (kbd "s-w") 'kill-maybe-empty-frame)
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

  ;; mouse-2 will be Option+Click and mouse-3 will be Cmd+Click
  (setq mac-emulate-three-button-mouse t)

  ;; Load Swift Org Mode and customize the org mode languages
  ;; 
  ;;Since version 0.104, spacemacs uses the =org= version from the org ELPA
  ;;repository instead of the one shipped with emacs. Then, any =org= related code
  ;;should not be loaded before =dotspacemacs/user-config=, otherwise both versions
  ;;will be loaded and will conflict.
  (with-eval-after-load 'org
    (require 'ob-swift)
    (org-babel-do-load-languages
      'org-babel-load-languages
      '((ditaa . t)(python . t)(C . t)(lisp . t)(js . t)(emacs-lisp . t)(css . t) (swift . t) ))
    ;; fontification in source blocks
    (setq org-src-fontify-natively t)
    (add-to-list 'org-src-lang-modes (cons "swift" 'swift)))

  ;;To install Github related extensions like [[https://github.com/larstvei/ox-gfm][ox-gfm]] to export to Github
  ;;flavored markdown set the variable =org-enable-github-support= to =t=.
  (setq-default dotspacemacs-configuration-layers '(
                                                     (org :variables
                                                       org-enable-github-support t)))

  ;; Yasnippet for company
  (require 'yasnippet)
  (yas-global-mode 1)

  ;; allow magit buffers in helm
  (setq helm-white-buffer-regexp-list '("\\*magit:" "\\*ansi-term"))

  (setq server-socket-dir "~/.emacs.d/server")

  (global-set-key (kbd "C-v") 'evil-visual-block)
  ;; Go
  ;(eval-after-load "go-mode" '(require 'flymake-go))
  ;(require 'go-complete)
  ;(add-hook 'completion-at-point-functions 'go-complete-at-point)


  ;; Swift Company Mode
                                        ; (setq exec-path (append exec-path '("/usr/local/bin/sourcekittendaemon")))
                                        ;  (require 'company-sourcekit)
                                        ;  (add-to-list 'company-backends 'company-sourcekit)

                                        ;FXBACk
                                        ;  (add-hook 'swift-mode-hook (lambda ()
                                        ;                               (set (make-local-variable 'company-backends) '(company-sourcekit))
                                        ;                               (company-mode)))

  ;; Flyspell hampers my C-g quit binding to leave insert mode
  ;; setting flyspell to do its thing with a delay via flyspell-lazy
  ;; seems to fix this
  (require 'flyspell-lazy)
  (flyspell-lazy-mode 1)

  (unless (display-graphic-p)
    (setq linum-relative-format "%3s "))

  (setq spaceline-all-the-icons-icon-set-window-numbering 'string)
  (setq spaceline-all-the-icons-icon-set-eyebrowse-slot nil)


  ;; This sets the title bar to dark
  (when (memq window-system '(mac ns))
    (add-to-list 'default-frame-alist '(ns-appearance . dark))
    (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
    ;; This will disable the title bar
    (setq frame-title-format nil)
    )


  (setq spaceline-all-the-icons-separator-type 'none)
  (spaceline-all-the-icons-theme)
  (spacemacs/zoom-frm-in)

  ;; Add a deletion hook so that when I close an emacs window/frmame,
  ;; all the buffers in there will be killed as well.
  ;; http://stackoverflow.com/questions/1854573/kill-the-associated-buffer-when-close-the-emacs-client-frame-by-pressing-altf4
  (add-hook 'delete-frame-functions
    (lambda (frame)
      (let* ((window (frame-selected-window frame))
              (buffer (and window (window-buffer window))))
        (when (and buffer (buffer-file-name buffer))
          (kill-buffer buffer)))))

  (setq dnd-open-file-other-window 1)

  (set-cursor-color "orange")

  ;; set org agenda directory
  (setq org-agenda-files '("~/Dropbox/org/"))
  )



;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-backends (quote (ascii html icalendar latex md)))
 '(package-selected-packages
   (quote
    (white-sand-theme rebecca-theme org-mime exotica-theme zen-and-art-theme yapfify winum uuidgen underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme toxi-theme tao-theme tangotango-theme tango-plus-theme tango-2-theme sunny-day-theme sublime-themes subatomic256-theme subatomic-theme powerline spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme seti-theme reverse-theme railscasts-theme py-isort purple-haze-theme pug-mode professional-theme planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme osx-dictionary orgit organic-green-theme org-projectile org-category-capture alert log4e gntp org-download omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme naquadah-theme mustang-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme markdown-mode majapahit-theme magit-gitflow madhat2r-theme lush-theme livid-mode skewer-mode simple-httpd live-py-mode link-hint light-soap-theme json-snatcher json-reformat js2-mode jbeans-theme jazz-theme ir-black-theme inkpot-theme parent-mode hide-comnt heroku-theme hemisu-theme projectile hc-zenburn-theme haml-mode gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme git-link gandalf-theme fuzzy pos-tip flycheck flx flatui-theme flatland-theme farmhouse-theme eyebrowse evil-visual-mark-mode evil-unimpaired evil-magit ghub let-alist smartparens iedit evil-ediff anzu evil goto-chg undo-tree espresso-theme dumb-jump dracula-theme django-theme diminish darktooth-theme autothemer darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme web-completion-data dash-functional tern company column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized clues-theme clojure-snippets hydra inflections edn multiple-cursors paredit peg eval-sexp-fu highlight cider seq spinner queue pkg-info clojure-mode epl cherry-blossom-theme cargo busybee-theme bubbleberry-theme birds-of-paradise-plus-theme bind-map bind-key badwolf-theme yasnippet packed apropospriate-theme anti-zenburn-theme anaconda-mode pythonic f dash s ample-zen-theme ample-theme alect-themes helm avy helm-core async auto-complete popup epresent toml-mode racer flycheck-rust company-racer deferred go-complete go-eldoc go-mode flymake-go rust-mode flymake-rust lua-mode smeargle helm-gitignore request gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger magit magit-popup git-commit with-editor emoji-cheat-sheet-plus company-emoji zenburn-theme ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vi-tilde-fringe use-package toc-org tagedit switch-window swift-mode spacemacs-theme spaceline smooth-scrolling slim-mode simpleclip scss-mode sass-mode reveal-in-osx-finder restclient restart-emacs rainbow-delimiters quelpa pyvenv pytest pyenv-mode popwin pip-requirements persp-mode pcre2el pbcopy paradox page-break-lines osx-trash org-repo-todo org-present org-pomodoro org-plus-contrib org-bullets open-junk-file neotree move-text monokai-theme mmm-mode markdown-toc macrostep lorem-ipsum linum-relative leuven-theme less-css-mode launchctl json-mode js2-refactor js-doc jade-mode info+ indent-guide ido-vertical-mode hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-dash helm-css-scss helm-company helm-c-yasnippet helm-ag google-translate golden-ratio gnuplot gh-md flycheck-pos-tip flx-ido fill-column-indicator fancy-battery expand-region exec-path-from-shell evil-visualstar evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-jumper evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-args evil-anzu emmet-mode elisp-slime-nav deft define-word dash-at-point cython-mode company-web company-tern company-statistics company-quickhelp company-anaconda coffee-mode clj-refactor clean-aindent-mode cider-eval-sexp-fu buffer-move bracketed-paste auto-yasnippet auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell ac-dabbrev))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
