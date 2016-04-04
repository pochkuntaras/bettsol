$(document).on 'click', '.button_question-edit', ->
  $(this).closest('.question').find('.question__edit').fadeToggle()
