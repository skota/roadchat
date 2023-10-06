defmodule Roadchat.UtilHelpers do
  use Timex
  # alias Roadchat.Repo


  def format_dt(nil) do
    "n/a"
  end

  def format_dt(dt) do
    {:ok, formatted_date} = Timex.format(dt, "{0M}-{D}-{YYYY}")
    formatted_date
  end

  # format currency
  def format_amt(amt) do
    {:ok, formatted_amt} = Roadchat.Cldr.Number.to_string(amt, locale: "en", currency: "USD")
    formatted_amt
  end

  # generate MTCN like number
  def generate_control_number() do
    # IO.puts "inside control number"
    first = Enum.random(1_00_000..9_99_999)
    second = Enum.random(1_00_000..9_99_999)
    Integer.to_string(first) <> "-" <> Integer.to_string(second)
  end


  def datetime_from_string(date_string) do
    # split into parts
    dt_parts = date_string |> String.split("-")

    {from_yr, ""} = Enum.at(dt_parts,0) |> Integer.parse()
    {from_month, ""} = Enum.at(dt_parts,1) |> Integer.parse()
    {from_day, ""} = Enum.at(dt_parts,2) |> Integer.parse()

    Timex.to_datetime({{from_yr,from_month,from_day},{0,0,0}}, "ETC/Utc")
  end

  def datetime_from_string_without_timezone(date_string) do
    # split into parts
    dt_parts = date_string |> String.split("-")

    {from_yr, ""} = Enum.at(dt_parts,0) |> Integer.parse()
    {from_month, ""} = Enum.at(dt_parts,1) |> Integer.parse()
    {from_day, ""} = Enum.at(dt_parts,2) |> Integer.parse()

    # Timex.to_datetime({{from_yr,from_month,from_day},{0,0,0}})
    Timex.to_naive_datetime({from_yr,from_month,from_day})
  end


  def date_from_string(date_string) do
    IO.puts date_string
    # split into parts
    dt_parts = date_string |> String.split("-")

    {from_yr, ""} = Enum.at(dt_parts,0) |> Integer.parse()
    {from_month, ""} = Enum.at(dt_parts,1) |> Integer.parse()
    {from_day, ""} = Enum.at(dt_parts,2) |> Integer.parse()

    Timex.to_date({from_yr,from_month,from_day})
  end


  # ecto helpers
  def return_errors(%Ecto.Changeset{} = cs) do
    errors = changeset_error_to_string(cs)
    {:error, errors}
  end

  def changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}\n"
    end)
  end
end
