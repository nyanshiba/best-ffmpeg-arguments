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

## hevc_nvenc constqp

```
ffmpeg version git-2020-08-06-2c35797 Copyright (c) 2000-2020 the FFmpeg developers
built with gcc 10.2.1 (GCC) 20200805
configuration: --disable-static --enable-shared --enable-gpl --enable-version3 --enable-sdl2 --enable-fontconfig --enable-gnutls --enable-iconv --enable-libass --enable-libdav1d --enable-libbluray --enable-libfreetype --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libopus --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libsrt --enable-libtheora --enable-libtwolame --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libzimg --enable-lzma --enable-zlib --enable-gmp --enable-libvidstab --enable-libvmaf --enable-libvorbis --enable-libvo-amrwbenc --enable-libmysofa --enable-libspeex --enable-libxvid --enable-libaom --enable-libgsm --enable-librav1e --disable-w32threads --enable-libmfx --enable-ffnvcodec --enable-cuda-llvm --enable-cuvid --enable-d3d11va --enable-nvenc --enable-nvdec --enable-dxva2 --enable-avisynth --enable-libopenmpt --enable-amf
libavutil      56. 58.100 / 56. 58.100
libavcodec     58. 99.100 / 58. 99.100
libavformat    58. 49.100 / 58. 49.100
libavdevice    58. 11.101 / 58. 11.101
libavfilter     7. 87.100 /  7. 87.100
libswscale      5.  8.100 /  5.  8.100
libswresample   3.  8.100 /  3.  8.100
libpostproc    55.  8.100 / 55.  8.100
```
```
ffmpeg -i input.mp4 -c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 22 -b_ref_mode 1 -dpb_size 4 -multipass 2 -g 350 -bf 3 -pix_fmt yuv420p10le output.mp4
```
