$ ->
    # global var where stored fetched lists of cities
    window.cities = {}

    check_for_required_fields = ->
        all_filled = true
        $('#user-profile-form .required').map (i, e) ->
            value = $(e).val()
            if value == "" || value == undefined || value == null
                all_filled = false
                return
        if all_filled
            $('#user-profile-form .notice').css('visibility', 'hidden')
        else
            $('#user-profile-form .notice').css('visibility', 'visible')

    setup_city_select = (country_cd) ->
        html_parts = []
        for city in window.cities[country_cd]
            html_parts.push "<option value=\"#{city.id}\">#{city.name}</option>"
        $('#user-profile-form select[name="user[city_id]"]').html(html_parts.join())
        $('#user-profile-form select[name="user[city_id]"]').trigger("liszt:updated")
        $('#user-profile-form select[name="user[city_id]"]').addClass("required")
        $('#user-profile-form .chzn-container').on 'click keyup', ->
            check_for_required_fields()

    $(document).on 'change', '#user-profile-form .required', ->
        check_for_required_fields()

    $('#user-profile-form select[name="user[new_country_cd]"]').on 'change', (event) ->
        country_cd = $(this).val()
        if window.cities[country_cd]
            setup_city_select(country_cd)
        else
            $.ajax
                url: '/cities.json'
                data: { country_cd: country_cd }
                success: (data) ->
                    window.cities[country_cd] = data
                    setup_city_select(country_cd)
    $('#user-profile-form select[name="user[new_country_cd]"]').trigger('change')

    #$('#user-profile-form select[name="user[new_country_cd]"]').trigger('change')
    $('#user-profile-form select[name="user[city_id]"]').chosen
        no_results_text: "Этого города нет в базе, нажмите ввод, чтобы добавить"

    $('#user-profile-form .chzn-single').css('width','200px');
    $('#user-profile-form .chzn-drop').css('width','208px');
    $('#user-profile-form .chzn-search input').css('width','173px');

    $('#user-profile-form .chzn-search input').on 'keydown', (event) ->
        if event.which == 13 and $('#user-profile-form .chzn-results .active-result').length == 0
            name = $(this).val().trim()
            return if name == ''
            html = "<option value=\"-1\">#{name}</option>"
            $('#user-profile-form input[name="user[new_city]"]').val(name)
            $('#user-profile-form select[name="user[city_id]"]').prepend(html)
            $('#user-profile-form select[name="user[city_id]"]').trigger("liszt:updated");
            chosen = $('#user-profile-form select[name="user[city_id]"]').data('chosen')
            result = $('#user-profile-form .chzn-results .active-result').first()
            chosen.result_do_highlight(result)
            chosen.result_select(result)
    
    $('#user-profile-form input[name="user[name]"]').on 'keyup', (event) ->
        return if window.ensureNameLock
        window.ensureNameLock = true
        $input = $(this)
        $input.addClass('loader')
        func = =>
            $.ajax
                url: '/profile/name.json'
                data: { name: $(this).val() }
                success: (data) ->
                    if data.free
                        $('#user-ensure-name-message').addClass('hidden')
                        #$('#user-ensure-name-message').html("Это имя свободно")
                    else
                        $('#user-ensure-name-message').removeClass('hidden')
                        $('#user-ensure-name-message').html("Имя уже используется")
                complete: ->
                    window.ensureNameLock = false
                    $input.removeClass('loader')
        setTimeout(func, 1000)

    $('#user-profile-form .profile-gender-select a').on 'click', (event) ->
        val = $(this).attr('data-value')
        $('#user-profile-form input[name="user[gender_cd]"]').val(val)
        $('#user-profile-form .profile-gender-select a').removeClass('active')
        $(this).addClass('active')

        event.preventDefault()

    check_for_required_fields()