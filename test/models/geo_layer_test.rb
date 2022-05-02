require "test_helper"

class GeoLayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  test 'point_to_hex' do
    assert_equal [0, 0], GeoLayer.point_to_hex(1, 1)
    assert_equal [1, 0], GeoLayer.point_to_hex(10, 1)
    assert_equal [0, 1], GeoLayer.point_to_hex(1, 10)
    assert_equal [1, 1], GeoLayer.point_to_hex(10, GeoLayer::HEX_RADIUS * 2)
  end

  test 'hex_to_point' do
    assert_equal [0, 0], GeoLayer.hex_to_point(0, 0)
    assert_equal [9.07035, 15.710307042432365], GeoLayer.hex_to_point(1, 1)
    assert_equal [9.07035, 26.18384507072061], GeoLayer.hex_to_point(1, 2)
    assert_equal [9.07035, 36.657383099008854], GeoLayer.hex_to_point(1, 3)
  end

  test 'draw_hex' do
    center = [20, 20]
    # angle_deg = 60 * i
    # angle_rad = PI / 180 * angle_deg
    # x = x + radius * cos(angle_rad)
    # y = y + radius * sin(angle_rad)
    corners = [
      [
        center[0] + GeoLayer::HEX_RADIUS * Math.cos(Math::PI / 180 * 60 * 0),
        center[1] + GeoLayer::HEX_RADIUS * Math.sin(Math::PI / 180 * 60 * 0),
      ], # 0
      [
        center[0] + GeoLayer::HEX_RADIUS * Math.cos(Math::PI / 180 * 60 * 1),
        center[1] + GeoLayer::HEX_RADIUS * Math.sin(Math::PI / 180 * 60 * 1),
      ], # 1
      [
        center[0] + GeoLayer::HEX_RADIUS * Math.cos(Math::PI / 180 * 60 * 2),
        center[1] + GeoLayer::HEX_RADIUS * Math.sin(Math::PI / 180 * 60 * 2),
      ], # 2
      [
        center[0] + GeoLayer::HEX_RADIUS * Math.cos(Math::PI / 180 * 60 * 3),
        center[1] + GeoLayer::HEX_RADIUS * Math.sin(Math::PI / 180 * 60 * 3),
      ], # 3
      [
        center[0] + GeoLayer::HEX_RADIUS * Math.cos(Math::PI / 180 * 60 * 4),
        center[1] + GeoLayer::HEX_RADIUS * Math.sin(Math::PI / 180 * 60 * 4),
      ], # 4
      [
        center[0] + GeoLayer::HEX_RADIUS * Math.cos(Math::PI / 180 * 60 * 5),
        center[1] + GeoLayer::HEX_RADIUS * Math.sin(Math::PI / 180 * 60 * 5),
      ] # 5
    ]

    assert_equal corners, GeoLayer.draw_hex(center)
  end
end
