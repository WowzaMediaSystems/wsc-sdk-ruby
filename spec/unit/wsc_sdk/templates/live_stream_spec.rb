require "unit/spec_helper"

describe WscSdk::Templates::LiveStream do

  it "can generate an wse_single_bitrate template", unit_test: true do
    template = WscSdk::Templates::LiveStream.wse_single_bitrate("Test WSE Single Bitrate", 100, 200)
    expect(template[:name]).to eq("Test WSE Single Bitrate")
    expect(template[:aspect_ratio_width]).to eq(100)
    expect(template[:aspect_ratio_height]).to eq(200)
    expect(template[:encoder]).to eq(WscSdk::Enums::Encoder::WOWZA_STREAMING_ENGINE)
    expect(template[:delivery_type]).to eq(WscSdk::Enums::DeliveryType::SINGLE_BITRATE)
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
  end

  it "can generate an wse_multi_bitrate template", unit_test: true do
    template = WscSdk::Templates::LiveStream.wse_multi_bitrate("Test WS Multi Bitrate Push", 100, 200)
    expect(template[:name]).to eq("Test WS Multi Bitrate Push")
    expect(template[:aspect_ratio_width]).to eq(100)
    expect(template[:aspect_ratio_height]).to eq(200)
    expect(template[:encoder]).to eq(WscSdk::Enums::Encoder::WOWZA_STREAMING_ENGINE)
    expect(template[:delivery_type]).to eq(WscSdk::Enums::DeliveryType::MULTI_BITRATE)
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
  end

  it "can generate an gocoder template", unit_test: true do
    template = WscSdk::Templates::LiveStream.gocoder("Test GoCoder", 100, 200)
    expect(template[:name]).to eq("Test GoCoder")
    expect(template[:aspect_ratio_width]).to eq(100)
    expect(template[:aspect_ratio_height]).to eq(200)
    expect(template[:encoder]).to eq(WscSdk::Enums::Encoder::WOWZA_GOCODER)
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PUSH)
  end

  it "can generate an ip_camera template", unit_test: true do
    template = WscSdk::Templates::LiveStream.ip_camera("Test IP Camera", 100, 200, "rtsp://source_url.com")
    expect(template[:name]).to eq("Test IP Camera")
    expect(template[:aspect_ratio_width]).to eq(100)
    expect(template[:aspect_ratio_height]).to eq(200)
    expect(template[:source_url]).to eq("rtsp://source_url.com")
    expect(template[:encoder]).to eq(WscSdk::Enums::Encoder::IP_CAMERA)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PULL)
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
  end

  it "can generate an rtmp_push template", unit_test: true do
    template = WscSdk::Templates::LiveStream.rtmp_push("Test RTMP Push", 100, 200)
    expect(template[:name]).to eq("Test RTMP Push")
    expect(template[:aspect_ratio_width]).to eq(100)
    expect(template[:aspect_ratio_height]).to eq(200)
    expect(template[:encoder]).to eq(WscSdk::Enums::Encoder::OTHER_RTMP)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PUSH)
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
  end

  it "can generate an rtmp_pull template", unit_test: true do
    template = WscSdk::Templates::LiveStream.rtmp_pull("Test RTMP Pull", 100, 200, "rtmp://source_url.com")
    expect(template[:name]).to eq("Test RTMP Pull")
    expect(template[:aspect_ratio_width]).to eq(100)
    expect(template[:aspect_ratio_height]).to eq(200)
    expect(template[:source_url]).to eq("rtmp://source_url.com")
    expect(template[:encoder]).to eq(WscSdk::Enums::Encoder::OTHER_RTMP)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PULL)
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
  end

  it "can generate an rtsp_push template", unit_test: true do
    template = WscSdk::Templates::LiveStream.rtsp_push("Test RTSP Push", 100, 200)
    expect(template[:name]).to eq("Test RTSP Push")
    expect(template[:aspect_ratio_width]).to eq(100)
    expect(template[:aspect_ratio_height]).to eq(200)
    expect(template[:encoder]).to eq(WscSdk::Enums::Encoder::OTHER_RTSP)
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PUSH)
  end

  it "can generate an rtsp_pull template", unit_test: true do
    template = WscSdk::Templates::LiveStream.rtsp_pull("Test RTSP Pull", 100, 200, "rtsp://source_url.com")
    expect(template[:name]).to eq("Test RTSP Pull")
    expect(template[:aspect_ratio_width]).to eq(100)
    expect(template[:aspect_ratio_height]).to eq(200)
    expect(template[:source_url]).to eq("rtsp://source_url.com")
    expect(template[:encoder]).to eq(WscSdk::Enums::Encoder::OTHER_RTSP)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PULL)
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
  end
end
