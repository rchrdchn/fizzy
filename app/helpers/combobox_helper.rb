module ComboboxHelper
  # `hw_combobox_tag` overrides HotwireCombobox's helper to provide default options.
  def hw_combobox_tag(...)
    super do |combobox|
      combobox.customize_main_wrapper class: "btn"
      combobox.customize_input data: { autofocus_target: "element" }
      yield combobox if block_given?
    end
  end
end
