# Prompt
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

# Aliases
set-alias open start
set-alias ll ls

function touch($file) {
  ni -type file -path $file
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

# Powershell起動時にEmacsDaemonを立ち上げる
estart

# フォルダかどうか判定する
function Test-Dir {
  param(
      $path
  )
  return (Test-Path -PathType Container $path)
}

# HTTPサーバーを起動する。
$HttpServer = Resolve-Path $PROFILE/../HttpServer.ps1
function Start-Server {
  start powershell -ArgumentList $HttpServer
}
