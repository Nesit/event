$ ->
	$('.tag-list-input').tagsInput
		autocomplete_url: '/tags'
		autocomplete:
  			selectFirst: true
  			width: '100px'
  			autoFill: true
  		defaultText: "Добавить тег"
