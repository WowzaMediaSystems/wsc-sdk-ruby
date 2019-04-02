require "unit/spec_helper"
describe WscSdk::Enums::Encoder do

  it "enumerates values properly", unit_test: true do

    expect(WscSdk::Enums::Encoder::WOWZA_STREAMING_ENGINE).to eq("wowza_streaming_engine")
    expect(WscSdk::Enums::Encoder::WOWZA_GOCODER).to eq("wowza_gocoder")
    expect(WscSdk::Enums::Encoder::MEDIA_DS).to eq("media_ds")
    expect(WscSdk::Enums::Encoder::AXIS).to eq("axis")
    expect(WscSdk::Enums::Encoder::EPIPHAN).to eq("epiphan")
    expect(WscSdk::Enums::Encoder::HAUPPAUGE).to eq("hauppauge")
    expect(WscSdk::Enums::Encoder::JVC).to eq("jvc")
    expect(WscSdk::Enums::Encoder::LIVE_U).to eq("live_u")
    expect(WscSdk::Enums::Encoder::MATROX).to eq("matrox")
    expect(WscSdk::Enums::Encoder::NEWTEK_TRICASTER).to eq("newtek_tricaster")
    expect(WscSdk::Enums::Encoder::OSPREY).to eq("osprey")
    expect(WscSdk::Enums::Encoder::SONY).to eq("sony")
    expect(WscSdk::Enums::Encoder::TELESTREAM_WIRECAST).to eq("telestream_wirecast")
    expect(WscSdk::Enums::Encoder::TERADEK_CUBE).to eq("teradek_cube")
    expect(WscSdk::Enums::Encoder::VMIX).to eq("vmix")
    expect(WscSdk::Enums::Encoder::X_SPLIT).to eq("x_split")
    expect(WscSdk::Enums::Encoder::IP_CAMERA).to eq("ipcamera")
    expect(WscSdk::Enums::Encoder::OTHER_RTMP).to eq("other_rtmp")
    expect(WscSdk::Enums::Encoder::OTHER_RTSP).to eq("other_rtsp")

  end

end
