select_gallery = (composer, id) ->
    $link = $(composer.iframe).parent().find('.gallery-edit-link')
    $link.attr('href', "/admin/article_galleries/#{id}/edit")
    $link.show()

deselect_gallery = (composer) ->
    $link = $(composer.iframe).parent().find('.gallery-edit-link')
    $link.hide()

wysihtml5.commands.insertGallery =
    exec: (composer, command, value) ->
        value = { id: value } if not typeof value == "object"

        doc = composer.doc

        $.ajax
            url: '/admin/article_galleries.json'
            type: 'POST'
            data: { gallery: { title: "Название галлереи" } }
            success: (data)->
                console.log(arguments)
                gallery = doc.createElement("div")
                text = doc.createTextNode("Галлерея #{data.id}")
                gallery.setAttribute("data-id", data.id)
                gallery.setAttribute("class", "article-body-gallery")
                gallery.appendChild(text)

                composer.selection.insertNode(gallery)

    state: (composer) ->
        doc = composer.doc
      
        return false if not wysihtml5.dom.hasElementWithTagName(doc, "div")

        selectedNode = composer.selection.getSelectedNode()
        return false if not selectedNode

        return selectedNode if selectedNode.nodeName == "div" and selectedNode.hasAttribute("data-id") 

        return false if selectedNode.nodeType != wysihtml5.ELEMENT_NODE

        galleriesInSelection = composer.selection.getNodes wysihtml5.ELEMENT_NODE, (node) ->
            node.nodeName.toLowerCase() == "div" and node.hasAttribute("data-id") 

        if galleriesInSelection.length != 1
            deselect_gallery(composer)
            return false
        
        id = galleriesInSelection[0].getAttribute("data-id")
        select_gallery(composer, id)
        return false

    value: (composer) ->
        gallery = this.state(composer)
        return gallery && gallery.getAttribute("data-id")

wysihtml5.commands.insertVideo =
    exec: (composer, command, value) ->
        value = { href: value } if not typeof value == "object"

        y_reg1 = /youtube\.com\/embed\/([a-zA-Z0-9_-]+)/
        y_reg2 = /youtu\.be\/([a-zA-Z0-9_-]+)/
        y_reg3 = /youtube\.com\/watch.*v=([a-zA-Z0-9_-]+)/
        match = y_reg1.exec(value.href) or y_reg2.exec(value.href) or y_reg3.exec(value.href)
        if match
            code = match[1]
            kind = 'youtube'
        else
            match = /vimeo\.com\/(\d+)/.exec(value.href)
            return unless match
            code = match[1]
            kind = 'vimeo'

        doc = composer.doc
        video = doc.createElement("div")
        text = doc.createTextNode("Видео #{code}")
        video.setAttribute("data-code", code)
        video.setAttribute("data-kind", kind)
        video.setAttribute("class", "article-body-video")
        video.appendChild(text)

        composer.selection.insertNode(video)

    state: (composer) ->
        doc = composer.doc
      
        return false if not wysihtml5.dom.hasElementWithTagName(doc, "div")

        selectedNode = composer.selection.getSelectedNode()
        return false if not selectedNode

        return selectedNode if selectedNode.nodeName == "div" and selectedNode.hasAttribute("data-code") 

        return false if selectedNode.nodeType != wysihtml5.ELEMENT_NODE

        videosInSelection = composer.selection.getNodes wysihtml5.ELEMENT_NODE, (node) ->
            node.nodeName == "div" and node.hasAttribute("data-code") 

        return false if videosInSelection.length != 1

        return videosInSelection[0]

    value: (composer) ->
        video = this.state(composer)
        return video && video.getAttribute("data-code")

$ ->
    $('.gallery-select-item a').on 'click', (event) ->
        $(this).closest('.gallery-select-dialog').find('input[name=id]')
            .val($(this).attr('data-gallery-id'))
        event.preventDefault()