function global:prompt() {
  $p = $pwd.path.split("\\")
  $now = $p[$p.length - 1]
  if ($pwd.path -eq $home) {
    $now = "~"
  }
  if ($now -eq "") {
    $now = $p[0]
  }
  write-host $now -NoNewline -ForeGroundColor "Yellow"
  return " > "
}
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
  emacsclient -c $path -a "emacs"
}

set-alias open start
set-alias ie 'C:\Program Files\Internet Explorer\iexplore.exe'

function touch($file) {
  ni -type file -path $file
}

# Powershell起動時にEmacsDaemonを立ち上げる
estart