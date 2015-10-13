
;;; 初期フレームの設定
(setq default-frame-alist
      (append (list '(width . 120)
		    '(height . 45)
 		    '(top . 0)
 		    '(left . 100))
 	      default-frame-alist))

;;; Window を透過させる
(set-frame-parameter nil 'alpha 90)

;;; ファイルを開いている時はタイトルにファイル名を表示
(setq frame-title-format '(:eval (if (buffer-file-name)
      (format "%s - Emacs@%s" (buffer-file-name) (system-name))
      (format "Emacs@%s" (system-name)))))

;;; font-lockの設定
(global-font-lock-mode t)

;;; リージョンをハイライトする
(transient-mark-mode t)

;;; 対応する括弧をハイライトする
(show-paren-mode t)

;;; 括弧のハイライトの設定
(setq show-paren-style 'mixed)

;;; ツールバーを消す
(tool-bar-mode -1)

;;; 画像ファイルを表示
(auto-image-file-mode t)

;; ファイルサイズを表示
(size-indication-mode t)

;;; 行末のスペースを強調表示
(setq-default show-trailing-whitespace t)

;;; 行末のスペースを強調表示しないモードを列挙
(defconst ignore-show-trailing-whitespace-mode-alist
  '(eww-mode
    term-mode
    eshell-mode))

;;; 行末のスペースの強調表示を無効化
(mapc
 (lambda (arg)
   (add-hook (intern (concat (symbol-name arg) "-hook"))
             '(lambda ()
                (setq show-trailing-whitespace nil))))
 ignore-show-trailing-whitespace-mode-alist)

;;; カーソルの設定, 30秒操作しなければカーソルをブリンクさせる.
(set-cursor-color "#81878e")
(setq blink-cursor-interval 0.5)
(setq blink-cursor-delay 30.0)
(blink-cursor-mode t)
;;(blink-cursor-mode nil)

;;; モード行の設定
(line-number-mode t)
(column-number-mode t)
(display-time)

;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
	      (count-lines (region-beginning) (region-end))
	      (- (region-end) (region-beginning)))
    ""))
(add-to-list 'default-mode-line-format
	     '(:eval (count-lines-and-chars)))

;; 入力されるキーシーケンスを置き換える
;; ?\C-?はDELのキーシーケンス
(keyboard-translate ?\C-h ?\C-?)

;; Mac OSXの場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; font
(set-face-attribute 'default nil :family "Monaco")
(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0208
                  (font-spec :family "Hiragino Kaku Gothic ProN"))
(add-to-list 'face-font-rescale-alist
             '(".*Hiragino Kaku Gothic ProN.*" . 1.2))

;; undo setting
(setq-default undo-no-redo t
              undo-limit 600000
              undo-strong-limit 900000)

;;;; undo-tree
(global-undo-tree-mode)
(define-key undo-tree-map (kbd "C-/") 'undo-tree-undo)
(define-key undo-tree-map (kbd "M-_") 'nil)
