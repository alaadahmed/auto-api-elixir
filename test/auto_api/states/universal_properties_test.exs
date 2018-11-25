# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.UniversalPropertiesTest do
  use ExUnit.Case
  alias AutoApi.{DoorLocksState, DiagnosticsState}

  test "converts the state properties and the universal properties" do
    bin_state = <<0x04, 2::integer-16, 0x00, 0x01, 0xA2, 0, 8, 18, 6, 8, 16, 8, 2, 0, 120>>

    state = DoorLocksState.from_bin(bin_state)

    datetime = %DateTime{
      year: 2018,
      month: 06,
      day: 08,
      hour: 16,
      minute: 8,
      second: 2,
      utc_offset: 120,
      time_zone: "",
      zone_abbr: "",
      std_offset: 0
    }

    locks = [
      %{door_location: :front_left, position: :open}
    ]

    assert state == %DoorLocksState{positions: locks, timestamp: datetime}
  end

  describe "property timestamp" do
    test "converts binary value to state" do
      bin_state =
        <<0x01, 3::integer-16, 0, 0, 0x02, 0xA4, 9::integer-16, 18, 6, 8, 16, 8, 2, 0, 120, 0x01>>

      datetime = %DateTime{
        year: 2018,
        month: 06,
        day: 08,
        hour: 16,
        minute: 8,
        second: 2,
        utc_offset: 120,
        time_zone: "",
        zone_abbr: "",
        std_offset: 0
      }

      state = DiagnosticsState.from_bin(bin_state)
      assert state.property_timestamps[:mileage] == datetime
    end
  end

  test "converts state to binary" do
    now = DateTime.utc_now()

    state = %DiagnosticsState{
      mileage: 100,
      property_timestamps: %{mileage: now},
      properties: [:mileage, :property_timestamps]
    }

    assert <<id, _size::integer-16, mileage::integer-24, timestamp_id, timestamp_size::integer-16,
             timestamp::binary-size(8), id>> = DiagnosticsState.to_bin(state)

    assert id == DiagnosticsState.property_id(:mileage)
    assert mileage == 100
    assert timestamp_id == 0xA4
    assert timestamp_size == 9

    assert timestamp ==
             <<now.year - 2000, now.month, now.day, now.hour, now.minute, now.second,
               now.utc_offset::integer-16>>
  end

  test "converts state with multiple item to binary" do
    now = DateTime.utc_now()

    temperature = %{location: :rear_left, temperature: 10.0}

    state = %DiagnosticsState{
      tire_temperatures: [temperature],
      property_timestamps: %{tire_temperatures: [{now, temperature}]},
      properties: [:tire_temperatures, :property_timestamps]
    }

    assert <<timestamp_id, timestamp_size::integer-16, timestamp::binary-size(8),
             property_data_in_timestamp::binary-size(5), id, id, 5::integer-16,
             property_data::binary-size(5)>> = DiagnosticsState.to_bin(state)

    assert id == DiagnosticsState.property_id(:tire_temperatures)
    assert timestamp_id == 0xA4
    # timestamp size + tire_temperature size
    assert timestamp_size == 13

    assert timestamp ==
             <<now.year - 2000, now.month, now.day, now.hour, now.minute, now.second,
               now.utc_offset::integer-16>>

    assert property_data == property_data_in_timestamp
  end

  describe "put_with_timestamp/4" do
    test "converts signle value property with timestamp to binary" do
      now = DateTime.utc_now()

      state = %DiagnosticsState{}

      state = AutoApi.State.put_with_timestamp(state, :mileage, 101, now)

      assert state.mileage == 101
      assert state.property_timestamps[:mileage] == now
      assert state.properties == [:property_timestamps, :mileage]
    end

    test "converts multiple value property with timestamp to binary" do
      now = DateTime.utc_now()

      rear_left_temperature = %{location: :rear_left, temperature: 10.0}

      state = %DiagnosticsState{}

      state =
        AutoApi.State.put_with_timestamp(state, :tire_temperatures, rear_left_temperature, now)

      assert state.tire_temperatures == [rear_left_temperature]
      assert state.property_timestamps[:tire_temperatures] == [{now, rear_left_temperature}]
      assert state.properties == [:property_timestamps, :tire_temperatures]

      rear_right_temperature = %{location: :rear_right, temperature: 11.0}

      state =
        AutoApi.State.put_with_timestamp(state, :tire_temperatures, rear_right_temperature, now)

      assert state.tire_temperatures == [rear_right_temperature, rear_left_temperature]

      assert state.property_timestamps[:tire_temperatures] == [
               {now, rear_right_temperature},
               {now, rear_left_temperature}
             ]

      assert byte_size(DiagnosticsState.to_bin(state)) == 50
    end
  end
end
