$ ->
    item_template = (item, allow_nested) ->
        add_nested_link =
            if allow_nested
                '<a href="#" class="add-nested-menu-link">дочерний</a>'
            else
                ''
        children = ''
        if item.item.children
            items = []
            item.item.children.map (e, i) ->
                items.push item_template(e, false)
            children = items.join()
        """
            <div class="menu-item" data-kind="#{item.item.kind}" data-data="#{item.item.data}">
                <a href="#{item.link}" target="_blank" class="out-link">Ссылка</a>
                #{add_nested_link}
                <input type="text" value="#{item.item.title or ''}" />
                <a href="#" class="remove-menu-link">X</a>
                <div class="children">#{children}</div>
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

    save_top_menu = ->
        $input = $('#top-menu-edit-block input[name="site_config[top_menu]"]')
        items = []
        $('#top-menu-edit-block .menu-edit-area > .menu-item').each (i, e) ->
            data = $(e).attr('data-data')
            kind = $(e).attr('data-kind')
            title = $(e).find('input').val()
            children = []
            $(e).find('.children .menu-item').each (i, e) ->
                data2 = $(e).attr('data-data')
                kind2 = $(e).attr('data-kind')
                title2 = $(e).find('input').val()
                children.push(data: data2, kind: kind2, title: title2)
            items.push(data: data, kind: kind, title: title, children: children)
        $input.val(JSON.stringify(items))
    
    $('.menu-edit-area').disableSelection()

    $(document).on 'click', '.menu-edit-area .menu-item .remove-menu-link', (event) ->
        event.preventDefault()
        $(this).parent().remove()
        save_top_menu()
        save_bottom_menu()

    $(document).on 'change', '#top-menu-edit-block input[type=text]', (event) ->
        save_top_menu()

    $(document).on 'change', '#bottom-menu-edit-block input[type=text]', (event) ->
        save_bottom_menu()

    $bottom_block = $('#bottom-menu-edit-block')
    unless $bottom_block.length == 0
        $bottom_block.find('.menu-edit-area').sortable
            stop: (event, ui) ->
                save_bottom_menu()
        
        data = $bottom_block.find('input[name="site_config[bottom_menu]"]').val()
        items = JSON.parse(data)
        $bottom_area = $bottom_block.find('.menu-edit-area')
        for item in items
            $bottom_area.append(item_template(item, false))
        
        save_bottom_menu()

        $bottom_block.on 'click', '.admin-add-menu-element-link', (event) ->
            event.preventDefault()
            url = $('#bottom-menu-url-field').val()
            $.ajax
                url: '/menu_items/new'
                data: { url: url }
                success: (data) ->
                    $bottom_area.prepend(item_template(data, false))
                    save_bottom_menu()

    $top_block = $('#top-menu-edit-block')
    
    unless $top_block.length == 0
        $top_block.find('.menu-edit-area').sortable
            stop: (event, ui) ->
                save_top_menu()
        
        data = $top_block.find('input[name="site_config[top_menu]"]').val()
        items = JSON.parse(data)
        $top_area = $top_block.find('.menu-edit-area')
        for item in items
            $area.append(item_template(item, true))
            $last = $top_area.find('.menu-item .children').last()
            $last.disableSelection()
            $last.sortable
                stop: (event, ui) ->
                    save_top_menu()
        
        save_top_menu()

        $top_block.on 'click', '.admin-add-menu-element-link', (event) ->
            event.preventDefault()
            url = $('#top-menu-url-field').val()
            $.ajax
                url: '/menu_items/new'
                data: { url: url }
                success: (data) ->
                    $top_area.prepend(item_template(data, true))
                    $first = $top_area.find('.menu-item .children').first()
                    $first.disableSelection()
                    $first.sortable
                        stop: (event, ui) ->
                            save_top_menu()
                    save_top_menu()

        $(document).on 'click', '.menu-edit-area > .menu-item .add-nested-menu-link', (event) ->
            event.preventDefault()
            $item = $($(this).parent())

            $item.find('.children').prepend()
            url = $('#top-menu-url-field').val()
            $.ajax
                url: '/menu_items/new'
                data: { url: url }
                success: (data) ->
                    $item.find('.children').first().prepend(item_template(data, false))
                    save_top_menu()

        