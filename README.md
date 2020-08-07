# best-ffmpeg-arguments

FFmpegの各エンコーダで最も品質の良いパラメータを見つけるスクリプトとその結果  
手作業では埒が明かないので`AutoVMAF.ps1`で自動化した

## テスト環境

hevc_nvenc, h264_nvenc, h264_qsv

- Intel Core i7 8700
    - Intel UHD Graphics 630

- NVIDIA GeForce RTX 2080
    - NVIDIA Studio Driver 451.77

- Windows 10 2004
    - FFmpeg version 4.3.1
    - FFmpeg version 20200806-2c35797  
    https://ffmpeg.zeranoe.com/builds/
