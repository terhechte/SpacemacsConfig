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
;; We're overwriting it right now, as defadvice seems to not work
(defun dnd-open-local-file (uri _action)
  (let* ((f (dnd-get-local-file-name uri t)))
    (if (and f (file-readable-p f))
      (find-file-other-frame f)
      (error "Can not read %s" uri))))

;; This doesn't work right now...
;(defadvice mac-ae-open-documents (around my-mac-ae-open-documents)
;  "Temporarily replace `dnd-open-local-file`"
;  (progn
;    (advice-add 'dnd-open-local-file :override #'my-dnd-open-local-file)
;    ad-do-it
;    ;(advice-remove 'dnd-open-local-file #'my-dnd-open-local-file)
;    ))

;; This is *awesome*
;; This replaces evils `insert mode` with native emacs mode, which has
;; all the bells and whistles one can hope for in insert state.
;; It also maps escape to leave insert mode
;(defalias 'evil-insert-state 'evil-emacs-state)
;(define-key evil-emacs-state-map [escape] 'evil-force-normal-state)

;; *This* on the other hand adds logic to the main C-g exit entrypoint
;; to leave insert  mode instead iff we're in evil and iff we're in
;; emacs-mode *or* insert-mode.
;; Since this is called at the utmost priority, this now will always
;; leave insert mode before doing anything crazy.
;(defadvice keyboard-escape-quit (around my-keyboard-escape-quit activate)
 ;j (let (orig-one-window-p)
;    (when (and (bound-and-true-p evil-mode)
 ;           (or (evil-insert-state-p)
;              (evil-emacs-state-p)))
;      (evil-force-normal-state))
;    (unwind-protect
;      ad-do-it
;      )))


;; Fixing something which was changed in an earlier org-commit:
;; http://orgmode.org/cgit.cgi/org-mode.git/commit/?id=f8b42e8
;; FIXME: Move to a different file



(defun xcode-open()
  (interactive)
  (let ((filename (buffer-file-name)))
    (call-process "/bin/bash" nil t nil "-c" (format "open -a Xcode %s" filename))))


;(print (font-family-list))
;(set-face-font 'default "M+ 1mn-14")
;; Interesting, it seems fira mono is the *fastest* font for Emacs on OSX
(set-face-font 'default "Fira Mono-12")
(set-face-font 'variable-pitch "Helvetica Neue-14")
(copy-face 'default 'fixed-pitch)



;(defun org-use-white-theme ()
;  (interactive)
;  ;; have to use this: https://github.com/vic/color-theme-buffer-local/blob/master/load-theme-buffer-local.el
;  (load-theme-buffer-local)
;  )


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
d
       ruby
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
       ;; shell
       syntax-checking
       osx

       ;; Add support for my most used languages
       clojure
       python
       dash ; todo, create a keybinding for dash-at-point
       javascript
       html

       ;; better linum https://github.com/CodeFalling/nlinum-relative
       ;nlinum

       ;; http://jblevins.org/projects/deft/
       deft

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
     ;swift-mode
     ac-dabbrev
     dabbrev
     simpleclip
     restclient
      nlinum-relative
      epresent
;FXBACK
;     company-mode
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
   dotspacemacs-default-font '("Fira Mono"
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

  )

(defun dotspacemacs/user-config ()
  "Configuration function.
 This function is called at the very end of Spacemacs initialization after
layers configuration."

  (setq magit-repository-directories '( "~/Development/monorepi" "~/Development/Swift/Performance" ))

(require 'swift-mode)

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


  ;; Open new files (dropped onto emacs) in a new frame/window
  (setq ns-pop-up-frames t)

;; Tell Magit to fill the whole buffer when opening
(setq magit-display-buffer-function
  #'magit-display-buffer-fullframe-status-v1)


;; nlinum
(require 'nlinum-relative)
(nlinum-relative-setup-evil)                    ;; setup for evil
(add-hook 'prog-mode-hook 'nlinum-relative-mode)
(setq nlinum-relative-redisplay-delay 0)      ;; delay
(setq nlinum-relative-current-symbol "->")      ;; or "" for display current line number
(setq nlinum-relative-offset 0)

  ;; evil & spacemcas key sequence for exit
  ;(setq-default evil-escape-key-sequence "jk")

  ;; emacs key sequence for exit
  ;(require 'key-chord)
  ;(key-chord-mode 1)
  ;(key-chord-define-global "jk" 'evil-escape)
  ;; more examples in custom/key-chords.el

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

  ;(setq deft-directory "~/Dropbox/org")
  ;(setq deft-recursive t)

  ;; Visual Line Mode
  ;(global-visual-line-mode)

  ;; enable flycheck for swift
  ;; disable for now, flycheck doesn't work yet with complex projects
  ;; (i.e. frameworks, etc)
  ;;(add-to-list 'flycheck-checkers 'swift)

  ;; mouse-2 will be Option+Click and mouse-3 will be Cmd+Click
  (setq mac-emulate-three-button-mouse t)

  ;(linum-relative-global-mode)

  ;; Load Swift Org Mode and customize the org mode languages
  ;; 
  ;;Since version 0.104, spacemacs uses the =org= version from the org ELPA
  ;;repository instead of the one shipped with emacs. Then, any =org= related code
  ;;should not be loaded before =dotspacemacs/user-config=, otherwise both versions
  ;;will be loaded and will conflict.
  (with-eval-after-load 'org
    (require 'ob-swift)

    ;(org-setup-fonts-colors)

    (org-babel-do-load-languages
      'org-babel-load-languages
      ;;'((ditaa . t)(python . t)(sh . t)(R . t)(C . t)(clojure . t)(lisp . t) (sql . t) (js . t)  (emacs-lisp . t) (css . t) (swift . t) )) 
    '((python . t)(sh . t)(lisp . t) (sql . t) (js . t)  (emacs-lisp . t) (css . t) (swift . t) ))

    ;; fontification in source blocks
    (setq org-src-fontify-natively t)
    ;; add swift-mode to fontification
    (add-to-list 'org-src-lang-modes (cons "swift" 'swift)))

  ;;To install Github related extensions like [[https://github.com/larstvei/ox-gfm][ox-gfm]] to export to Github
  ;;flavored markdown set the variable =org-enable-github-support= to =t=.
  

  ;; C-' to enter source block edit mode!

  ;; Yasnippet for company
  (require 'yasnippet)
  (yas-global-mode 1)

  ;; Swift Company Mode
 (setq exec-path (append exec-path '("/usr/local/bin/sourcekittendaemon")))
  (require 'company-sourcekit)
  (add-to-list 'company-backends 'company-sourcekit)

;FXBACk
;  (add-hook 'swift-mode-hook (lambda ()
;                               (set (make-local-variable 'company-backends) '(company-sourcekit))
;                               (company-mode)))

  ;; Flyspell hampers my C-g quit binding to leave insert mode
  ;; setting flyspell to do its thing with a delay via flyspell-lazy
  ;; seems to fix this
  (require 'flyspell-lazy)
  (flyspell-lazy-mode 1)

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
  ;(setq org-agenda-files '("~/Dropbox/org/"))
)



;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(org-export-async-init-file
     "/Users/benedikt.terhechte/.emacs.d/layers/+emacs/org/local/org-async-init.el")
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
  '(package-selected-packages
     (quote
       (epresent define-word zonokai-theme zenburn-theme zen-and-art-theme yapfify ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme toxi-theme toc-org tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit switch-window sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacemacs-theme spaceline spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle slim-mode simpleclip seti-theme scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe reverse-theme reveal-in-osx-finder restclient restart-emacs rbenv rake rainbow-delimiters railscasts-theme quelpa pyvenv pytest pyenv-mode py-isort purple-haze-theme pug-mode professional-theme planet-theme pip-requirements phoenix-dark-pink-theme phoenix-dark-mono-theme persp-mode pbcopy pastels-on-dark-theme paradox osx-trash osx-dictionary orgit organic-green-theme org-projectile org-present org-pomodoro org-plus-contrib org-download org-bullets open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme nlinum-relative niflheim-theme neotree naquadah-theme mustang-theme move-text monokai-theme monochrome-theme molokai-theme moe-theme mmm-mode minitest minimal-theme material-theme markdown-toc majapahit-theme magit-gitflow macrostep lush-theme lorem-ipsum livid-mode live-py-mode linum-relative link-hint light-soap-theme less-css-mode launchctl json-mode js2-refactor js-doc jbeans-theme jazz-theme ir-black-theme inkpot-theme info+ indent-guide ido-vertical-mode hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt heroku-theme hemisu-theme help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-gitignore helm-flx helm-descbinds helm-dash helm-css-scss helm-company helm-c-yasnippet helm-ag hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme google-translate golden-ratio gnuplot gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md gandalf-theme flycheck-pos-tip flx-ido flatui-theme flatland-theme firebelly-theme fill-column-indicator farmhouse-theme fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu espresso-theme emoji-cheat-sheet-plus emmet-mode elisp-slime-nav dumb-jump dracula-theme django-theme deft dash-at-point darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme d-mode cython-mode cyberpunk-theme company-web company-tern company-statistics company-emoji company-dcd company-anaconda column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized coffee-mode clues-theme clojure-snippets clj-refactor clean-aindent-mode cider-eval-sexp-fu chruby cherry-blossom-theme busybee-theme bundler bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-highlight-symbol auto-compile apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes aggressive-indent afternoon-theme adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell ac-dabbrev))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
