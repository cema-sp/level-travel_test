module FirstTestHelper
  def cell_bg_color(max, value)
    k = value.to_f / max
    r = 255
    g = 0
    b = 0
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
