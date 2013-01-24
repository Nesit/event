$ ->
    $('.poll-item .graphs').each (_, graphs) ->
        $(graphs).find('.graph-item').each (_, graph) ->
            $item = $(graph)
            percent = parseInt $item.attr('data-percent')
            width = 278*(percent/70.0)
            $item.css('max-width', "#{width}px")

    # same for aside poll
    window.setup_small_poll_graphs = ->
        # max is 154px
        $('.point-radio-static').each (_, point) ->
            $item = $(point)
            percent = parseInt $item.attr('data-percent')
            width = 135*(percent/100.0)
            $item.find('.graph').css('min-width', "#{width}px")
    window.setup_small_poll_graphs()

    $('.poll-choices-select-list .point-radio').on 'click', ->
        id = $(this).attr("data-id")
        $('.poll-choices-select-list input[name="poll_vote[poll_choice_id]"]').val(id)
        $('.poll-choices-select-list .point-radio').removeClass('active')
        $(this).addClass('active')

    $('.poll-choices-select-list form').on 'ajax:beforeSend submit', (event) ->
        if $(this).find('input[name="poll_vote[poll_choice_id]"]').val() == ""
            return false

    $('#poll-aside form').on 'ajax:success', (event, data) ->
        $wrapper = $('.poll-choices-select-list .wrapper')
        height = $wrapper.height()  
        $wrapper.html('')
        $wrapper.append("<div class=\"notice\" style=\"height:#{height}px; line-height:#{height}px\">Ваш голос принят!</div>")

        put_results = ->
            $('#poll-aside').html(data)
            window.setup_small_poll_graphs()
        setTimeout(put_results, 1500)