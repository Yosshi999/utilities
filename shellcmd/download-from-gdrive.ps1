Param(
	[String]$fileID,
	[String]$output
)

$uri = "https://drive.google.com/uc?export=download&id=$fileID"
Invoke-WebRequest -Uri $uri -SessionVariable mySession
$cookie = $($mySession.Cookies.GetCookies($uri) | Where-Object {$_.name.Contains("_warning_")})[0]
$name = $cookie.name
$code = $cookie.value

Write-Host "Downloading $output ..."
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "https://drive.google.com/uc?export=download&confirm=$code&id=$fileID" -WebSession $mySession -OutFile $output

# # slow??
# $request = [System.Net.HttpWebRequest]::Create("https://drive.google.com/uc?export=download&confirm=$code&id=$fileID")
# $request.Headers.Add([System.Net.HttpRequestHeader]::Cookie, "$name=$code")
# $response = $request.GetResponse()
# $responseStream = $response.GetResponseStream()
# $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $output, Create
# $buffer = New-Object byte[] 10MB
# $count = $responseStream.Read($buffer, 0, $buffer.Length)
# $downloadedBytes = $count

# while ($count -gt 0) {
# 	$targetStream.Write($buffer, 0, $count)
# 	$count = $responseStream.Read($buffer, 0, $buffer.Length)
# 	$downloadedBytes += $count
# 	Write-Progress -Activity "Downloading" -Status "$([System.Math]::Floor($downloadedBytes/1024/1024)) MB"
# }
# Write-Progress -Activity "Finished"
# $targetStream.Flush()
# $targetStream.Close()
# $targetStream.Dispose()
# $responseStream.Dispose()