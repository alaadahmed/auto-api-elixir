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
defmodule AutoApi.VehicleStatusState do
  @moduledoc """
  VehicleStatus state
  """

  alias AutoApi.PropertyComponent

  defstruct vin: nil,
            powertrain: nil,
            model_name: nil,
            name: nil,
            license_plate: nil,
            sales_designation: nil,
            model_year: nil,
            colour_name: nil,
            power_in_kw: nil,
            number_of_doors: nil,
            number_of_seats: nil,
            engine_volume: nil,
            engine_max_torque: nil,
            gearbox: nil,
            display_unit: nil,
            driver_seat_location: nil,
            equipments: [],
            brand: nil,
            states: [],
            timestamp: nil

  use AutoApi.State, spec_file: "specs/vehicle_status.json"

  @type powertrain ::
          :unknown | :all_electric | :combustion_engine | :phev | :hydrogen | :hydrogen_hybrid

  @type gearbox :: :manual | :automatic | :semi_automatic

  @type t :: %__MODULE__{
          vin: %PropertyComponent{data: String.t()} | nil,
          powertrain: %PropertyComponent{data: powertrain} | nil,
          model_name: %PropertyComponent{data: String.t()} | nil,
          name: %PropertyComponent{data: String.t()} | nil,
          license_plate: %PropertyComponent{data: String.t()} | nil,
          sales_designation: %PropertyComponent{data: String.t()} | nil,
          model_year: %PropertyComponent{data: integer} | nil,
          colour_name: %PropertyComponent{data: String.t()} | nil,
          power_in_kw: %PropertyComponent{data: integer} | nil,
          number_of_doors: %PropertyComponent{data: integer} | nil,
          number_of_seats: %PropertyComponent{data: integer} | nil,
          engine_volume: %PropertyComponent{data: float} | nil,
          engine_max_torque: %PropertyComponent{data: integer} | nil,
          gearbox: %PropertyComponent{data: gearbox} | nil,
          display_unit: %PropertyComponent{data: :km | :miles} | nil,
          driver_seat_location: %PropertyComponent{data: :left | :right | :center} | nil,
          equipments: list(%PropertyComponent{data: String.t()}),
          brand: %PropertyComponent{data: String.t()} | nil,
          states: list(%PropertyComponent{}),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 20, 1, 0, 17, 88, 86, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 49>>
    iex> AutoApi.VehicleStatusState.from_bin(bin)
    %AutoApi.VehicleStatusState{vin: %AutoApi.PropertyComponent{data: "XV000000000000001"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.VehicleStatusState{vin: %AutoApi.PropertyComponent{data: "XV000000000000001"}}
    iex> AutoApi.VehicleStatusState.to_bin(state)
    <<1, 0, 20, 1, 0, 17, 88, 86, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 49>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
