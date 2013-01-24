$ ->
    $('.article-body-video').each (i, e) ->
        code = $(e).attr('data-code')
        html = """<iframe width="570" height="310" src="http://www.youtube.com/embed/#{code}?wmode=opaque" frameborder="0" allowfullscreen></iframe>"""
        $(e).html(html)