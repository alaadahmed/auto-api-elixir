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
defmodule AutoApi.VehicleLocationStateTest do
  use ExUnit.Case
  doctest AutoApi.VehicleLocationState
  alias AutoApi.VehicleLocationState

  test "to_bin/1 & from_bin" do
    state =
      %VehicleLocationState{}
      |> VehicleLocationState.put_property(:altitude, 133.5)
      |> VehicleLocationState.put_property(:heading, 0.5)
      |> VehicleLocationState.put_property(:coordinates, %{
        latitude: 52.516506,
        longitude: 13.381815
      })

    new_state =
      state
      |> VehicleLocationState.to_bin()
      |> VehicleLocationState.from_bin()

    assert new_state == state
  end
end
