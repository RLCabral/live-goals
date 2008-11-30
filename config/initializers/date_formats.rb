my_formats = {
  :my_date_1 => '%H:%M, %b %d',
  :my_date_2  => '%l:%M %p, %b %d, %Y'
}

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(my_formats)
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(my_formats)

