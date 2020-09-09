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

## hevc_nvenc

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

- presetはp7が最も高品質。
- profile、pix_fmtはyuv420p10leが良い。yuv420pは同じファイルサイズでVMAFが下がり、yuv444pやyuv444p10leはファイルサイズが増えた上にVMAFも下がる。
- 低品質域はvbr cq、高品質域はconstqp init_qpが優秀。VMAFが96あたりから逆転する。h264_nvencより逆転が早いので使い分けが必要。
- p1-p7は古い2passレートコントロールモードのcbr_hqやvbr_hqに対応していない。
- lookaheadはbool値の様な挙動で、有効にしたほうが良かった。
- spatial-aqはVMAFに対しファイルサイズを肥大させ、temporal-aqは減少させる傾向にあった。
- weighted_predはB-Frameと組み合わせて使用できなかった。
- qp指定とinit_qpI,P,B指定は異なり、qp指定は品質が劣っていた。
- constqpでは、init_qpI=n init_qpP=n init_qpB=n+3 が良い結果を出す傾向にあった。
- 最新のFFmpegでないとb_ref_mode 1が使用できず、バージョンによっては強めなゾンビプロセスとして残る悪質な不具合があったが、使用できればVMAFを保ちつつファイルサイズを削減できる。
- dpd_size 4が効率が良く、5以降は変化がなかった。
- multipass 2が良く、1は0よりも悪かった。
- g 15や30は明らかに効率が悪いが、60以降は大きな変化がなくソースによって前後したため、扱いやすい60が適切とした。
- bf 3が若干効率良いが、ファイルサイズと品質はトレードオフの傾向だった。

|Arguments|VMAF|Size(MB)↓|
|:-|:-|:-|
|-rc:v constqp -init_qpI 20 -init_qpP 20 -init_qpB 22|97.152364|167.9|
|-rc:v constqp -init_qpI 20 -init_qpP 20 -init_qpB 23|97.005211|156.21|
|-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 23|96.817393|145.43|
|-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 24|96.672209|136.5|
|-rc:v vbr -cq 20|96.253600|136.08|
|-rc:v vbr -cq 21|96.259003|133.72|
|-rc:v vbr -cq 22|96.226078|129.12|
|-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 25|96.480808|127.28|
|-rc:v vbr -cq 23|96.138415|122.19|
|-rc:v constqp -init_qpI 22 -init_qpP 22 -init_qpB 25|96.266530|117.97|
|-rc:v vbr -cq 24|96.018785|113.64|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 25|96.006153|109.44|
|-rc:v vbr -cq 25|95.834602|103.84|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 26|95.786159|101.75|
|-rc:v vbr -cq 26|95.522945|93.39|
|-rc:v constqp -init_qpI 24 -init_qpP 24 -init_qpB 27|95.260400|88.14|
|-rc:v vbr -cq 27|94.997487|81.74|
|-rc:v constqp -init_qpI 25 -init_qpP 25 -init_qpB 28|94.617999|76.19|
|-rc:v vbr -cq 28|94.370461|71.3|
|-rc:v vbr -cq 29|93.669194|62.39|
|-rc:v vbr -cq 30|92.822492|54.5|

### constqp init_qp

```
ffmpeg -i input.mp4 -c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 21 -init_qpB 24 -b_ref_mode 1 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p10le -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

### vbr cq

```
ffmpeg -i input.mp4 -c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v vbr -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -cq 25 -b_ref_mode 1 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p10le -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

## h264_nvenc

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

- presetはp4(medium,slow)かp3(≒llhq,ll)が品質と負荷とサイズのバランスが良い。最高品質を求めるならp7を使用する。
- profileはhighが効率がよく、mainはともかくbaselineは論外。
- hevc_nvencに比べconstqp init_qpよりvbr cq優位だった。
- lookaheadは同じくbool値の様な挙動で、差はあまりなかった。
- 同じくspatial-aqはVMAFに対しファイルサイズを肥大させ、temporal-aqは減少させる傾向にあった。
- 同じくweighted_predはB-Frameと組み合わせて使用できなかった。
- coderはcavlc,vlcはファイルサイズが肥大した。
- 最新のFFmpegでもb_ref_mode 1が使用できなかった。
- dpd_sizeはbframes以上の値が必要。有意な差はなかった。
- multipassも有意な差がなかった。
- g 15や30は明らかに効率が悪いのは同様だが、60以降は大きな変化がなくソースによって前後したhevc_nvencと比べ、GOPを大きくすると順当に効率が良くなっていった。大きくしても大きな改善がないことと実用面を加味して120とした。
- bf 0や4は効率が悪く、使用するなら2。
- pix_fmtはyuv420p10leが使用できないのでyuv420pを使う。

|Arguments|VMAF|Size(MB)↓|
|:-|:-|:-|
|(-c:v hevc_nvenc)-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 24|96.672209|136.5|
|-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 25|96.570217|169.41|
|-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 26|96.524021|166.68|
|-rc:v vbr -cq 23|96.524121|161.22|
|-rc:v constqp -init_qpI 22 -init_qpP 22 -init_qpB 25|96.372320|155.69|
|-rc:v constqp -init_qpI 22 -init_qpP 22 -init_qpB 26|96.262820|148.17|
|-rc:v constqp -init_qpI 22 -init_qpP 22 -init_qpB 27|96.215174|146.14|
|-rc:v vbr -cq 24|96.269210|143.16|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 26|95.926876|132.42|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 27|95.809517|127.02|
|-rc:v constqp -init_qpI 22 -init_qpP 23 -init_qpB 28|95.768000|125.81|
|-rc:v vbr -cq 25|95.905473|125.48|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 28|95.751297|125.26|
|-rc:v constqp -init_qpI 23 -init_qpP 24 -init_qpB 28|95.362693|110.38|
|-rc:v vbr -cq 26|95.490610|110.12|
|-rc:v constqp -init_qpI 22 -init_qpP 25 -init_qpB 29|94.951748|99.1|
|-rc:v constqp -init_qpI 25 -init_qpP 25 -init_qpB 30|94.846410|96.82|
|-rc:v vbr -cq 27|94.976200|96.09|
|-rc:v constqp -init_qpI 25 -init_qpP 26 -init_qpB 30|94.259133|83.72|

### vbr cq

```
ffmpeg -i input.mp4 -c:v h264_nvenc -preset:v p7 -profile:v high -rc:v vbr -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -cq 23 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 2 -pix_fmt yuv420p -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

## constqp init_qp

```
ffmpeg -i input.mp4 -c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 21 -init_qpP 21 -init_qpB 25 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 2 -pix_fmt yuv420p -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```
