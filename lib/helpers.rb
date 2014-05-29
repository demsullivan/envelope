module Helpers

  def js(path)
    %Q{<script src="#{path}"></script>}
  end

  def css(path)
    %Q{<link rel="stylesheet" type="text/css" href="#{path}" />}
  end

  def link(title, href = "")
    if block_given?
      %Q{<a href="#{title}">#{yield}</a>}
    else
      %Q{<a href="#{href}">#{title}</a>}
    end
  end

  def as_money(val)
    "$%.2f" % val
  end

end
