$ ->
    $('.article-body-video').each (i, e) ->
        code = $(e).attr('data-code')
        kind = $(e).attr('data-kind')
        if kind == 'youtube'
            html = """
                <iframe width="575" height="384"
                    src="http://www.youtube.com/embed/#{code}?wmode=opaque"
                    frameborder="0" allowfullscreen>
                </iframe>
            """
            $(e).html(html)
            return

        if kind == 'vimeo'
            html = """
                <iframe src="http://player.vimeo.com/video/#{code}"
                    width="575" height="384" frameborder="0"
                    webkitAllowFullScreen mozallowfullscreen allowFullScreen>
                </iframe>
            """
            $(e).html(html)
        