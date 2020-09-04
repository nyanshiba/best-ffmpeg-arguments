#requires -version 7

param
(
    [parameter(mandatory)]
    [String]$Test
)

$Settings =
@{
    LogsDir = "./logs"
    InputFileName = "200808.avi"
    FilePath = "ffmpeg"
    DefaultArgument =
    ({
        "-y -nostats -analyzeduration 30M -probesize 100M -fflags +discardcorrupt -i $($Settings.InputFileName) -an $_ -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4"
    })
    TestArguments =
    @{
        # h264_nvenc
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
Start-Transcript -LiteralPath "$($Settings.LogsDir)/${Test}_$($Settings.InputFileName).log" -UseMinimalHeader

# スクリプトに渡された引数に一致するテストを実行
$Settings.TestArguments.$Test | ForEach-Object {

    # encode
    Invoke-Process -File $Settings.FilePath -Arg (Invoke-Command -ScriptBlock $Settings.DefaultArgument)

    # ssim
    # Invoke-Process -File $Settings.FilePath -Arg "-y -nostats -i $($Settings.InputFileName) -i output.mp4 -filter_complex ssim -an -f null -"

    # vmaf
    Invoke-Process -File $Settings.FilePath -Arg "-y -nostats -i output.mp4 -i $($Settings.InputFileName) -filter_complex libvmaf=vmaf_v0.6.1.pkl -an -f null -"

    # file size
    "$([math]::round((Get-ChildItem -LiteralPath output.mp4).Length/1MB,2))MB"
}

# ログ取り停止
Stop-Transcript
