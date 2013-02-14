$ ->
    $(window).on 'scroll', (event) ->
        footer_y_offset = $('#wide-footer').position().top
        y_offset = window.pageYOffset
    
        if footer_y_offset < (y_offset + 500)
            $('.subscribe-aside-link').hide()
            $('#left-banner').hide()
            $('#left-social-line').hide()
        else
            $('.subscribe-aside-link').show()
            $('#left-banner').show()
            $('#left-social-line').show()

    $(window).trigger('scroll') # to hide initialy, if need