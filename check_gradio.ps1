param (
    [string]$ServerUrl
)

while ($true) {
    try {
        $response = Invoke-WebRequest -Uri $ServerUrl -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            exit 0
        }
    } catch {
        Start-Sleep -Seconds 2
    }
}