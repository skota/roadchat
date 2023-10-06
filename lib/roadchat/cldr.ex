defmodule Roadchat.Cldr do
  use Cldr,
    default_locale: "en",
    json_library: Jason,
    locales: ["en", "zh"],
    gettext: Roadchat.Gettext,
    data_dir: "./priv/cldr",
    otp_app: :roadchat,
    precompile_number_formats: ["¤¤#,##0.##"],
    providers: [Cldr.Number],
    generate_docs: true
end
