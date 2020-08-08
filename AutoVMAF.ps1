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
        "hevcnvenc_tier" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -tier main -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -tier high -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # 全く変わらない
        )
        "hevcnvenc_rclookahead" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 32 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 128 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # 0と32では異なるが、値を大きくしても全く変わらない
        )
        "hevcnvenc_surfaces" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -surfaces 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -surfaces 2 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le",
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -surfaces 8 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # 全く変わらない
        )
        "hevcnvenc_2pass" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -2pass true -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # 全く変わらない
        )
        "hevcnvenc_boolean" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -no-scenecut 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -forced-idr 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial_aq 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -temporal_aq 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -temporal-aq 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -zerolatency 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -nonref_p 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -strict_gop 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -aud 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # -spatial-aq -temporal_aq共にVMAF変化があった
            # aqの-と_は表記の違いのみで全く変わらない
            # -zerolatency 1でハングした
        )
        "hevcnvenc_boolean_2" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -nonref_p 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -strict_gop 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -aud 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # 全く変化なし
            # audのみファイルサイズだけ少し大きくなったが、これは品質に影響する引数ではないらしい
        )
        "hevcnvenc_weightp" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 0 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 1 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 25 -g 60 -bf 0 -pix_fmt yuv420p10le"
            # [hevc_nvenc @ 000001af8687ff40] InitializeEncoder failed: invalid param (8): Weighted prediction is not supported with BFrames.
            # -weighted_pred 1でファイルサイズはそのままスコアが下がった
        )
        "hevcnvenc_initqpIPB" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 0 -init_qpP 24 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 0 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 0 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # qpIもPもBも効いてそう
        )
        "hevcnvenc_initqpPB" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 10 -init_qpB 10 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 10 -init_qpB 15 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 10 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 10 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 10 -init_qpB 30 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 15 -init_qpB 10 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 15 -init_qpB 15 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 15 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 15 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 15 -init_qpB 30 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 10 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 15 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 30 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 25 -init_qpB 10 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 25 -init_qpB 15 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 25 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 25 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 25 -init_qpB 30 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 30 -init_qpB 10 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 30 -init_qpB 15 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 30 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 30 -init_qpB 25 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 30 -init_qpB 30 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # qpP・Bは20~25辺りがよいと目星がついた（私の目と同じ結果）
        )
        "hevcnvenc_initqpI" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 0 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 1 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 2 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 4 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 8 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # init_qpIはマトモに効かなかった気がするが、現在のバージョンでは正常に動いてた
        )
        "hevcnvenc_initqpIPB_2" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 18 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 18 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 18 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 18 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 18 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 20 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 20 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 20 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 20 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 22 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 22 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 22 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 22 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 22 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 24 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 24 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 24 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 24 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 24 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 26 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 26 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 26 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 26 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 18 -init_qpP 26 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 18 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 18 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 18 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 18 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 18 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 20 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 20 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 20 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 20 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 22 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 22 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 22 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 22 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 22 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 24 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 24 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 24 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 24 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 24 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 26 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 26 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 26 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 26 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 20 -init_qpP 26 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 18 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 18 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 18 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 18 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 18 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 20 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 22 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 22 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 22 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 22 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 22 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 24 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 26 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 26 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 26 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 26 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 22 -init_qpP 26 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 18 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 18 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 18 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 18 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 18 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 20 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 20 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 20 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 20 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 22 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 22 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 22 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 22 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 22 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 24 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 24 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 24 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 24 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 24 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 26 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 26 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 26 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 26 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 24 -init_qpP 26 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 18 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 18 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 18 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 18 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 18 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 20 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 20 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 20 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 20 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 20 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 22 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 22 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 22 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 22 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 22 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 24 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 24 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 24 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 24 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 24 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # ハングして出来なかった分は以降再度実行
        )
        "hevcnvenc_initqpIPB_3" =
        @(
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 24 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 24 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 24 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 18 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 20 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 22 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 24 -g 60 -bf 3 -pix_fmt yuv420p10le"
            "-c:v hevc_nvenc -preset:v p7 -profile:v main10 -rc:v constqp -rc-lookahead 0 -spatial-aq 0 -temporal-aq 0 -weighted_pred 0 -b_ref_mode 2 -init_qpI 26 -init_qpP 26 -init_qpB 26 -g 60 -bf 3 -pix_fmt yuv420p10le"
            # -init_qpI 22 -init_qpP 22 -init_qpB 22 が効率良さそう。-init_qpI 22 -init_qpP 20 -init_qpB 22 も良いし、恐らく -init_qpI 22 -init_qpP 21 -init_qpB 22 も良いと思われる
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
    # Invoke-Process -File $Settings.FilePath -Arg "-y -nostats -i input.mp4 -i output.mp4 -filter_complex ssim -an -f null -"

    # vmaf
    Invoke-Process -File $Settings.FilePath -Arg "-y -nostats -i output.mp4 -i input.mp4 -filter_complex libvmaf=vmaf_v0.6.1.pkl -an -f null -"

    # file size
    "$([math]::round((Get-ChildItem -LiteralPath output.mp4).Length/1MB,1))MB"
}

# ログ取り停止
Stop-Transcript
