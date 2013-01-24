$ ->
     $(document).on 'change', '#admin-gallery-form .images-item input', ->
        inputs = $('#admin-gallery-form .images-item input')
        return unless inputs.index(this) == inputs.length-1 # check is last
        
        id = /article_gallery_images_attributes_(\d+)_source/.exec($(this).attr('id'))[1]
        id = parseInt(id)+1

        html = """
            <fieldset class="inputs images-item">
                <ol>
                    <li class="file input required" id="article_gallery_images_attributes_#{id}_source_input">
                        <label class=" label" for="article_gallery_images_attributes_#{id}_source">Source<abbr title="required">*</abbr></label>
                        <input id="article_gallery_images_attributes_#{id}_source" name="article_gallery[images_attributes][#{id}][source]" type="file" />
                    </li>
                </ol>
            </fieldset>
        """
        $('#admin-gallery-form .actions').before(html)