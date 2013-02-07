window.show_register_dialog = ->
    # need to enclose val('') with focus and blur events
    # to do not break placeholder plugin
    $inputs = $('#register-dialog').find('input[name="user[email]"], input[name=captcha]')
    $inputs.trigger('focus')
    $inputs.val('')
    $inputs.trigger('blur')

    $('#register-dialog-message').html(
        """Введите ваш email и код подтверждения,
           затем мы вам сгенерируем пароль и вышлем
           на указанный адрес""")
    $('.dialog.closable').addClass('hidden')
    $('#register-dialog').removeClass('hidden')
    $('#dialog-overlay').addClass('active')

window.show_register_thanks_dialog = ->
    $('.dialog.closable').addClass('hidden')
    $('#register-thanks-dialog').removeClass('hidden')
    $('#dialog-overlay').addClass('active')


window.show_login_dialog = ->
    $inputs = $('#login-dialog').find('input[name=email], input[name=password]')
    $inputs.trigger('focus')
    $inputs.val('')
    $inputs.trigger('blur')

    $('.dialog.closable').addClass('hidden')
    $('#login-dialog').removeClass('hidden')
    $('#dialog-overlay').addClass('active')

window.show_subscribe_dialog = ->
    $inputs = $('#subscribe-dialog').find('input[name=email], input[name=captcha]')
    $inputs.trigger('focus')
    $inputs.val('')
    $inputs.trigger('blur')

    $('.dialog.closable').addClass('hidden')
    $('#subscribe-dialog').removeClass('hidden')
    $('#dialog-overlay').addClass('active')

window.show_email_dialog = ->
    $('.dialog.closable').addClass('hidden')
    $('#email-dialog').removeClass('hidden')
    $('#dialog-overlay').addClass('active')

window.update_csrf_token = (value) ->
    $('meta[name=csrf-token]').attr('content', value)
    $('input[name=authenticity_token]').val(value)

window.is_email_valid = (email) -> /.+\@.+\..+/.test(email)

$ ->
    $('#dialog-overlay').on 'click', (event) ->
        return if $('.dialog.closable').length == 0
        $('.dialog.closable').addClass('hidden')
        $('#dialog-overlay').removeClass('active')

    $(document.body).on 'click', '.login-link', (event) ->
        window.show_login_dialog()
        event.preventDefault()


    $(document.body).on 'click', '.register-link', (event) ->
        window.show_register_dialog()
        event.preventDefault()

    $('.dialog').on 'click', (event) ->
        #event.stopPropagation()
        console.log('click')

    $('.dialog .close-link').on 'click', (event) ->
        $(this).closest('.dialog.closable').addClass('hidden')
        $('#dialog-overlay').removeClass('active')
        event.preventDefault()

    check_login_dialog_fields = ->
        $form = $('#login-dialog form')
        email = $form.find('input[name=email]').val()

        return "Поле email не заполнено" unless email
        return "Поле email не соответсвует формату" unless window.is_email_valid(email)


    used_map = {}
    check_register_dialog_fields = ->
        $form = $('#register-dialog form')
        email = $form.find('input[name="user[email]"]').val()
        captcha = $form.find('input[name=captcha]').val()

        if not email and not captcha
            $('#register-dialog-message').html("Поля не заполнены")
            return false

        unless email
            $('#register-dialog-message').html("Поле email не заполнено")
            return false

        if email and not window.is_email_valid(email)
            $('#register-dialog-message').html("После email не соответствует формату")
            return false

        unless captcha
            $('#register-dialog-message').html("Код подтверждения не введён")
            return false

        if window.register_email_used
            $('#register-dialog-message').html(
                'Пользователь с таким email уже существует<br>
                 <a href="#" class="login-link">Пройдите авторизацию</a>')
            return false
        else
            # all is ok, just put std message
            $('#register-dialog-message').html("")
            return true

    $('#register-dialog form input[name="user[email]"]').on 'keyup', ->
        clearTimeout(window.register_email_timeout) if window.register_email_timeout

        email = $(this).val()
        return unless email
        return unless window.is_email_valid(email)

        check = ->
            $.ajax
                url: '/profile/email'
                data: { email: email }
                success: (data) ->
                    $('#register-dialog form input[name="user[email]"]').removeClass('loader')
                    if data.used
                        window.register_email_used = true   
                        $('#register-dialog-message').html(
                            'Пользователь с таким email уже существует<br>
                             <a href="#" class="login-link">Пройдите авторизацию</a>')
                    else
                        window.register_email_used = false
                        check_register_dialog_fields()
        $('#register-dialog form input[name="user[email]"]').addClass('loader')
        window.register_email_timeout = setTimeout(check, 1000)

    $('#register-dialog form').find('input[name="user[email]"], input[name=captcha]').on 'keyup', ->
        check_register_dialog_fields()

    $('#register-dialog form').on 'ajax:beforeSend', (event) ->
        return false unless check_register_dialog_fields()

    $('#login-dialog form').on 'ajax:beforeSend', (event) ->
        message = check_login_dialog_fields()
        if message
            $('#login-dialog-message').html(message)
            return false

    $('#register-dialog form').on 'ajax:success', (event, data) ->
        window.show_register_thanks_dialog()

    $('#register-dialog form').on 'ajax:error', (event, data) ->
        $el = $(data.responseText)
        captcha_src = $el.find('img[alt=captcha]').attr('src')
        $('#register-dialog form img[alt=captcha]').attr('src', captcha_src)
        $('#register-dialog-message').html("Неправильно введён код с картинки")

    $('#login-dialog form').on 'ajax:beforeSend', (event) ->
        $('#login-dialog input[name=email]').addClass('loader')

    $('#login-dialog form').on 'ajax:success', (event, data) ->
        $('.dialog.closable').addClass('hidden')
        $('#dialog-overlay').removeClass('active')
        $('#auth-block').html(data)
        value = $('#auth-block meta[name=csrf-token]').attr('content')
        window.update_csrf_token(value)

        # allow comment
        $('.comments-list input[type=submit]').removeClass('hidden')
        $('.comments-list .notice').addClass('hidden')
        $('.comments-list .comment-reply-block').removeClass('hidden')

        # allow vote
        $('#poll-aside .poll-choices-select-list input[type=submit]').removeClass('auth-required')
        $('.polls-list input[type=submit]').removeClass('auth-required')

    $('#login-dialog form').on 'ajax:error', ->
        f = ->
            $('#login-dialog input[name=email]').removeClass('loader')
            $('#login-dialog-message').html("Неправильный email или пароль")
        setTimeout(f, 1000)

    $(document.body).on 'click', '.auth-required', (event) ->
        window.show_login_dialog()
        false

    if $.cookie('need_email')
        window.show_email_dialog()

    $('#email-dialog form').on 'ajax:success', ->
        console.log('success')
        $('#email-dialog').addClass('hidden')
        $('#dialog-overlay').removeClass('active')

    $('#email-dialog form').on 'ajax:error', ->
        $('#email-dialog-message').html("Email введён неверно, либо уже используется")

    # captcha reload
    $('.reload-captcha-link').on 'click', (event) ->
        $img = $(this).parent().find('img[alt=captcha]')

        # stupid reassignment to force reload
        src = $img.attr('src')
        $img.attr('src', src)
        event.preventDefault()
