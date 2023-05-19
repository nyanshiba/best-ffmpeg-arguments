# best-ffmpeg-arguments

FFmpegの各エンコーダで最も品質の良いパラメータを見つけるスクリプトとその結果  
手作業では埒が明かないので`AutoVMAF.ps1`で自動化した

## テスト環境

hevc_nvenc, h264_nvenc, h264_qsv

- Intel Core i7 8700
    - Intel UHD Graphics 630

- NVIDIA GeForce RTX 2080
    - NVIDIA Studio Driver 451.77
    - NVIDIA Studio Driver 531.61

- Windows 10 2004
    - FFmpeg version 4.3.1
    - FFmpeg version 20200806-2c35797  
    https://ffmpeg.zeranoe.com/builds/
    - FFmpeg version N-98966-g7a89f382a3-g0271098e6c+4  
    https://github.com/m-ab-s/media-autobuild_suite
- Windows 10 22H2
    - FFmpeg version N-109952-g52a0852ae6-20230302  
    https://github.com/BtbN/FFmpeg-Builds

## hevc_nvenc

- presetはp7が最も高品質。
- profile、pix_fmtはyuv420p10leが良い。yuv420pは同じファイルサイズでVMAFが下がり、yuv444pやyuv444p10leはファイルサイズが増えた上にVMAFも下がる。
- 低品質域はvbr cq、高品質域はconstqp init_qpが優秀。VMAFが96あたりから逆転する。h264_nvencより逆転が早いので使い分けが必要。
- p1-p7は古い2passレートコントロールモードのcbr_hqやvbr_hqに対応していない。
- lookaheadはbool値の様な挙動で、有効にしたほうが良かった。
- spatial-aqはVMAFに対しファイルサイズを肥大させ、temporal-aqは減少させる傾向にあった。aq-strengthはspatial-aqにのみ影響した。
- weighted_predはB-Frameと組み合わせて使用できなかった。
- qp指定とinit_qpI,P,B指定は異なり、qp指定は品質が劣っていた。
- constqpでは、init_qpI=n init_qpP=n init_qpB=n+4 が良い結果を出す傾向にあった。
- constqpで、chroma QP offsetを使用すると効率がかなりよくなった。
- 最新のFFmpegでないとb_ref_mode 1が使用できず、バージョンによっては強めなゾンビプロセスとして残る悪質な不具合があったが、使用できればVMAFを保ちつつファイルサイズを削減できる。
- dpd_size 4が効率が良く、5以降は変化がなかった。
- multipass qresの品質が若干よかったが、h264_nvencのように速度面での優位性はなかった。
- g 15や30は明らかに効率が悪いが、60以降は大きな変化がなくソースによって前後したため、扱いやすい60が適切とした。
- bf 3が若干効率良いが、ファイルサイズと品質はトレードオフの傾向だった。

|QP|bitrate (kbit/s)↓|VMAF|
|:-|:-|:-|
|-rc:v vbr -cq 15|9634.0|96.412289|
|-rc:v vbr -cq 16|9629.7|96.418058|
|-rc:v vbr -cq 17|9617.7|96.414713|
|-rc:v vbr -cq 18|9601.4|96.417729|
|-rc:v vbr -cq 19|9553.9|96.408545|
|-rc:v vbr -cq 20|9483.9|96.406785|
|-rc:v vbr -cq 21|9346.4|96.396234|
|-rc:v vbr -cq 22|9069.1|96.372150|
|-rc:v constqp -init_qpI 20 -init_qpP 20 -init_qpB 24 -qp_cb_offset 10 -qp_cr_offset 11|8679.3|96.867742|
|-rc:v vbr -cq 23|8619.1|96.300968|
|-rc:v vbr -cq 24|8033.9|96.184342|
|-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 25 -qp_cb_offset 10 -qp_cr_offset 11|7539.4|96.484382|
|-rc:v vbr -cq 25|7324.8|95.980028|
|-rc:v constqp -init_qpI 22 -init_qpP 22 -init_qpB 26 -qp_cb_offset 10 -qp_cr_offset 11|6601.2|96.061595|
|-rc:v vbr -cq 26|6522.2|95.583377|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 27 -qp_cb_offset 10 -qp_cr_offset 11|5778.7|95.562538|
|-rc:v vbr -cq 27|5667.4|95.007882|
|-rc:v constqp -init_qpI 24 -init_qpP 24 -init_qpB 28 -qp_cb_offset 10 -qp_cr_offset 11|5066.7|95.003842|
|-rc:v vbr -cq 28|4938.8|94.362823|
|-rc:v vbr -cq 29|4307.8|93.645067|
|-rc:v vbr -cq 30|3765.7|92.800629|

### constqp init_qp

```
ffmpeg -i input.mp4 -c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 20 -init_qpP 20 -init_qpB 24 -qp_cb_offset 10 -qp_cr_offset 11 -b_ref_mode 1 -dpb_size 4 -multipass 1 -g 60 -bf 3 -pix_fmt yuv420p10le -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

### vbr cq

```
ffmpeg -i input.mp4 -c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v vbr -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -cq 25 -b_ref_mode 1 -dpb_size 4 -multipass 1 -g 60 -bf 3 -pix_fmt yuv420p10le -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

## h264_nvenc

- presetはp4(medium,slow)かp3(≒llhq,ll)が品質と負荷とサイズのバランスが良い。最高品質を求めるならp7を使用する。
- profileはhighが効率がよく、mainはともかくbaselineは論外。
- chroma QP offsetを使うと、constqpに対するvbr cqの優位性はなくなった。
- lookaheadは同じくbool値の様な挙動で、差はあまりなかった。
- 同じくspatial-aqはVMAFに対しファイルサイズを肥大させ、temporal-aqは減少させる傾向にあった。
- 同じくweighted_predはB-Frameと組み合わせて使用できなかった。
- coderはcavlc,vlcはファイルサイズが肥大した。
- b_ref_mode 1か2を使うべき
- dpd_sizeはbframes以上の値が必要。有意な差はなかった。
- multipassはqresが0や2より1.5倍ほど高速で、品質は同等以上だった。
- g 15や30は明らかに効率が悪いのは同様だが、60以降は大きな変化がなくソースによって前後したhevc_nvencと比べ、GOPを大きくすると順当に効率が良くなっていった。大きくしても大きな改善がないことと実用面を加味して120とした。
- bf 0や4は効率が悪く、使用するなら2。
- pix_fmtはyuv420p10leが使用できないのでyuv420pを使う。

|QP|bitrate (kbit/s)↓|VMAF|
|:-|:-|:-|
|-rc:v vbr -cq 23|11091.4|96.516341|
|-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 25 -qp_cb_offset 10 -qp_cr_offset 11|9909.4|96.651959|
|-rc:v constqp -init_qpI 21 -init_qpP 21 -init_qpB 26 -qp_cb_offset 10 -qp_cr_offset 11|9909.4|96.651959|
|-rc:v vbr -cq 24|9670.1|96.184235|
|-rc:v constqp -init_qpI 22 -init_qpP 22 -init_qpB 25 -qp_cb_offset 10 -qp_cr_offset 11|9167.2|96.455188|
|-rc:v constqp -init_qpI 22 -init_qpP 22 -init_qpB 26 -qp_cb_offset 10 -qp_cr_offset 11|8724.4|96.357689|
|-rc:v constqp -init_qpI 22 -init_qpP 22 -init_qpB 27 -qp_cb_offset 10 -qp_cr_offset 11|8724.4|96.357689|
|-rc:v vbr -cq 25|8481.0|95.809531|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 26 -qp_cb_offset 10 -qp_cr_offset 11|7884.9|96.024440|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 27 -qp_cb_offset 10 -qp_cr_offset 11|7551.5|95.926437|
|-rc:v constqp -init_qpI 22 -init_qpP 23 -init_qpB 28 -qp_cb_offset 10 -qp_cr_offset 11|7581.0|95.937849|
|-rc:v constqp -init_qpI 23 -init_qpP 23 -init_qpB 28 -qp_cb_offset 10 -qp_cr_offset 11|7551.5|95.926437|
|-rc:v vbr -cq 26|7413.3|95.360799|
|-rc:v constqp -init_qpI 23 -init_qpP 24 -init_qpB 28 -qp_cb_offset 10 -qp_cr_offset 11|6612.2|95.489355|
|-rc:v vbr -cq 27|6460.3|94.823643|
|-rc:v constqp -init_qpI 22 -init_qpP 25 -init_qpB 29 -qp_cb_offset 10 -qp_cr_offset 11|5927.4|95.090801|
|-rc:v constqp -init_qpI 25 -init_qpP 25 -init_qpB 30 -qp_cb_offset 10 -qp_cr_offset 11|5854.2|95.036602|
|-rc:v constqp -init_qpI 25 -init_qpP 26 -init_qpB 30 -qp_cb_offset 10 -qp_cr_offset 11|5053.4|94.391991|

### vbr cq

```
ffmpeg -i input.mp4 -c:v h264_nvenc -preset:v p7 -profile:v high -rc:v vbr -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -cq 23 -weighted_pred 0 -coder cabac -b_ref_mode 1 -dpb_size 4 -multipass 1 -g 120 -bf 2 -pix_fmt yuv420p -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```

## constqp init_qp

```
ffmpeg -i input.mp4 -c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 20 -init_qpP 20 -init_qpB 24 -qp_cb_offset 10 -qp_cr_offset 11 -weighted_pred 0 -coder cabac -b_ref_mode 1 -dpb_size 4 -multipass 1 -g 120 -bf 2 -pix_fmt yuv420p -color_range tv -color_primaries bt709 -color_trc bt709 -colorspace bt709 -movflags +faststart output.mp4
```
