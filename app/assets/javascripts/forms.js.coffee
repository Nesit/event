$ ->
    $('.point-checkbox').on 'click', (event) ->
        if $(this).hasClass('active')
            $(this).removeClass('active')
            $(this).find('input').val(false)
        else
            $(this).addClass('active')
            $(this).find('input').val(true)