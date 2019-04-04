####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"

describe WscSdk::Templates::LiveStream do


  it "can generate an rtmp_pull template", unit_test: true do
    template = WscSdk::Templates::Transcoder.rtmp_pull("Test RTMP PULL", "rtmp://source_url.com")
    expect(template[:name]).to eq("Test RTMP PULL")
    expect(template[:source_url]).to eq("rtmp://source_url.com")
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
    expect(template[:protocol]).to eq(WscSdk::Enums::Protocol::RTMP)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PULL)
  end

  it "can generate an rtmp_push template", unit_test: true do
    template = WscSdk::Templates::Transcoder.rtmp_push("Test RTMP PUSH", "abcd1234")
    expect(template[:name]).to eq("Test RTMP PUSH")
    expect(template[:stream_source_id]).to eq("abcd1234")
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
    expect(template[:protocol]).to eq(WscSdk::Enums::Protocol::RTMP)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PUSH)
  end


  it "can generate an rtsp_pull template", unit_test: true do
    template = WscSdk::Templates::Transcoder.rtsp_pull("Test RTSP PULL", "rtsp://source_url.com")
    expect(template[:name]).to eq("Test RTSP PULL")
    expect(template[:source_url]).to eq("rtsp://source_url.com")
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
    expect(template[:protocol]).to eq(WscSdk::Enums::Protocol::RTSP)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PULL)
  end

  it "can generate an rtsp_push template", unit_test: true do
    template = WscSdk::Templates::Transcoder.rtsp_push("Test RTSP PUSH", "abcd1234")
    expect(template[:name]).to eq("Test RTSP PUSH")
    expect(template[:stream_source_id]).to eq("abcd1234")
    expect(template[:broadcast_location]).to eq(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA)
    expect(template[:protocol]).to eq(WscSdk::Enums::Protocol::RTSP)
    expect(template[:delivery_method]).to eq(WscSdk::Enums::DeliveryMethod::PUSH)
  end

end
