$ ->
    update_price_per_month = ->
        return if $('.subscription-kind-select .-item.active').length == 0
        months = $('.subscription-kind-select .-item.active').attr('data-months-count')
        period_price = $('.subscription-kind-select .-item.active p .price').html()
        price = Math.round(parseInt(period_price)/parseInt(months))
        $('#subscription-content p.payment .per-month-price').html(price)

    $('#subscription-content .point-checkbox').on 'click', ->
        is_advanced = $(this).find('input').val() == 'true'
        $('.subscription-kind-select .-item').each (i, e) ->
            if is_advanced
                price = $(this).attr('data-advanced-price')
                $(this).find('p .price').html(price)
            else
                price = $(this).attr('data-default-price')
                $(this).find('p .price').html(price)
        update_price_per_month()

    $('.subscription-kind-select .-item a').on 'click', (event) ->
        event.preventDefault()

    $('.subscription-kind-select .-item').on 'click', ->
        $item = $(this)
        value = $item.attr('data-value')
        is_advanced = $('#subscription-content .point-checkbox input').val() == 'true'

        $('.subscription-kind-select input[type=hidden]').val(value)

        $('#subscription-content p.payment').css('visibility', 'visible')

        $('.subscription-kind-select .-item').removeClass('active')
        $item.addClass('active')
        $('#subscription-content input[type=submit]').removeClass('disabled')

        update_price_per_month()

    $('#subscription-content form').on 'submit', (event) ->
        return false if $(this).find('input[type=submit]').hasClass('disabled')
        # if logged in, proceed as usual
        return if $('#auth-block .profile-link').length != 0

        $base_form = $(this)
        $dialog_form = $('#subscribe-dialog form')
        $dialog_form.find('input[name="subscription[kind]"]')
            .val($base_form.find('input[name="subscription[kind]"]').val())
        $dialog_form.find('input[name="subscription[print_versions_by_courier]"]')
            .val($base_form.find('input[name="subscription[print_versions_by_courier]"]').val())

        window.show_subscribe_dialog()
        event.preventDefault()

    $('#subscribe-dialog form, #subscription-content form').on 'ajax:success', (event, data) ->
        window.location.href = data.url

    $('#subscribe-dialog form').on 'ajax:error', (event, data) ->
        $('#subscribe-dialog-message').html("Неверно введён код")
        # just to force to reload it
        $('#subscribe-dialog img[alt=captcha]')
            .attr('src', $('#subscribe-dialog img[alt=captcha]').attr('src'))
        $('#subscribe-dialog form input[name=captcha]').val('')

    $('#subscribe-dialog form input[name="email"]').on 'keyup', (event) ->
        return unless window.is_email_valid($(this).val())
        
        return if window.ensureEmailLock
        window.ensureNameLock = true
        $input = $(this)
        $input.addClass('loader')
        func = =>
            $.ajax
                url: '/profile/email.json'
                data: { email: $input.val() }
                success: (data) ->
                    if data.used
                        $('#subscribe-dialog-message').html("На данную почту уже есть зарегистрированая учётная запись, если вы уверены что это ваш e-mail, то продолжайте")
                    else
                        $('#subscribe-dialog-message').html("Введите ваш email и код подтверждения")
                complete: ->
                    window.ensureEmailLock = false
                    $input.removeClass('loader')
        setTimeout(func, 2000)