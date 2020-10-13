# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.WindscreenState do
  @moduledoc """
  Windscreen state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  use AutoApi.State, spec_file: "windscreen.json"

  @type wipers_status :: :inactive | :active | :automatic
  @type wipers_intensity :: :level_0 | :level_1 | :level_2 | :level_3
  @type windscreen_damage ::
          :no_impact_detected
          | :impact_but_no_damage_detected
          | :damage_smaller_than_1_inch
          | :damage_larger_than_1_inch
  @type windscreen_zone_matrix :: :unavailable | :horizontal_size | :vertical_size
  @type windscreen_damage_zone :: :unknown | :horizontal_position | :vertical_position
  @type windscreen_needs_replacement :: :unknown | :no_replacement_needed | :replacement_needed

  @type t :: %__MODULE__{
          wipers_status: %PropertyComponent{data: wipers_status} | nil,
          wipers_intensity: %PropertyComponent{data: wipers_intensity} | nil,
          windscreen_damage: %PropertyComponent{data: windscreen_damage} | nil,
          windscreen_zone_matrix: %PropertyComponent{data: windscreen_zone_matrix} | nil,
          windscreen_damage_zone: %PropertyComponent{data: windscreen_damage_zone} | nil,
          windscreen_needs_replacement:
            %PropertyComponent{data: windscreen_needs_replacement} | nil,
          windscreen_damage_confidence: %PropertyComponent{data: float} | nil,
          windscreen_damage_detection_time: %PropertyComponent{data: integer} | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 2>>
    iex> AutoApi.WindscreenState.from_bin(bin)
    %AutoApi.WindscreenState{wipers_status: %AutoApi.PropertyComponent{data: :automatic}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.WindscreenState{wipers_status: %AutoApi.PropertyComponent{data: :automatic}}
    iex> AutoApi.WindscreenState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 2>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
