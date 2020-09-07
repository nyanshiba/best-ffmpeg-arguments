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
    - FFmpeg version N-98966-g7a89f382a3-g0271098e6c+4  
    https://github.com/m-ab-s/media-autobuild_suite

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
ffmpeg -i input.mp4 -c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 22 -b_ref_mode 1 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p10le -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

## h264_nvenc vbr

```
ffmpeg version N-98966-g7a89f382a3-g0271098e6c+4 Copyright (c) 2000-2020 the FFmpeg developers
  built with gcc 10.2.0 (Rev1, Built by MSYS2 project)
  configuration:  --cc='ccache gcc' --cxx='ccache g++' --disable-autodetect --enable-amf --enable-bzlib --enable-cuda --enable-cuvid --enable-d3d11va --enable-dxva2 --enable-iconv --enable-lzma --enable-nvenc --enable-zlib --enable-sdl2 --enable-ffnvcodec --enable-nvdec --enable-cuda-llvm --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libdav1d --enable-libaom --disable-debug --enable-fontconfig --enable-libass --enable-libbluray --enable-libfreetype --enable-libmfx --enable-libmysofa --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvo-amrwbenc --enable-libwavpack --enable-libwebp --enable-libxml2 --enable-libzimg --enable-libshine --enable-gpl --enable-avisynth --enable-libxvid --enable-libopenmpt --enable-version3 --enable-librav1e --enable-libsrt --enable-libgsm --enable-libvmaf --enable-chromaprint --enable-decklink --enable-frei0r --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libfdk-aac --enable-libflite --enable-libfribidi --enable-libgme --enable-libilbc --enable-libsvthevc --enable-libsvtav1 --enable-libsvtvp9 --enable-libkvazaar --enable-libmodplug --enable-librtmp --enable-librubberband --enable-libtesseract --enable-libxavs --enable-libzmq --enable-libzvbi --enable-openal --enable-libcodec2 --enable-ladspa --enable-libglslang --enable-vulkan --enable-opencl --enable-opengl --enable-libnpp --enable-libopenh264 --enable-openssl --extra-cflags=-fopenmp --extra-libs=-lgomp --extra-cflags=-DLIBTWOLAME_STATIC --extra-libs=-lstdc++ --extra-cflags=-DCACA_STATIC --extra-cflags=-DMODPLUG_STATIC --extra-cflags=-DCHROMAPRINT_NODLL --extra-libs=-lstdc++ --extra-cflags=-DZMQ_STATIC --extra-libs=-lpsapi --extra-cflags=-DLIBXML_STATIC --extra-libs=-liconv --disable-w32threads --extra-cflags=-DKVZ_STATIC_LIB --enable-nonfree --extra-cflags='-IC:/PROGRA~1/NVIDIA~2/CUDA/v11.0/include' --extra-ldflags='-LC:/PROGRA~1/NVIDIA~2/CUDA/v11.0/lib/x64' --extra-cflags=-DAL_LIBTYPE_STATIC --extra-cflags='-IC:/bin/media-autobuild_suite-master/local64/include/AL'
  libavutil      56. 58.100 / 56. 58.100
  libavcodec     58.101.101 / 58.101.101
  libavformat    58. 51.101 / 58. 51.101
  libavdevice    58. 11.101 / 58. 11.101
  libavfilter     7. 87.100 /  7. 87.100
  libswscale      5.  8.100 /  5.  8.100
  libswresample   3.  8.100 /  3.  8.100
  libpostproc    55.  8.100 / 55.  8.100
```

```
ffmpeg -i input.mp4 -c:v h264_nvenc -preset:v p7 -profile:v high -rc:v vbr -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -cq 23 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 2 -pix_fmt yuv420p -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

|Arguments|VMAF|Size(MB)|
|:-|:-|:-|
|hevc_nvenc constqp I22 P22 B22|96.787071|149.07|
|h264_nvenc vbr cq23|96.524121|161.22|
|h264_nvenc vbr cq24|96.269210|143.16|
|h264_nvenc vbr cq25|95.905473|125.48|
|h264_nvenc vbr cq26|95.490610|110.12|
|h264_nvenc vbr cq27|94.976200|96.09|

## h264_nvenc constqp

```
ffmpeg -i input.mp4 -c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 21 -init_qpP 21 -init_qpB 25 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 2 -pix_fmt yuv420p -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

Other excellent parameter lists

|Arguments|VMAF|Size(MB)|
|:-|:-|:-|
|hevc_nvenc constqp I22 P22 B22|96.787071|149.07|
|h264_nvenc constqp I21 P21 B25|96.570217|169.41|
|h264_nvenc constqp I21 P21 B26|96.524021|166.68|
|h264_nvenc constqp I22 P22 B25|96.372320|155.69|
|h264_nvenc constqp I22 P22 B26|96.262820|148.17|
|h264_nvenc constqp I22 P22 B27|96.215174|146.14|
|h264_nvenc constqp I23 P23 B26|95.926876|132.42|
|h264_nvenc constqp I23 P23 B27|95.809517|127.02|
|h264_nvenc constqp I22 P23 B28|95.768000|125.81|
|h264_nvenc constqp I23 P23 B28|95.751297|125.26|
|h264_nvenc constqp I23 P24 B28|95.362693|110.38|
|h264_nvenc constqp I22 P25 B29|94.951748|99.1|
|h264_nvenc constqp I25 P25 B30|94.846410|96.82|
|h264_nvenc constqp I25 P26 B30|94.259133|83.72|
