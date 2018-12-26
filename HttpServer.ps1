param(
    $Port=8000,
    [switch] $Open=$False
)

function Test-Dir {
  param(
      $path
  )
  return (Test-Path -PathType Container $path)
}


function Test-Should-Add-Slash {
  param(
      $fullPath,
      $localUrl
  )
  return ((Test-Dir $fullPath) -and ($localUrl[$localUrl.length - 1] -ne "/"))
}

$parentPath = $pwd.path
$url = "http://localhost:$Port/";

try {
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($url)
    $listener.Start()
    Write-Host "Start $url"

    if ($Open) {
      start $url
    }

    while($True) {
        $context = $listener.GetContext()
        $requestUrl = $context.Request.Url
        $response = $context.Response

        $fullPath = Join-Path $parentPath $requestUrl.LocalPath

        if (Test-Should-Add-Slash $fullPath $requestUrl.LocalPath) {
            $response.Redirect($requestUrl.AbsolutePath + "/")
            $response.Close()
            continue
        }

        if (Test-Dir $fullPath) {
            $fullPath = Join-Path  $fullPath "index.html"
        }

        if([IO.File]::Exists($fullPath)) {
            if ($fullpath -match '\.m?js$') {
              $response.addHeader("Content-Type", "text/javascript")
            }

            $buffer = [IO.File]::ReadAllBytes($fullPath)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)

        } else {
            $response.StatusCode = 404
        }

        Write-Host $response.StatusCode $requestUrl.LocalPath

        $response.Close()
    }
} finally {
    $listener.Stop()
}
