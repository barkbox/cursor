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
      @_next_cursor ||= all.last.id
    end

    def prev_cursor
      @_prev_cursor ||= all.first.id
    end

    def next_url request_url, query_params
      direction == :after ? 
        after_url(request_url, query_params, next_cursor) :
        before_url(request_url, query_params, next_cursor)
    end

    def prev_url request_url, query_params
      direction == :after ? 
        before_url(request_url, query_params, prev_cursor) :
        after_url(request_url, query_params, prev_cursor)
    end

    def before_url request_url, query_params, cursor
      "#{request_url}?#{query_params.merge(Cursor.config.before_param_name => cursor).to_query}"
    end

    def after_url request_url, query_params, cursor
      "#{request_url}?#{query_params.merge(Cursor.config.after_param_name => cursor).to_query}"
    end

    def url_parts request_url
    end

    def direction
      @_direction ||= prev_cursor < next_cursor ? :after : :before
    end

    def pagination request_url, query_params
      query_params.delete(:after)
      query_params.delete(:before)
      request_params ||= {}
      {
        next_cursor: next_cursor,
        prev_cursor: prev_cursor,
        next_url: next_url(request_url, query_params),
        prev_url: prev_url(request_url, query_params)
      }
    end
  end
end
