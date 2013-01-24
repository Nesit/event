setup_index_carousel = ->
    $('.carousel-list .carousel-list-item a').on 'mouseenter', ->
        item_id = $(this).attr('data-item-id')
        $('.carousel-content .carousel-content-item').addClass('hidden')
        $("##{item_id}").removeClass('hidden')
        $('.carousel-list .carousel-list-item').removeClass('active')
        $(this).parent().addClass('active')

    $('.carousel-list .carousel-list-item a').first().trigger('mouseenter')

setup_afisha_carousel = ->
    $('.afisha-list .afisha-item').on 'mouseenter', ->
        $('.afisha-list .afisha-item').removeClass('active')
        $(this).addClass('active')
        image_src = $(this).attr('data-item-image-url')
        $('.afisha-description img').attr('src', image_src)
    $('.afisha-list .afisha-item').first().trigger('mouseenter')

$ ->
    setup_index_carousel()
    setup_afisha_carousel()