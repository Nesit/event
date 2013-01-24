module FormsHelper
  def point_checkbox_tag(description)
    code = <<-HTML
      <div class="point-checkbox-static">
        <div class="-icon left"></div>
        <p class="left">#{description}</p>
        <div class="clear"></div>
      </div>
    HTML
    code.html_safe
  end

  def point_checkbox_field(f, sym, description)
    code = <<-HTML
      <div class="point-checkbox#{f.object.send(sym) ? ' active' : ''}">
        #{f.hidden_field sym}
        <div class="-icon left"></div>
        <p class="left">#{description}</p>
        <div class="clear"></div>
      </div>
    HTML
    code.html_safe
  end
end