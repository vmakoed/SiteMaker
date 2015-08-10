$ ->
  switch_to_normal_mode()

  autosize($('.form-control'))

  $("#components-panel ul").sortable
    update: (event, ui) ->
      set_attributes_to_components()

  set_onchange_form_action($(".form-control"))

  $(".form-component").each (index, element) =>
    set_attributes_to_components()
    $(element).attr("data-order", index)
    if $(element).attr("content-type") == "Gallery"
      setup_gallery_drop($(element))

  $("#images-mode-on-button").click ->
    switch_to_images_mode()

  $("#images-mode-off-button").click ->
    switch_to_normal_mode()

  $('.destroy-component-button').click ->
    destroy_component($(this))

  $(".component-thumbnail").draggable
    revert: "invalid",
    containment: "document",
    helper: "clone",
    cursor: "move"

  $("#components-panel").droppable
    accept: ".component-thumbnail",
    drop: ( event, ui ) ->
      create_new_component_form $(ui.draggable).attr('content-type')

  $(".image-miniature").draggable
    revert: "invalid",
    containment: "document",
    cursor: "move",
    scroll: false,
    helper: 'clone'
    drag: ( event, ui ) ->
      $(ui.draggable).width(140)

  $(".list-gallery-images li").each (index, element) ->
    set_onclick_action_for_image(element)

  return

create_new_component_form = (content_type) ->
  new_component = $(".form-component-sample-#{content_type}").first().clone()
  new_component.removeClass("form-component-sample-#{content_type}")
  new_component.removeClass("form-component-sample")
  new_component.addClass("form-component")
  new_component.attr("content-type", content_type)

  $("#components-list").append(new_component)
  $(new_component).wrap('<li class="list-group-item"></li>')

  $('.destroy-component-button').click ->
    destroy_component($(this))

  set_attributes_to_components()

  if (content_type == "Gallery")
    switch_to_images_mode()
    setup_gallery_drop(new_component)
  else
    switch_to_normal_mode()

set_attributes_to_input = (div_with_input, input_order) ->
  content_type = $(div_with_input).attr("content-type")
  hidden_input = $(div_with_input).find(".hidden-input").first()

  $(div_with_input).attr("data-order", input_order)

  if content_type == "Gallery"
    set_attributes_to_images($(div_with_input).find(".list-gallery-images"))
  else
    hidden_input.attr("name", "components[#{input_order}][#{$(div_with_input).attr("content-type")}]")

  set_onchange_form_action($(div_with_input))

set_attributes_to_components = () ->
  $(".form-component").each (index, element) =>
    set_attributes_to_input(element, index)

destroy_component = (pressed_button) ->
  pressed_button.closest($(".list-group-item")).remove()
  $(".form-component").each (index, element) =>
    set_attributes_to_components()
    $(element).attr("data-order", index)


set_onchange_form_action = (component_form) ->
  $(component_form).change ->
    content_type = $(this).attr("content-type")
    if (content_type == "Text" || content_type == "Video")
      order = $(this).attr("data-order")
      form_control = $(this).find(".form-control").first()
      text = form_control.val()
      $("input[name='components[#{order}][#{content_type}]']").attr('value', text)
    if content_type == "Gallery"
      alert "gallery changed"

setup_gallery_drop = (gallery_form) ->
  gallery_form.find(".list-gallery-images").sortable
    update: (event, ui) ->
      set_attributes_to_images($(this))

  gallery_form.find(".panel-body").droppable
    accept: ".image-miniature"
    drop: ( event, ui ) ->
      add_new_image_to_gallery($(this), ui)

set_attributes_to_images = (images_list) ->
  gallery_order = $(images_list).parents(".form-component").attr("data-order")
  images_list.find("li").each (index, element) =>
    hidden_input = $(element).find(".hidden-input").first()
    hidden_input.attr("name", "components[#{gallery_order}][Gallery][#{index}]")


add_new_image_to_gallery = (gallery_panel, ui) ->
  content_type = "gallery-image"
  new_component = $(".form-component-sample-#{content_type}").first().clone()
  new_component.removeClass("form-component-sample-#{content_type}")
  new_component.removeClass("form-component-sample")
  new_component.attr("content-type", content_type)

  image_url = $(ui.draggable).find("img").attr("src")
  new_component.find("img").attr("src", image_url)

  gallery_panel.find(".list-gallery-images").append(new_component)

  set_attributes_to_gallery_image(new_component, gallery_panel.parents(".form-component").attr("data-order"), new_component.index())

  set_onclick_action_for_image(new_component)

set_onclick_action_for_image = (image_component) ->
  $(image_component).click ->
    images_list = $(this).parents(".list-gallery-images")
    $(this).remove()
    set_attributes_to_images(images_list)

set_attributes_to_gallery_image = (image_component, gallery_order, image_order) ->
  hidden_input = $(image_component).find(".hidden-input").first()
  image_url =  $(image_component).find("img").attr("src")

  hidden_input.attr("name", "components[#{gallery_order}][Gallery][#{image_order}]")
  hidden_input.attr("value", image_url)


switch_to_images_mode = () ->
  $("#images-mode-off-button").removeClass("btn-default")
  $("#images-mode-off-button").addClass("btn-info")
  $("#images-mode-on-button").addClass("btn-default")
  $("#images-mode-on-button").removeClass("btn-info")

  $("#components-panel-container").removeClass("col-md-12")
  $("#components-panel-container").addClass("col-md-6")
  $("#images-panel-container").removeClass("col-md-0")
  $("#images-panel-container").addClass("col-md-6")
  $("#images-panel").show()

switch_to_normal_mode = () ->
  $("#images-mode-on-button").removeClass("btn-default")
  $("#images-mode-on-button").addClass("btn-info")
  $("#images-mode-off-button").addClass("btn-default")
  $("#images-mode-off-button").removeClass("btn-info")

  $("#images-panel-container").removeClass("col-md-6")
  $("#images-panel-container").addClass("col-md-0")
  $("#components-panel-container").removeClass("col-md-6")
  $("#components-panel-container").addClass("col-md-12")
  $("#images-panel").hide()

