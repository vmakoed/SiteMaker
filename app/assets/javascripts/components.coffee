# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".component-text").each (index, element) =>
    convert_markdown_to_html(element, index)

convert_markdown_to_html = (element, index) ->
  converter = new showdown.Converter()
  html_text = converter.makeHtml($(element).attr("content-text"))
  $(element).append(html_text)