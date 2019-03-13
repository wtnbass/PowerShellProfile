# Prompt
function global:prompt() {
  $status = $?

  Write-Host $pwd.path -NoNewline -ForegroundColor Yellow

  $svninfo = Get-Subversion-Info
  if ($svninfo -ne $null) {
    $branch = $svninfo.Branch
    $rev = $svninfo.Revision
    Write-Host " (${branch} rev:${rev})" -NoNewline -ForegroundColor Magenta
  }

  # Newline
  Write-Host ""

  if (!$status) {
    Write-Host "X "  -NoNewline -ForegroundColor Red
  }
  Write-Host (Get-Date).ToShortTimeString() -NoNewline
  return "> "
}

# Subversionの情報
function Get-Subversion-Info {
  $info = svn info 2> $null
  if ($info -eq $null) {
    return $null
  }

  $hash = @{}

  foreach($line in $info) {
    $pos = $line.IndexOf(":")
    if ($pos -lt 0) {
      continue;
    }
    $name = $line.SubString(0, $pos).replace(" ", "").trim()
    $value = $line.SubString($pos + 1).trim()

    if ($name -eq "LastChangedDate") {
      $pos = $value.IndexOf("(")
      $value = Get-Date($value.SubString(0, $pos))
    }
    $hash[$name] = $value
  }

  $url = $hash["URL"]
  $branch = "trunk"
  if ($url.IndexOf("branches") -gt -1) {
    $p1 = $url.IndexOf("branches")
    $p2 = $url.IndexOf("/", $p1 + 9)
    if ($p2 -eq -1) {
      $p2 = $url.length
    }
    $branch = $url.SubString($p1, $p2 - $p1)
  }
  $hash["Branch"] = $branch

  return New-Object -TypeName PSObject -Property $hash
}

# HTTPサーバーを起動する。
$HttpServer = Resolve-Path $PROFILE/../HttpServer.ps1
function Start-Server {
  start powershell -ArgumentList $HttpServer
}

# DuckDuckGoで検索する。
function Search-With-DuckDuckGo {
  $query = $args -Join "+"
  start https://duckduckgo.com/?q=$query
}

# Aliases
set-alias open start
set-alias ll ls
set-alias ddg Search-With-DuckDuckGo

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
