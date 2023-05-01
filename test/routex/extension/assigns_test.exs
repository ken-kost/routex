defmodule Routex.Extension.AssignsTest do
  use ExUnit.Case, async: true

  alias Routex.Extension.Assigns

  defmodule Conf1 do
    use(Routex, extensions: [Routex.Extension.Assigns])
  end

  defmodule Conf2 do
    use(
      Routex,
      assigns: %{namespace: :rtx},
      extensions: [
        Routex.Extension.Assigns
      ]
    )
  end

  defmodule Conf3 do
    use(
      Routex,
      assigns: %{namespace: :rtx, attrs: [:rtx_1]},
      extensions: [
        Routex.Extension.Assigns
      ]
    )
  end

  test "by default includes all attrs" do
    route =
      %Phoenix.Router.Route{private: %{}}
      |> Routex.Attrs.put(:rtx_1, "r1")
      |> Routex.Attrs.put(:rtx_2, "r2")

    new = Assigns.post_transform([route], Conf1, nil)

    assert [%{private: %{routex: %{assigns: %{rtx_1: "r1", rtx_2: "r2"}}}}] = new
  end

  test "namespace assigns" do
    route =
      %Phoenix.Router.Route{private: %{}}
      |> Routex.Attrs.put(:rtx_1, "r1")
      |> Routex.Attrs.put(:rtx_2, "r2")

    new = Assigns.post_transform([route], Conf2, nil)

    assert [%{private: %{routex: %{assigns: %{rtx: %{rtx_1: "r1", rtx_2: "r2"}}}}}] = new
  end

  test "include only listed attrs in assigns" do
    route =
      %Phoenix.Router.Route{private: %{}}
      |> Routex.Attrs.put(:rtx_1, "r1")
      |> Routex.Attrs.put(:rtx_2, "r2")

    new = Assigns.post_transform([route], Conf3, nil)

    assert [%{private: %{routex: %{assigns: assigns}}}] = new
    assert assigns == %{rtx: %{rtx_1: "r1"}}
  end
end
