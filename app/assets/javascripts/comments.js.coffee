$ ->
    $(document).on 'click', '#top-comment-form textarea.auth-required', ->
        if $(this).attr('readonly')
            window.show_login_dialog()
            return false

    topic_type = $('#comment_topic_type').val()
    topic_id = $('#comment_topic_id').val()

    window.comments_page = 1
    load_more_comments = ->
        return if window.comments_loading
        return if window.comments_all_loaded

        window.comments_loading = true
        window.comments_page += 1
        $.ajax
            url: '/comments.html'
            data:
                topic_type: topic_type
                topic_id: topic_id
                page: window.comments_page
            complete: ->
                window.comments_loading = false
            success: (data) ->
                if data == ''
                    window.comments_all_loaded = true
                else
                    $('.comments-list').append(data)

    if $('.comments-list').length != 0
        $(window).on 'scroll', (event) ->
            y_offset = window.pageYOffset
            comments_y_offset = $('.comments-list').position().top + $('.comments-list').height()
            load_more_comments() if comments_y_offset - y_offset < 300

    $(document).on 'click', '.edit-comment-link', (event) ->
        event.preventDefault()
        $item = $(this).closest('.comment')

        $show = $item.find('.comment-show-state').first()
        $edit = $item.find('.comment-edit-state').first()
        
        $show.addClass('hidden')
        $edit.removeClass('hidden')
        $edit.find('textarea').val($show.find('p').first().html())
        
        $(this).hide()

    $(document).on 'click', '.delete-comment-link', (event) ->
        event.preventDefault()
        $item = $(this).closest('.comment')

        $show = $item.find('.comment-show-state').first()
        $edit = $item.find('.comment-edit-state').first()
        $deleted = $item.find('.comment-removed-by-user-state').first()
        
        $show.addClass('hidden')
        $edit.addClass('hidden')
        $deleted.removeClass('hidden')

        $(this).hide()
        $item.find('.edit-comment-link').hide()

    $(document).on 'ajax:success', '.comment-edit-state form', (event) ->
        content = $(this).find('textarea').val()
        $(this).closest('.comment-edit-state').addClass('hidden')
        
        $show = $(this).closest('.comment').find('.comment-show-state')
        $show.find('p').first().html(content)
        $show.removeClass('hidden')

        $(this).closest('.comment').find('.edit-comment-link').show()

    $(document).on 'click', '.comment-reply-link', (event) ->
        $item = $(this).closest('.comment')
        $form = $item.find('.comment-reply-block form')
        $form.removeClass('hidden')
        $form.find('textarea').val('')
        $(this).parent().addClass('hidden')
        event.preventDefault()

    $(document).on 'ajax:success', '.comment-reply-block form', (event, data) ->
        $item = $(this).closest('.comment')
        $item.find('.comment-tree').prepend(data)
        $item.find('.comment-reply-link').parent().removeClass('hidden')
        $item.find('.comment-reply-block form').addClass('hidden')

    $(document).on 'ajax:success', '#top-comment-form', (event, data) ->
        $('.comments-list .comment-tree').first().prepend(data)
        $(this).find('textarea').val('')

    $(document).on 'submit', '.comments-list form', (event) ->
        if $(this).find('textarea').val() == ""
            event.preventDefault()