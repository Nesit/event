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

    # setup useless clock in header
    if $('#utmost-left-block .current-time').length != 0
        update_clock = ->
            d = new Date()
            
            seconds = "" + d.getSeconds()
            minutes = "" + d.getMinutes()
            hours = "" + d.getHours()

            seconds = '0' + seconds if seconds < 10
            minutes = '0' + minutes if minutes < 10
            hours = '0' + hours if hours < 10

            str = "#{hours}:#{minutes}:#{seconds}"
            $('#utmost-left-block .current-time').html(str)
        setInterval(update_clock, 1000)