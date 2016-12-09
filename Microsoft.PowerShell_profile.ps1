# Emacs daemonを起動する。
function estart() {
  start-job -ScriptBlock { emacs --daemon }
}

# Emacs daemonを終了する。
function ekill() {
  emacsclient -e '(kill-emacs)'
}

# Emacsclientを起動する。
function e($path) {
  emacsclient -c $path
}

set-alias open start
set-alias ie 'C:\Program Files\Internet Explorer\iexplore.exe'

function touch($file) {
  ni -type file -path $file
}

# Powershell起動時にEmacsDaemonを立ち上げる
estart