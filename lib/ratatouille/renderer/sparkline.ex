defmodule Ratatouille.Renderer.Sparkline do
  @moduledoc false

  alias Ratatouille.Renderer.{Canvas, Text}

  @ticks ~w[▁ ▂ ▃ ▄ ▅ ▆ ▇ █]
  @range length(@ticks) - 1

  def render(%Canvas{} = canvas, %{series: series}) do
    text =
      series
      |> normalize()
      |> Enum.map(fn idx -> Enum.at(@ticks, idx) end)
      |> Enum.join()

    canvas
    |> Text.render(canvas.box.top_left, text)
    |> Canvas.consume_rows(1)
  end

  def render(%Canvas{} = canvas, _other), do: canvas

  defp normalize(values) do
    min = Enum.min(values)
    max = Enum.max(values)

    values
    |> Enum.map(&normalize({min, max}, &1))
  end

  defp normalize({min, max}, value) do
    x = (value - min) / (max - min)
    round(x * @range)
  end
end
