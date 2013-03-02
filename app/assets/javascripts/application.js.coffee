#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require jquery.Jcrop
#= require jquery.color
#= require jquery.jcarousel
#= require jquery.placeholder
#= require chosen-jquery
#= require jquery.cookie

#= require home
#= require forms
#= require auth
#= require articles
#= require comments
#= require profile
#= require article_galleries
#= require videos
#= require subscriptions
#= require polls
#= require social_share

$.fn.overflows = ->
    return ($(this).width() != this.clientWidth || $(this).height() != this.clientHeight)

$ ->
    $('input[data-placeholder], textarea[data-placeholder]').placeholder();
    $('.hiddable').each (_, e) ->
        $(e).addClass('hidden') if $(e).overflows()