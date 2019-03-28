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
defmodule AutoApi.NotImplemented do
  @moduledoc """
  A dummy implementation for `AutoApi.Command` and `AutoApi.State`
  behaviours that throws an error for any method.
  """

  @behaviour AutoApi.Command
  @behaviour AutoApi.State
  def execute(_, _), do: throw(:not_implemented)
  def state(_), do: throw(:not_implemented)
  def base, do: throw(:not_implemented)
  def from_bin(_), do: throw(:not_implemented)
  def to_bin(_), do: throw(:not_implemented)
end
