$(document).on 'ajax:success', '.voice', (e, data, status, xhr) ->
  $(this).siblings('.rating').html($.parseJSON(xhr.responseText).rating)
.on 'ajax:success', '.voice_like, .voice_dislike', ->
  $(this).parent().find('.voice').hide().siblings('.voice_indifferent').show()
.on 'ajax:success', '.voice_indifferent', ->
  $(this).hide().siblings('.voice').show()
