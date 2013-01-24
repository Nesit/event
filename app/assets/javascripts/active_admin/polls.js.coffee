$ ->
    $(document).on 'focus', '#poll-form .choices li input', ->
        inputs = $('#poll-form .choices li input')
        return unless inputs.index(this) == inputs.length-1 # check is last

        id = /poll_choices_attributes_(\d+)_title/.exec($(this).attr('id'))[1]
        id = parseInt(id)+1

        html = """
        <li class="string input required stringish" id="poll_choices_attributes_#{id}_title_input">
            <label class=" label" for="poll_choices_attributes_#{id}_title">
                Вариант ответа<abbr title="required">*</abbr>
            </label>
            <input id="poll_choices_attributes_#{id}_title" maxlength="255" name="poll[choices_attributes][#{id}][title]" placeholder="Добавить вариант" type="text" />
        </li>
        """
        $('#poll-form .choices ol').append(html)