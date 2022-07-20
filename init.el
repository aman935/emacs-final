(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(require 'cl-lib)

;; Initialize root
(defvar se/config-root
  (file-name-directory load-file-name))

(defun se/start ()
  "Loads core and then conditionally loads configs."
  (cl-flet* ((start-basic ()
                          (se/load-file "modes/basic/misc")
                          (se/load-file "modes/basic/packages")
                          (se/load-file "modes/basic/key-bindings"))
             (start-standard ()
                             (se/load-file "modes/standard/misc")
                             (se/load-file "modes/standard/packages")
                             (se/load-file "modes/standard/key-bindings")))
    (load (expand-file-name "core"
			                se/config-root))
    (start-basic)
    (if (display-graphic-p)
        (start-standard))
    (se/print-startup-message)))

;; Start
(se/start)

(add-to-list 'load-path "~/.emacs.d/roam")
(require 'org-roam)
(put 'dired-find-alternate-file 'disabled nil)

   ;; Improve org mode looks
    (setq org-startup-indented t
          org-pretty-entities t
          org-hide-emphasis-markers t
          org-startup-with-inline-images t
          org-image-actual-width '(300))
  ;; Increase line spacing
  (setq-default line-spacing 6)

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/RoamNotes")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))
