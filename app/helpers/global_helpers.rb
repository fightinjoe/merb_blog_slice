module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  
    def print_date( date )
      months = %w(x Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec)
      '<div class="date"><span class="day">%.2d </span><span class="month">%s </span><span class="year">%s</span></div>' %
        [ date.day, months[date.month], date.year ]
    end
  end
end
