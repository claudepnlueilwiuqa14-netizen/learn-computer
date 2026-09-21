param(
    [Parameter(Mandatory = $true)][string]$InputJson,
    [Parameter(Mandatory = $true)][string]$OutputWav,
    [switch]$Play,
    [string]$SegmentsDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Speech
$lesson = Get-Content -Raw -Encoding utf8 $InputJson | ConvertFrom-Json
$outputPath = [IO.Path]::GetFullPath($OutputWav)
$outputDir = Split-Path -Parent $outputPath
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
$tempDir = Join-Path ([IO.Path]::GetTempPath()) ("voice-lesson-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

try {
    $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $voices = @($synth.GetInstalledVoices() | ForEach-Object { $_.VoiceInfo })
    $english = $voices | Where-Object { $_.Culture.Name -eq 'en-US' } | Select-Object -First 1
    $chinese = $voices | Where-Object { $_.Culture.Name -eq 'zh-CN' } | Where-Object { $_.Name -match 'Kangkang|Yunyang|Huihui' } | Select-Object -First 1
    if (-not $english) { throw '本机没有可用的英语系统语音' }
    if (-not $chinese) { throw '本机没有可用的中文系统语音' }

    $parts = [System.Collections.Generic.List[string]]::new()
    $index = 0
    foreach ($turn in $lesson.turns) {
        $index++
        $part = Join-Path $tempDir ("{0:D3}.wav" -f $index)
        $voice = if ($turn.language -eq 'en') { $english } elseif ($turn.language -eq 'zh') { $chinese } else { throw "不支持的语言：$($turn.language)" }
        $synth.SelectVoice($voice.Name)
        $synth.Rate = if ($turn.language -eq 'en') { -1 } else { 0 }
        $synth.SetOutputToWaveFile($part)
        $synth.Speak([string]$turn.text)
        $synth.SetOutputToNull()
        if ($SegmentsDir) {
            $segmentDirPath = [IO.Path]::GetFullPath($SegmentsDir)
            New-Item -ItemType Directory -Force -Path $segmentDirPath | Out-Null
            Copy-Item -LiteralPath $part -Destination (Join-Path $segmentDirPath ([IO.Path]::GetFileName($part))) -Force
        }
        $parts.Add($part)
    }
    $synth.Dispose()

    $ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if (-not $ffmpeg) { throw '找不到 ffmpeg，无法合并音频片段' }
    $concat = Join-Path $tempDir 'concat.txt'
    ($parts | ForEach-Object { "file '$($_ -replace "'", "'\\''")'" }) | Set-Content -LiteralPath $concat -Encoding utf8
    & $ffmpeg.Source -y -f concat -safe 0 -i $concat -c copy $outputPath 2>$null
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $outputPath -PathType Leaf)) { throw 'ffmpeg 合并音频失败' }
    Write-Output "Generated: $outputPath"
    Write-Output "English voice: $($english.Name) (local fallback; not en-GB)"
    Write-Output "Chinese voice: $($chinese.Name)"
    if ($SegmentsDir) { Write-Output "Segments: $([IO.Path]::GetFullPath($SegmentsDir))" }
    if ($Play) {
        Start-Process -FilePath $outputPath
        Write-Output 'Playback started.'
    }
}
finally {
    if (Test-Path -LiteralPath $tempDir) { Remove-Item -LiteralPath $tempDir -Recurse -Force }
}
