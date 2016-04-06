$(document).on 'ajax:success', '.button_answer-delete', ->
  $(this).closest('.answer').fadeOut('slow', -> $(this).remove())
.on 'click', '.answer .button_answer-edit', ->
  $(this).closest('.answer').find('form').fadeToggle()
