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
(eval-after-load "ooorg-mode" ; we've disable it for now
'(progn
  (defface org-block-background '((t ()))
    "Face used for the source block background")

  (defun org-fontify-meta-lines-and-blocks-1 (limit)
    "Fontify #+ lines and blocks."
    (let ((case-fold-search t))
      (if (re-search-forward
            "^\\([ \t]*#\\(\\(\\+[a-zA-Z]+:?\\| \\|$\\)\\(_\\([a-zA-Z]+\\)\\)?\\)[ \t]*\\(\\([^ \t\n]*\\)[ \t]*\\(.*\\)\\)\\)"
            limit t)
        (let ((beg (match-beginning 0))
               (block-start (match-end 0))
               (block-end nil)
               (lang (match-string 7))
               (beg1 (line-beginning-position 2))
               (dc1 (downcase (match-string 2)))
               (dc3 (downcase (match-string 3)))
               end end1 quoting block-type ovl)
          (cond
            ((member dc1 '("+html:" "+ascii:" "+latex:"))
              ;; a single line of backend-specific content
              (org-remove-flyspell-overlays-in (match-beginning 0) (match-end 0))
              (remove-text-properties (match-beginning 0) (match-end 0)
                '(display t invisible t intangible t))
              (add-text-properties (match-beginning 1) (match-end 3)
                '(font-lock-fontified t face org-meta-line))
              (add-text-properties (match-beginning 6) (+ (match-end 6) 1)
                '(font-lock-fontified t face org-block))
                                        ; for backend-specific code
              t)
            ((and (match-end 4) (equal dc3 "+begin"))
              ;; Truly a block
              (setq block-type (downcase (match-string 5))
                quoting (member block-type org-protecting-blocks))
              (when (re-search-forward
                      (concat "^[ \t]*#\\+end" (match-string 4) "\\>.*")
                      nil t)  ;; on purpose, we look further than LIMIT
                (setq end (min (point-max) (match-end 0))
                  end1 (min (point-max) (1- (match-beginning 0))))
                (setq block-end (match-beginning 0))
                (when quoting
                  (org-remove-flyspell-overlays-in beg1 end1)
                  (remove-text-properties beg end
                    '(display t invisible t intangible t)))
                (add-text-properties
                  beg end '(font-lock-fontified t font-lock-multiline t))
                (add-text-properties beg beg1 '(face org-meta-line))
                (org-remove-flyspell-overlays-in beg beg1)
                (add-text-properties	; For end_src
                  end1 (min (point-max) (1+ end)) '(face org-meta-line))
                (org-remove-flyspell-overlays-in end1 end)
                (cond
                  ((and lang (not (string= lang "")) org-src-fontify-natively)
                    (org-src-font-lock-fontify-block lang block-start block-end)

                    ;;--
                    ;; remove old background overlays
                    (mapc (lambda (ov)
                            (if (eq (overlay-get ov 'face) 'org-block-background)
                              (delete-overlay ov)))
                      (overlays-at (/ (+ beg1 block-end) 2)))
                    ;; add a background overlay
                    (setq ovl (make-overlay beg1 block-end))
                    (overlay-put ovl 'face 'org-block-background)
                    (overlay-put ovl 'evaporate t)) ; make it go away when empty

                                        ;(add-text-properties beg1 block-end '(src-block t)))
                  ;;--
                  (quoting
                    (add-text-properties beg1 (min (point-max) (1+ end1))
                      '(face org-block))) ; end of source block
                  ((not org-fontify-quote-and-verse-blocks))
                  ((string= block-type "quote")
                    (add-text-properties beg1 (min (point-max) (1+ end1)) '(face org-quote)))
                  ((string= block-type "verse")
                    (add-text-properties beg1 (min (point-max) (1+ end1)) '(face org-verse))))
                (add-text-properties beg beg1 '(face org-block-begin-line))
                (add-text-properties (min (point-max) (1+ end)) (min (point-max) (1+ end1))
                  '(face org-block-end-line))
                t))
            ((member dc1 '("+title:" "+author:" "+email:" "+date:"))
              (org-remove-flyspell-overlays-in
                (match-beginning 0)
                (if (equal "+title:" dc1) (match-end 2) (match-end 0)))
              (add-text-properties
                beg (match-end 3)
                (if (member (intern (substring dc1 1 -1)) org-hidden-keywords)
                  '(font-lock-fontified t invisible t)
                  '(font-lock-fontified t face org-document-info-keyword)))
              (add-text-properties
                (match-beginning 6) (min (point-max) (1+ (match-end 6)))
                (if (string-equal dc1 "+title:")
                  '(font-lock-fontified t face org-document-title)
                  '(font-lock-fontified t face org-document-info))))
            ((or (equal dc1 "+results")
               (member dc1 '("+begin:" "+end:" "+caption:" "+label:"
                              "+orgtbl:" "+tblfm:" "+tblname:" "+results:"
                              "+call:" "+header:" "+headers:" "+name:"))
               (and (match-end 4) (equal dc3 "+attr")))
              (org-remove-flyspell-overlays-in
                (match-beginning 0)
                (if (equal "+caption:" dc1) (match-end 2) (match-end 0)))
              (add-text-properties
                beg (match-end 0)
                '(font-lock-fontified t face org-meta-line))
              t)
            ((member dc3 '(" " ""))
              (org-remove-flyspell-overlays-in beg (match-end 0))
              (add-text-properties
                beg (match-end 0)
                '(font-lock-fontified t face font-lock-comment-face)))
            (t ;; just any other in-buffer setting, but not indented
              (org-remove-flyspell-overlays-in (match-beginning 0) (match-end 0))
              (add-text-properties
                beg (match-end 0)
                '(font-lock-fontified t face org-meta-line))
              t))))))

  (defun org-in-src-block-p (&optional inside)
    "Whether point is in a code source block.
When INSIDE is non-nil, don't consider we are within a src block
when point is at #+BEGIN_SRC or #+END_SRC."
    (let ((case-fold-search t) ov)

      (or (and (setq ov (overlays-at (point)))
            (memq 'org-block-background
              (overlay-properties (car ov))))
                                        ;(or (and (eq (get-char-property (point) 'src-block) t))

        (and (not inside)
          (save-match-data
            (save-excursion
              (beginning-of-line)
              (looking-at ".*#\\+\\(begin\\|end\\)_src")))))))

    (org-setup-fonts-colors)
))








;(print (font-family-list))
;(set-face-font 'default "M+ 1mn-14")
;; Interesting, it seems fira mono is the *fastest* font for Emacs on OSX
(set-face-font 'default "Fira Mono-12")
(set-face-font 'variable-pitch "Helvetica Neue-14")
(copy-face 'default 'fixed-pitch)

(defun org-setup-fonts-colors ()
  (interactive)
  "Change org-mode variable pitch font with src to fixed pitch with black background"
  ;; disable the highlight line. In org we only need a cursor
  (hl-line-mode -1)
  ;; Also enable relative linum mode
  ;(linum-relative-mode)
  ;; whatever this does: http://stackoverflow.com/questions/28428382/how-to-manage-fonts-in-emacs
  (buffer-face-mode t)
  (variable-pitch-mode t)
  ;(setq original-color (face-background 'org-default))
  (setq line-spacing 0.3)
  (dolist
    (face '(org-table org-verbatim))
    (set-face-attribute face nil :family "Fira Mono-12"))
  ;(set-face-background 'org-block-background "black")
  ;(set-face-background 'org-block-end-line original-color)
  ;(set-face-background 'org-block-begin-line original-color)
  )

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

  (setq deft-directory "~/Dropbox/org")
  (setq deft-recursive t)

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
      '((ditaa . t)(python . t)(sh . t)(R . t)(C . t)(clojure . t)(lisp . t) (sql . t) (js . t)  (emacs-lisp . t) (css . t) (swift . t) )) 

    ;; fontification in source blocks
    (setq org-src-fontify-natively t)
    ;; add swift-mode to fontification
    (add-to-list 'org-src-lang-modes (cons "swift" 'swift)))

  ;;To install Github related extensions like [[https://github.com/larstvei/ox-gfm][ox-gfm]] to export to Github
  ;;flavored markdown set the variable =org-enable-github-support= to =t=.
  (setq-default dotspacemacs-configuration-layers '(
                                                     (org :variables
                                                       org-enable-github-support t)))

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
  (setq org-agenda-files '("~/Dropbox/org/"))
)



;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ns-use-native-fullscreen nil)
 '(package-selected-packages
   (quote
    (nlinum-relative nlinum ox-reveal zonokai-theme zen-and-art-theme underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme tao-theme tangotango-theme tango-plus-theme tango-2-theme sunny-day-theme sublime-themes subatomic256-theme subatomic-theme stekene-theme powerline spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme seti-theme reverse-theme railscasts-theme purple-haze-theme professional-theme phoenix-dark-pink-theme phoenix-dark-mono-theme pastels-on-dark-theme orgit organic-green-theme alert log4e gntp oldlace-theme occidental-theme obsidian-theme noctilux-theme niflheim-theme naquadah-theme mustang-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme lush-theme light-soap-theme json-snatcher json-reformat jbeans-theme ir-black-theme inkpot-theme parent-mode heroku-theme hemisu-theme hc-zenburn-theme haml-mode gruvbox-theme grandshell-theme gandalf-theme flx flatui-theme flatland-theme firebelly-theme farmhouse-theme smartparens iedit anzu espresso-theme dracula-theme django-theme darktooth-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme web-completion-data dash-functional pos-tip colorsarenice-theme color-theme-sanityinc-solarized clues-theme inflections edn paredit peg eval-sexp-fu highlight spinner queue pkg-info epl cherry-blossom-theme busybee-theme bubbleberry-theme birds-of-paradise-plus-theme packed apropospriate-theme anaconda-mode pythonic dash s ample-zen-theme ample-theme popup package-build bind-key bind-map toxi-theme py-yapf planet-theme omtose-phellack-theme majapahit-theme magit-gitflow js2-mode jazz-theme gruber-darker-theme gotham-theme evil-magit color-theme-sanityinc-tomorrow multiple-cursors cider clojure-mode badwolf-theme anti-zenburn-theme alect-themes auto-complete avy tern flycheck yasnippet company projectile helm helm-core markdown-mode async hydra f evil smeargle helm-gitignore request gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger magit magit-popup git-commit with-editor emoji-cheat-sheet-plus company-emoji zenburn-theme ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vi-tilde-fringe use-package toc-org tagedit switch-window swift-mode spacemacs-theme spaceline smooth-scrolling slim-mode simpleclip scss-mode sass-mode reveal-in-osx-finder restclient restart-emacs rainbow-delimiters quelpa pyvenv pytest pyenv-mode popwin pip-requirements persp-mode pcre2el pbcopy paradox page-break-lines osx-trash org-repo-todo org-present org-pomodoro org-plus-contrib org-bullets open-junk-file neotree move-text monokai-theme mmm-mode markdown-toc macrostep lorem-ipsum linum-relative leuven-theme less-css-mode launchctl json-mode js2-refactor js-doc jade-mode info+ indent-guide ido-vertical-mode hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-dash helm-css-scss helm-company helm-c-yasnippet helm-ag google-translate golden-ratio gnuplot gh-md flycheck-pos-tip flx-ido fill-column-indicator fancy-battery expand-region exec-path-from-shell evil-visualstar evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-jumper evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-args evil-anzu emmet-mode elisp-slime-nav deft define-word dash-at-point cython-mode company-web company-tern company-statistics company-quickhelp company-anaconda coffee-mode clj-refactor clean-aindent-mode cider-eval-sexp-fu buffer-move bracketed-paste auto-yasnippet auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell ac-dabbrev))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil)))))
