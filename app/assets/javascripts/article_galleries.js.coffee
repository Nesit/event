setup_gallery_carousel = ($el) ->
    update_pagination_control = ->
        items = $el.find('.article-gallery-carousel').jcarousel('items')
        target = $el.find('.article-gallery-carousel').jcarousel('target')
        length = items.length
        current = items.index(target) + 1
        source = "<strong>#{current}</strong> из <strong>#{length}</strong>"
        $el.find('.article-gallery-pagination .pages-text').html(source)

        if current == 1
            $el.find('.article-gallery-pagination .page-left').removeClass('active')
        else
            $el.find('.article-gallery-pagination .page-left').addClass('active')

        if current == length
            $el.find('.article-gallery-pagination .page-right').removeClass('active')
        else
            $el.find('.article-gallery-pagination .page-right').addClass('active')

    id = $el.attr('data-id')
    $.ajax
        url: "/article_galleries/#{id}.html"
        success: (data) ->
            $el.html(data)

            $el.find('.article-gallery-carousel').jcarousel()
            $el.find('.article-gallery-carousel').jcarousel('scroll', 0)
            update_pagination_control()

            $el.find('.article-gallery-pagination .page-left').on 'click', (event) ->
                $el.find('.article-gallery-carousel').jcarousel('scroll', '-=1')
                event.preventDefault()

            $el.find('.article-gallery-pagination .page-right').on 'click', (event) ->
                $el.find('.article-gallery-carousel').jcarousel('scroll', '+=1')
                event.preventDefault()

            $el.find('.article-gallery-carousel').on 'scrollend.jcarousel', (event, carousel) ->
                update_pagination_control()

$ ->
    $('.article-body-gallery').each (i, e) ->
        setup_gallery_carousel($(e))