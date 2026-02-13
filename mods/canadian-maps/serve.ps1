$arch = $env:PROCESSOR_ARCHITECTURE
$wow64 = $env:PROCESSOR_ARCHITEW6432

if ($wow64 -eq "AMD64" -or $arch -eq "AMD64") {
    Write-Host "x86_64 (64-bit)"
    .\Windows_arm64\pmtiles.exe serve .\map_tiles --port 24575 --cors=*
} elseif ($wow64 -eq "ARM64" -or $arch -eq "ARM64") {
    Write-Host "ARM64"
    .\Windows_x86_64\pmtiles.exe serve .\map_tiles --port 24575 --cors=*
} elseif ($arch -eq "x86") {
    Write-Host "x86 (32-bit)"
} else {
    Write-Host "Unknown architecture: $arch"
}