$ ->
    item_template = (item, allow_nested) ->
        add_nested_link =
            if allow_nested
                '<a href="#" class="add-nested-menu-link">дочерний</a>'
            else
                ''
        """
            <div class="menu-item" data-kind="#{item.item.kind}" data-data="#{item.item.data}">
                <a href="#{item.link}" target="_blank" class="out-link">Ссылка</a>
                #{add_nested_link}
                <input type="text" value="#{item.item.title}" />
                <a href="#" class="remove-menu-link">X</a>
            </div>
        """

    save_bottom_menu = ->
        $input = $('#bottom-menu-edit-block input[name="site_config[bottom_menu]"]')
        items = []
        $('#bottom-menu-edit-block .menu-edit-area .menu-item').each (i, e) ->
            data = $(e).attr('data-data')
            kind = $(e).attr('data-kind')
            title = $(e).find('input').val()
            items.push(data: data, kind: kind, title: title)
        $input.val(JSON.stringify(items))
    
    $('.menu-edit-area').disableSelection()

    $(document).on 'click', '.menu-edit-area .menu-item .remove-menu-link', (event) ->
        event.preventDefault()
        $(this).parent().remove()

    $bottom_block = $('#bottom-menu-edit-block')
    unless $bottom_block.length == 0
        $bottom_block.find('.menu-edit-area').sortable
            stop: (event, ui) ->
                save_bottom_menu()
        
        data = $bottom_block.find('input[name="site_config[bottom_menu]"]').val()
        items = JSON.parse(data)
        $area = $bottom_block.find('.menu-edit-area')
        for item in items
            $area.append(item_template(item, false))
        
        save_bottom_menu()

        $bottom_block.on 'click', '.admin-add-menu-element-link', (event) ->
            event.preventDefault()
            url = $('#bottom-menu-url-field').val()
            $.ajax
                url: '/menu_items/new'
                data: { url: url }
                success: (data) ->
                    $area.append(item_template(data, false))
                    save_bottom_menu()

        