# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# $ ->
#   $(document).on('click', '.new-address-btn', ->
#     $.get '/addresses/new', (data) ->
#       if $('#address_form_modal').length > 0
#         $('#address_form_modal').remove()
#       $('body').append data
#       $('#address_form_modal').modal()
#       return
#     false
#   ).on('ajax:success', '.address-form', (e, data) ->
#     if data.status == 'ok'
#       $('#address_form_modal').modal 'hide'
#       $('#address_list').html data.data
#     else
#       $('#address_form_modal').html $(data.data).html()
#     return
#   ).on('ajax:success', '.edit-address-btn', (e, data) ->
#     if $('#address_form_modal').length > 0
#       $('#address_form_modal').remove()
#     $('body').append data
#     $('#address_form_modal').modal()
#     return
#   ).on 'ajax:success', '.set-default-address-btn, .remove-address-btn', (e, data) ->
#     $('#address_list').html data.data
#     return
