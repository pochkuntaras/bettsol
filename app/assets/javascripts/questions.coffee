$(document).on 'click', '.button_question-edit', ->
  $(this).closest('.question').find('form').fadeToggle()
