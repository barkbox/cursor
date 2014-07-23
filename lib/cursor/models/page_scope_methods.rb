module Cursor
  module PageScopeMethods
    # Specify the <tt>per_page</tt> value for the preceding <tt>page</tt> scope
    #   Model.page(3).per(10)
    def per(num)
      if (n = num.to_i) <= 0
        self
      elsif max_per_page && max_per_page < n
        limit(max_per_page)
      else
        limit(n)
      end
    end

    # TODO: are these 2 methods triggering multiple db hits? want to run this on cached result
    def next_cursor
      all.last.id
    end

    def prev_cursor
      all.first.id
    end
  end
end
