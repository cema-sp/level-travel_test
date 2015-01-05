module FirstTestHelper
  def flights_and_nights_calendar(start_date, end_date, fan_hash)
    days_of_week = %w{ Пн Вт Ср Чт Пт Сб Вс }
    start_date = Date.parse(start_date) unless start_date.instance_of?(Date)
    end_date = Date.parse(end_date) unless end_date.instance_of?(Date)

    thead = 
      content_tag :thead do
        content_tag :tr do
          days_of_week.map do |dow|
            content_tag(:th, dow)
          end.join.html_safe
        end
      end

    tbody_cells = 
      ((1...start_date.cwday).map do
        content_tag :td do
          content_tag :strong, ' '
        end
      end) +

      ((start_date..end_date).map do |date|
        content_tag :td do
          if (nights = fan_hash[date.strftime('%Y-%m-%d')])
            (content_tag :strong, date.day) +
            (content_tag :p, nights.join(', '))
          else
            content_tag :strong, date.day
          end
        end
      end) +

      ((end_date.cwday.next..7).map do
        content_tag :td do
          content_tag :strong, ' '
        end
      end)

    tbody = 
      content_tag :tbody do
        tbody_cells.each_slice(7).to_a.map do |row|
          content_tag :tr, row.join.html_safe
        end.join.html_safe
      end
    
    content_tag :table,
      (thead + tbody),
      class: 'ui seven column table',
      id: 'calendar'
  end

  def cell_bg_color(max, value)
    k = value.to_f / max
    r, g, b = 255, 0, 0

    if k < 0.5
      g = 255 * k * 2
    elsif k > 0.5
      g = 255
      r = 255 * (1 - k) * 2
    else
      g = 255
    end
    "background-color: rgb(#{r.round}, #{g.round}, #{b});"
  end
end
