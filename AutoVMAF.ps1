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
        # 手始めにhevc_nvenc最強設定と同様の引数を使用して検証
        "h264nvenc_hevcnvencarg" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 22 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            # VMAF score: 96.787031 149.07MB hevc_nvenc https://github.com/nyanshiba/best-ffmpeg-arguments#hevc_nvenc-constqp
            # VMAF score: 96.517079 176.04MB h264nvenc_hevcnvencarg
            # VMAFはhevc_nvencと同等、ファイルサイズは大きくなった
        )
        # ↑の引数を元に、initqpI,P,Bの値を変えて適切なポイントを見つける
        "h264nvenc_initqpIPB" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 10 -init_qpP 10 -init_qpB 10 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 11 -init_qpP 11 -init_qpB 11 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 12 -init_qpP 12 -init_qpB 12 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 13 -init_qpP 13 -init_qpB 13 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 14 -init_qpP 14 -init_qpB 14 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 15 -init_qpP 15 -init_qpB 15 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 16 -init_qpP 16 -init_qpB 16 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 17 -init_qpP 17 -init_qpB 17 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 18 -init_qpP 18 -init_qpB 18 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 19 -init_qpP 19 -init_qpB 19 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 20 -init_qpP 20 -init_qpB 20 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 21 -init_qpB 21 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 21 -init_qpB 22 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 21 -init_qpB 23 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 21 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 21 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 22 -init_qpB 22 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 22 -init_qpB 23 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 22 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 22 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 23 -init_qpB 23 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 23 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 23 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 24 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 21 -init_qpP 24 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 22 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 23 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 23 -init_qpB 23 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 23 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 23 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 23 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 24 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 24 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 24 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 25 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 25 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 23 -init_qpB 23 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 23 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 23 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 23 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 23 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 24 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 24 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 24 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 24 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 25 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 25 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 25 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 26 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 23 -init_qpP 26 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 24 -init_qpB 24 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 24 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 24 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 24 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 24 -init_qpB 28 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 25 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 25 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 25 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 26 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 26 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 26 -init_qpB 28 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 27 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 24 -init_qpP 27 -init_qpB 28 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 25 -init_qpP 25 -init_qpB 25 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 26 -init_qpP 26 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 27 -init_qpP 27 -init_qpB 27 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 28 -init_qpP 28 -init_qpB 28 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 29 -init_qpP 29 -init_qpB 29 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 30 -init_qpP 30 -init_qpB 30 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 31 -init_qpP 31 -init_qpB 31 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 32 -init_qpP 32 -init_qpB 32 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 33 -init_qpP 33 -init_qpB 33 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 34 -init_qpP 34 -init_qpB 34 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 35 -init_qpP 35 -init_qpB 35 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            # グラフにプロットすると、hevcnvenc_initqpIPBと同様に直角双曲線になったが、若干誤差レベルの異常値があった
            # -init_qpI 22 -init_qpP 22 -init_qpB 22で良い気がするが、-init_qpI 22 -init_qpP 22 -init_qpB 26の結果が良かったのでひとまずこれを使う
        )
        "h264nvenc_multipass" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 1 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -multipass 2 -g 60 -bf 3 -pix_fmt yuv420p"
            # multipassは有意な差が無かった
        )
        "h264nvenc_dpbsize" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 1 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 2 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 3 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 4 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 5 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 6 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 7 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 8 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 9 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 10 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 11 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 12 -g 60 -bf 3 -pix_fmt yuv420p"
            # dpb_size>=bframesだった [h264_nvenc @ 000001bf14337bc0] InitializeEncoder failed: invalid param (8): DPB size should be greater than or equal to 3 for B as reference.
            # 有意な差が無かった。-dpb_size 0で良いと思われる。
        )
        "h264nvenc_weightp" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -weighted_pred 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -b_ref_mode 2 -dpb_size 0 -g 60 -bf 3 -pix_fmt yuv420p"
            # [h264_nvenc @ 0000020b452a7bc0] InitializeEncoder failed: invalid param (8): Weighted Prediction not supported with B-frames.
        )
        "h264nvenc_coder" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder default -b_ref_mode 2 -dpb_size 0 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder auto -b_ref_mode 2 -dpb_size 0 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder 1 -b_ref_mode 2 -dpb_size 0 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder 2 -b_ref_mode 2 -dpb_size 0 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 0 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cavlc -b_ref_mode 2 -dpb_size 0 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder ac -b_ref_mode 2 -dpb_size 0 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder vlc -b_ref_mode 2 -dpb_size 0 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            # VMAFスコアは全て変わらなかった。2, cavlc, vlcはファイルサイズが大きくなった。
        )
        "h264nvenc_boolean" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -2pass 0 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -2pass 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -no-scenecut 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -forced-idr 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -b_adapt 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -nonref_p 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -strict_gop 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -zerolatency 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            # -no-scenecut 1のみ影響があったが、よい傾向ではなかった。
            # -zerolatency 1はhevc_nvenc同様これらの引数との組み合わせでは動作しなかった。
        )
        "h264nvenc_rclookahead" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 2 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 3 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 4 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 5 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 6 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 7 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 8 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 9 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 10 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 11 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 12 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 13 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 14 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 15 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 16 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 32 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 64 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 128 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            # hevc_nvencと同様、-rc-lookaheadはbook値に見える。
            # 0でも1でも有意な差が無かった。取り敢えず1を使っておこうと思う。
        )
        "h264nvenc_bframes" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 0 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 1 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 4 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 5 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 6 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 22 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 7 -pix_fmt yuv420p"
            # h264_nvencはbframes 4まで [h264_nvenc @ 00000259216a8480] Max B-frames 5 exceed 4
            # bframes 0はもちろんファイルサイズが大きくなるが、VMAF比が良さそうなのでQPを変えて再度検証
        )
        "h264nvenc_bframes_2" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 0 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 1 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 4 -pix_fmt yuv420p"
            # bframes 4は非効率。2が効率がよい。
        )
        "h264nvenc_gop" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 15 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 30 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 60 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 90 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 150 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 200 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 300 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 400 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 500 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 600 -bf 2 -pix_fmt yuv420p"
            # GOP 15は非常に効率が悪く、60が実用ラインというのはhevc_nvencと同様だが、200までVMAFが変わらず綺麗にファイルサイズが縮んでいるのが特徴的だ。それ以降は全く値が変わらない。
            # 実用性も鑑みて120フレーム(4秒)が妥当だと思う。
        )
        "h264nvenc_bframes_3" =
        @(
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 0 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 1 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 2 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 3 -pix_fmt yuv420p"
            "-c:v h264_nvenc -preset:v p7 -profile:v high -rc:v constqp -rc-lookahead 1 -spatial-aq 0 -temporal-aq 1 -init_qpI 22 -init_qpP 23 -init_qpB 26 -weighted_pred 0 -coder cabac -b_ref_mode 2 -dpb_size 4 -multipass 0 -g 120 -bf 4 -pix_fmt yuv420p"
            # 念のため-g 120でも-bf 0~4をテストしたが、やはり1~3が適切に見える。
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
