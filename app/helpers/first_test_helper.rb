module FirstTestHelper
  def flights_and_nights_calendar(start_date, end_date, fan_hash)
    days_of_week = %w(Пн Вт Ср Чт Пт Сб Вс)
    start_date = Date.parse(start_date) unless start_date.instance_of?(Date)
    end_date = Date.parse(end_date) unless end_date.instance_of?(Date)

    tbody_cells =
      flights_and_nights_calendar_tbody_cells(start_date, end_date, fan_hash)

    content_tag :table,
                flights_and_nights_calendar_thead(days_of_week) +
                  flights_and_nights_calendar_tbody(tbody_cells, 7),
                class: 'ui seven column table',
                id: 'calendar'
  end

  def cell_bg_color(max, value)
    k = value.to_f / max
    r, g, b = 255, 0, 0

    if k < 0.5
      g = 255 * k * 2
    elsif k > 0.5
      r, g = 255 * (1 - k) * 2, 255
    else
      g = 255
    end
    "background-color: rgb(#{r.round}, #{g.round}, #{b});"
  end

  private

  def flights_and_nights_calendar_thead(days_of_week)
    content_tag :thead do
      content_tag :tr do
        days_of_week.map do |dow|
          content_tag(:th, dow)
        end.join.html_safe
      end
    end
  end

  def flights_and_nights_calendar_tbody(tbody_cells, slice_size)
    content_tag :tbody do
      tbody_cells.each_slice(slice_size).to_a.map do |row|
        content_tag :tr, row.join.html_safe
      end.join.html_safe
    end
  end

  def flights_and_nights_calendar_tbody_cells(start_date, end_date, fan_hash)
    flights_and_nights_calendar_tbody_empty_cells(start_date.cwday - 1) +
      flights_and_nights_calendar_tbody_cell(start_date, end_date, fan_hash) +
      flights_and_nights_calendar_tbody_empty_cells(7 - end_date.cwday)
  end

  def flights_and_nights_calendar_tbody_cell(start_date, end_date, fan_hash)
    max_nights = fan_hash.max_by { |pair| pair[1].size }[1].size
    (start_date..end_date).map do |date|
      nights = fan_hash[date.strftime('%Y-%m-%d')]
      nights_count = nights.nil? ? 0 : nights.size

      content_tag :td, class: cell_bg_color(max_nights, nights_count) do
        if nights
          (content_tag :strong, date.day) +
            (content_tag :p, nights.join(', '))
        else
          content_tag :strong, date.day
        end
      end
    end
  end

  def flights_and_nights_calendar_tbody_empty_cells(count)
    count.times.map { flights_and_nights_calendar_tbody_empty_cell }
  end

  def flights_and_nights_calendar_tbody_empty_cell
    content_tag :td, class: cell_bg_color(1, 0) do
      content_tag :strong, ' '
    end
  end
end
