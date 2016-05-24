$(document).on 'ready', ->
  PrivatePub.subscribe '/questions', (data) ->
    $('body').append HandlebarsTemplates['question']
      question: data.question
      author: gon.current_user_id == data.question.userId

  if gon.question_id
    PrivatePub.subscribe '/questions/' + gon.question_id + '/answers', (data) ->
      $('.answers').append HandlebarsTemplates['answer']
        answer: data.answer
        author: gon.current_user_id == data.answer.userId
        authorQuestion: gon.current_user_id == data.question.userId
        canVote: gon.current_user_id && gon.current_user_id != data.answer.userId
        currentUser: gon.current_user_id

    PrivatePub.subscribe '/comments', (data) ->
      if data
        $commentable = $ '#' + data.comment.commentable
        $commentable.find('.comments').append HandlebarsTemplates['comment'](data)

.on 'click', '.flash', ->
  $(this).fadeOut('slow', -> $(this).remove())

.on 'click', '.button_question-edit', ->
  $(this).closest('.question').find('form').fadeToggle()

.on 'click', '.answer .button_answer-edit', ->
  $(this).closest('.answer').find('form').fadeToggle()

.on 'ajax:success', 'form#new_answer', ->
  $form = $(this)

  $form.find('[name="answer[content]"]').val('')
  $form.find('.nested-fields, .validation-error').remove()

.on 'ajax:error', 'form#new_answer', (e, data, status, xhr) ->
  $(this).render_form_errors('answer', data.responseJSON.errors)

.on 'ajax:success', '.button_answer-delete', ->
  $(this).closest('.answer').fadeOut('slow', -> $(this).remove())

.on 'ajax:success', '.voice', (e, data, status, xhr) ->
  $(this).siblings('.rating').html($.parseJSON(xhr.responseText).rating)

.on 'ajax:success', '.voice_like, .voice_dislike', ->
  $(this).parent().find('.voice').hide().siblings('.voice_indifferent').show()

.on 'ajax:success', '.voice_indifferent', ->
  $(this).hide().siblings('.voice').show()

.on 'ajax:success', 'form.form_new-comment', ->
  $form = $(this)

  $form.find('[name="comment[content]"]').val('')
  $form.find('.validation-error').remove()

.on 'ajax:error', 'form.form_new-comment', (e, data, status, xhr) ->
  $(this).render_form_errors('comment', data.responseJSON.errors)

$.fn.render_form_errors = (model_name, errors) ->
  form = this
  form.find('.validation-error').remove()

  $.each errors, (field, messages) ->
    form.find('input, select, textarea').filter ->
      name = $(this).attr('name')
      if name then name.match(new RegExp(model_name + '\\[' + field + '\\(?'))
    .after '<span class="validation-error">' + messages.join(', ') + '</span>'
