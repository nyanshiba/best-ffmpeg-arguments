#requires -version 7

param
(
    [parameter(mandatory)]
    [String]$Test
)

$Settings =
@{
    LogsDir = "./logs"
    FilePath = "ffmpeg"
    DefaultArgument =
    ({
        "-y -nostats -analyzeduration 30M -probesize 100M -fflags +discardcorrupt -i input.mp4 -an $_ -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4"
    })
    TestArguments =
    @{
        # hevc_nvenc
        # 手始めにrefsが効いてるのか検証
        "hevcnvenc_refs" =
        @(
            "-c:v hevc_nvenc -preset:v slow -profile:v main10 -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v slow -profile:v main10 -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -refs 4 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v slow -profile:v main10 -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -refs 6 -pix_fmt yuv420p10le"
            # 効いていなかった
        )
        # FFmpeg 4.3.1から新しく追加されたpresetを試す
        "hevcnvenc_preset" =
        @(
            "-c:v hevc_nvenc -preset:v medium",
            "-c:v hevc_nvenc -preset:v p4",
            "-c:v hevc_nvenc -preset:v slow",
            "-c:v hevc_nvenc -preset:v p5",
            "-c:v hevc_nvenc -preset:v p6",
            "-c:v hevc_nvenc -preset:v p7"
            # 4.3.1では動かないが、20200806-2c35797では動いた
            # 違いが分からない
        )
        "hevcnvenc_preset_2" =
        @(
            "-c:v hevc_nvenc -preset:v slow -profile:v main10 -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v p5 -profile:v main10 -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # VMAFの値はp5 < slow < p7で、少ししか変わらなかった
        )
    }
}

function Invoke-Process
{
    param
    (
        [String]$File,
        [String]$Arg,
        [String[]]$ArgList
    )

    "DEBUG Invoke-Process`nFile: $File`nArg: $Arg`nArgList: $ArgList`n"

    #cf. https://github.com/guitarrapc/PowerShellUtil/blob/master/Invoke-Process/Invoke-Process.ps1 

    # new Process
    $ps = New-Object System.Diagnostics.Process
    $ps.StartInfo.UseShellExecute = $False
    $ps.StartInfo.RedirectStandardInput = $False
    $ps.StartInfo.RedirectStandardOutput = $True
    $ps.StartInfo.RedirectStandardError = $True
    $ps.StartInfo.CreateNoWindow = $True
    $ps.StartInfo.Filename = $File
    if ($Arg)
    {
        #Windows
        $ps.StartInfo.Arguments = $Arg
    } elseif ($ArgList)
    {
        #Linux
        $ArgList | ForEach-Object {
            $ps.StartInfo.ArgumentList.Add("$_")
        }
    }

    # Event Handler for Output
    $stdSb = New-Object -TypeName System.Text.StringBuilder
    $errorSb = New-Object -TypeName System.Text.StringBuilder
    $scripBlock = 
    {
        <#$x = $Event.SourceEventArgs.Data
        if (-not [String]::IsNullOrEmpty($x))
        {
            [System.Console]::WriteLine($x)
            $Event.MessageData.AppendLine($x)
        }#>
        if (-not [String]::IsNullOrEmpty($EventArgs.Data))
        {
                    
            $Event.MessageData.AppendLine($Event.SourceEventArgs.Data)
        }
    }
    $stdEvent = Register-ObjectEvent -InputObject $ps -EventName OutputDataReceived -Action $scripBlock -MessageData $stdSb
    $errorEvent = Register-ObjectEvent -InputObject $ps -EventName ErrorDataReceived -Action $scripBlock -MessageData $errorSb

    # execution
    $Null = $ps.Start()
    $ps.BeginOutputReadLine()
    $ps.BeginErrorReadLine()

    # wait for complete
    $ps.WaitForExit()
    $ps.CancelOutputRead()
    $ps.CancelErrorRead()

    # verbose Event Result
    $stdEvent, $errorEvent | Out-String -Stream | Write-Verbose

    # Unregister Event to recieve Asynchronous Event output (You should call before process.Dispose())
    Unregister-Event -SourceIdentifier $stdEvent.Name
    Unregister-Event -SourceIdentifier $errorEvent.Name

    # verbose Event Result
    $stdEvent, $errorEvent | Out-String -Stream | Write-Verbose

    # Get Process result
    $stdSb.ToString().Trim()
    $errorSb.ToString().Trim()
    "DEBUG ExitCode: $($ps.ExitCode)"
    [Array]$script:ExitCode += $ps.ExitCode

    if ($Null -ne $process)
    {
        $ps.Dispose()
    }
    if ($Null -ne $stdEvent)
    {
        $stdEvent.StopJob()
        $stdEvent.Dispose()
    }
    if ($Null -ne $errorEvent)
    {
        $errorEvent.StopJob()
        $errorEvent.Dispose()
    }
}

# ログ取り開始
Start-Transcript -LiteralPath "$($Settings.LogsDir)/$Test.log" -UseMinimalHeader

# スクリプトに渡された引数に一致するテストを実行
$Settings.TestArguments.$Test | ForEach-Object {

    # encode
    Invoke-Process -File $Settings.FilePath -Arg (Invoke-Command -ScriptBlock $Settings.DefaultArgument)

    # ssim
    Invoke-Process -File $Settings.FilePath -Arg "-y -nostats i input.mp4 -i output.mp4 -filter_complex ssim -an -f null -"

    # file size
    "$([math]::round((Get-ChildItem -LiteralPath output.mp4).Length/1MB,1))MB"
}

# ログ取り停止
Stop-Transcript
