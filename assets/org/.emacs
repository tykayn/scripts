;; -*- lexical-binding: t; -*-

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

    ;; straight el bootstrap https://github.com/raxod502/straight.el#getting-started
     (defvar bootstrap-version)
     (let ((bootstrap-file
            (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
           (bootstrap-version 5))
       (unless (file-exists-p bootstrap-file)
         (with-current-buffer
             (url-retrieve-synchronously
              "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
              'silent 'inhibit-cookies)
           (goto-char (point-max))
           (eval-print-last-sexp)))
       (load bootstrap-file nil 'nomessage))

     (straight-use-package 'use-package)
     (setq straight-use-package-by-default t)
     (use-package org)


     (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(set-default-coding-systems 'utf-8)

(org-babel-load-file "~/Nextcloud/textes/orgmode/config.org")
(server-start)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
