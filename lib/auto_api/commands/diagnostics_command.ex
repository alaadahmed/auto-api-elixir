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
defmodule AutoApi.DiagnosticsCommand do
  @moduledoc """
  Handles Diagnostics commands and apply binary commands on `%AutoApi.DiagnosticsState{}`
  """
  use AutoApi.Command

  alias AutoApi.DiagnosticsState

  @doc """
  Converts DiagnosticsCommand state to capability's state in binary
  """
  @spec state(DiagnosticsState.t()) :: binary
  def state(%DiagnosticsState{} = state) do
    <<0x01, DiagnosticsState.to_bin(state)::binary>>
  end
end
