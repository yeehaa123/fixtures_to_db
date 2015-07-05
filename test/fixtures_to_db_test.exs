defmodule Waypoint do
  @derive Collectable
  defstruct [:id, :curator, :title, :summary, :description]
 end

defmodule WaypointParser do
  def parse(file_path) do
    file_path
    |> :yamerl_constr.file
    |> hd
    |> create_waypoint
  end

  defp create_waypoint(document) do
    document
    |> get_values(Map.keys(%Waypoint{}))
    |> Enum.into(%Waypoint{})
  end

  defp get_values(document, fields) do
    fields 
    |> Enum.reject(&(&1 == :__struct__))
    |> Enum.map(&get_value(document, &1))
  end

  defp get_value(document, field) when field == :description do
    val = field
    |> extract_value(document)
    |> to_string
    { field, val }
  end

  defp get_value(document, field) do
    val = field
    |> extract_value(document)
    { field, val }
  end

  defp extract_value(field, document) do
    field
    |> Atom.to_char_list
    |> :proplists.get_value(document)
   end
end

defmodule FixturesToDbTest do
  use ExUnit.Case

  @document "do_not_repeat_yourself.yml" |> WaypointParser.parse

  test "it extracts the waypoint from the yaml file" do
    assert @document.id == 2 
  end
end
