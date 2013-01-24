module HtmlSelectorsHelper
  def selector_for(scope)
    case scope
    when /the body/
      "html > body"

    when /submit button/
      "input[type=submit]"

    when /login link/
      ".login-link"
    when /login dialog/
      "#auth-block #login-dialog"
    when /login form/
      "#auth-block #login-dialog form"

    when /register link/
      "#auth-block .register-link"
    when /register dialog/
      "#auth-block #register-dialog"
    when /register form/
      "#auth-block #register-dialog form"

    when /comment form/
      "#top-comment-form"
    when /comment text area/
      "#top-comment-form textarea"
    
    else
      raise "Can't find mapping from \"#{scope}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelper)