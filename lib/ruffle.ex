defmodule Ruffle do
  @moduledoc """
  Documentation for `Ruffle`.
  """

  @font_family "Helvetica"
  @font_size "18pt"
  @page_width 320
  @page_height 450
  @serial_1_position { 35, 58 }
  @serial_2_position { 35, 324 }
  @number_1_position { 35, 102 }
  @number_2_position { 35, 367 }

  def generate_pdf(background_image \\ "background.png", output_filename \\ "ruffle.pdf") do
    html =
      Sneeze.render([
        :html,
        [
          :body,
          %{
            style:
              style(%{
                "font-family" => @font_family,
                "font-size" => @font_size
              })
          },
          render_list(background_image, serial_numbers())
        ]
      ])

    {:ok, filename} = PdfGenerator.generate(html, page_width: @page_width, page_height: @page_height, shell_params: ["--dpi", "300"])

    File.rename(filename, output_filename)
  end

  defp style(style_map) do
    style_map
    |> Enum.map(fn {key, value} ->
      "#{key}: #{value}"
    end)
    |> Enum.join(";")
  end

  def image_path(background_image) do
    background_image
    |> Path.relative()
    |> Path.absname()
  end

  def serial_numbers do
    for serial_group <- 0..1, number <- 1..90, serial_decimal <- 1..10 do
      {serial_decimal + (serial_group * 10), number}
    end
  end

  defp render_list(background_image, items) do
    list = []
    list_items = Enum.map(items, fn(item) -> render_item(background_image, item) end) 
    list ++ list_items
  end

  defp render_item(background_image, {serial, number}) do
    [ 
      :div, 
      %{style: style(%{
        "position" => "relative",
        "text-align" => "center",
        "color" => "white",
        "float" => "left",
        "width" => "50%"
      })},
      [
        [
          :img,
          %{
            src: "file:///#{image_path(background_image)}",
            style:
              style(%{
                "width" => "100%"
              })
          }
        ],
        place_number(serial, @serial_1_position),
        place_number(number, @number_1_position),
        place_number(serial, @serial_2_position),
        place_number(number, @number_2_position),
      ]
    ]
  end

  defp place_number(number, { bottom, left }) do
    [
      :div,
      %{
        style:
          style(%{
            "position" => "absolute",
            "bottom" => "#{bottom}px",
            "left" => "#{left}px",
            "font-size" => "#{@font_size}px",
            "color" => "black"
          })
      }, 
      String.pad_leading("#{number}" , 2, "0")
    ]
  end
end
