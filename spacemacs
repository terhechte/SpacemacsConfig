;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

;; Dirty way to add custom dir
(progn (cd "~/.spacemacsConfig") (normal-top-level-add-subdirs-to-load-path) (cd "~"))

(defun xcode-open()
  (interactive)
  (let ((filename (buffer-file-name)))
    (call-process "/bin/bash" nil t nil "-c" (format "open -a Xcode %s" filename))))



;;(set-face-font 'default "Fira Mono-12")
(set-face-font 'default "Input")
;;(set-face-font 'variable-pitch "Helvetica Neue-14")
(set-face-font 'variable-pitch "Avenir Next Condensed Medium")
;(copy-face 'default 'fixed-pitch)

;; Variable-Pitch-Org-Mode
;;(add-hook 'org-mode-hook
;;  '(lambda ()
;;     (variable-pitch-mode 1)
;;     (mapc
;;       (lambda (face)
;;         (set-face-attribute face nil :inherit 'fixed-pitch))
;;       (list 'org-code
;;         'org-link 
;;         'org-block
;;         'org-table
;;         'org-block-begin-line
;;         'org-block-end-line
;;         'org-meta-line
;;         'org-document-info-keyword))))


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
       emoji
       html ;; web mode
       ;; shell
       syntax-checking
       osx
       python
       ruby
       javascript
       ;; more themes
       ;; http://themegallery.robdor.com
       themes-megapack
       )
   ;; List of additional packages that will be installed wihout being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages then consider to create a layer, you can also put the
   ;; configuration in `dotspacemacs/config'.
   dotspacemacs-additional-packages
   '(
      switch-window
      swift-mode
      ac-dabbrev
      dabbrev
      ;epresent
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
   dotspacemacs-startup-lists '(recents projects)
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
    dotspacemacs-themes '(
                           ;; default
                           afternoon
                           monokai
                           ;; bright
                           espresso
                           sanityinc-tomorrow-day
                           dichromacy
                           tango-plus
                           tsdh-light
                           solarized-light
                           ;; dark
                           afternoon
                           zenburn
                           solarized-dark
                           )
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state nil
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   ;; dotspacemacs-default-font '("Source Code Pro"
;   dotspacemacs-default-font '("Fira Mono"
;                               :size 13
;                               :weight normal
;                               :width normal
;                               :powerline-scale 1.1)
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
   dotspacemacs-fullscreen-use-non-native t
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
   dotspacemacs-mode-line-unicode-symbols nil
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
  ;(global-vi-tilde-fringe-mode -1)

  )

(defun dotspacemacs/user-config ()
  "Configuration function.
 This function is called at the very end of Spacemacs initialization after
layers configuration."

  (setq magit-repository-directories '( "~/Development/monorepi" "~/Development/Swift/Performance" ))

;;(require 'swift-mode)
  (require 'epresent)

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
  (global-set-key (kbd "s-n") 'new-frame)

  ;; Share symmetric keys when opening encrypted fiels
  (setq epa-file-cache-passphrase-for-symmetric-encryption t)

;; Tell Magit to fill the whole buffer when opening
(setq magit-display-buffer-function
  #'magit-display-buffer-fullframe-status-v1)

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
  ;(simpleclip-mode 1)

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
        (eval-last-sexp nil))))

  (defun my-fast-eval ()
    (interactive)
    (cond ((eq major-mode 'clojure-mode) (cider-eval-last-sexp))
          ((eq major-mode 'sql-mode) (sql-eval-region))
          ((eval-region-or-left-sexp))))
  (global-set-key (kbd "C-'") 'my-fast-eval)

(defun abcdefg ()
  (interactive)
  (message "u")
  (set-frame-parameter nil 'alpha
    (cons 50 50))
  )

  (global-set-key (kbd "s-w") 'delete-frame)
  (global-set-key (kbd "s-a") 'mark-whole-buffer)
  (global-set-key (kbd "s-l") 'goto-line)
  (global-set-key (kbd "s-'") 'switch-window)
(global-set-key (kbd "M-s--") 'spacemacs/increase-transparency)
(global-set-key (kbd "M-s-=") 'spacemacs/decrease-transparency)
(global-set-key (kbd "M-s-8") 'abcdefg)

  ;; Custom Stuff
  (evil-leader/set-key "or" 'recentf-open-files)
  (evil-leader/set-key "oi" 'imenu)
  (evil-leader/set-key "o/" 'evilnc-comment-or-uncomment-lines)

  (evil-leader/set-key "os" 'spotify-next-track)
  (evil-leader/set-key "oa" 'spotify-info-track)

(defun normal-escape-pre-command-handler ()
  (interactive)
  (pcase this-command
    (_ (when (and (string= "C-g" (key-description (this-command-keys)))
            (bound-and-true-p evil-mode)
              (or (evil-insert-state-p)
                (evil-emacs-state-p)))
        (evil-force-normal-state)))))
(add-hook 'pre-command-hook 'normal-escape-pre-command-handler)

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
    '((sh . t)(emacs-lisp . t)(swift . t) ))

    ;; fontification in source blocks
    (setq org-src-fontify-natively t)
    ;; add swift-mode to fontification
    (add-to-list 'org-src-lang-modes (cons "swift" 'swift)))

(spacemacs/toggle-vi-tilde-fringe)

;; Switch details with =(=
(add-hook 'dired-mode-hook 'dired-hide-details-mode)
  ;; C-' to enter source block edit mode!

  (set-cursor-color "orange")

(defun ck/org-confirm-babel-evaluate (lang body)
  (not (or (string= lang "swift") )))
(setq org-confirm-babel-evaluate 'ck/org-confirm-babel-evaluate)
)



;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-async-init-file
   "/Users/benedikt.terhechte/.emacs.d/layers/+emacs/org/local/org-async-init.el" t)
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(package-selected-packages
   (quote
    (haml-mode web-completion-data winum solarized-theme madhat2r-theme fuzzy swift-mode powerline popwin pcre2el spinner alert log4e gntp markdown-mode hydra parent-mode projectile request gitignore-mode pos-tip flycheck pkg-info epl flx magit magit-popup git-commit with-editor smartparens iedit anzu evil goto-chg undo-tree eval-sexp-fu highlight org f s diminish autothemer company bind-map bind-key yasnippet packed dash helm avy helm-core async auto-complete popup package-build epresent define-word zonokai-theme zenburn-theme zen-and-art-theme yapfify ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme toxi-theme toc-org tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit switch-window sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacemacs-theme spaceline spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle slim-mode seti-theme scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe reverse-theme reveal-in-osx-finder restclient restart-emacs rbenv rake rainbow-delimiters railscasts-theme quelpa pyvenv pytest pyenv-mode py-isort purple-haze-theme pug-mode professional-theme planet-theme pip-requirements phoenix-dark-pink-theme phoenix-dark-mono-theme persp-mode pbcopy pastels-on-dark-theme paradox osx-trash osx-dictionary orgit organic-green-theme org-projectile org-present org-pomodoro org-plus-contrib org-download org-bullets open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme nlinum-relative niflheim-theme neotree naquadah-theme mustang-theme move-text monokai-theme monochrome-theme molokai-theme moe-theme mmm-mode minitest minimal-theme material-theme markdown-toc majapahit-theme magit-gitflow macrostep lush-theme lorem-ipsum livid-mode live-py-mode linum-relative link-hint light-soap-theme less-css-mode launchctl json-mode js2-refactor js-doc jbeans-theme jazz-theme ir-black-theme inkpot-theme info+ indent-guide ido-vertical-mode hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt heroku-theme hemisu-theme help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-gitignore helm-flx helm-descbinds helm-dash helm-css-scss helm-company helm-c-yasnippet helm-ag hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate golden-ratio gnuplot gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md gandalf-theme flycheck-pos-tip flx-ido flatui-theme flatland-theme firebelly-theme fill-column-indicator farmhouse-theme fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu espresso-theme emoji-cheat-sheet-plus emmet-mode elisp-slime-nav dumb-jump dracula-theme django-theme deft dash-at-point darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme d-mode cython-mode cyberpunk-theme company-web company-tern company-statistics company-emoji company-dcd company-anaconda column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized coffee-mode clues-theme clojure-snippets clj-refactor clean-aindent-mode cider-eval-sexp-fu chruby cherry-blossom-theme busybee-theme bundler bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-highlight-symbol auto-compile apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes aggressive-indent afternoon-theme adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell ac-dabbrev))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
