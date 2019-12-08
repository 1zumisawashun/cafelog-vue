// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.raty
//= require ratyrate
//= require jquery-ui
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require particles
//= require_tree .


$(function() {
    $('.a').slick({
        dots: true,
        infinite: true,
        arrows: true,
        autoplay:true,
        autoplaySpeed:3000,
        slidesToShow: 5,
        slidesToScroll: 1
    });
});

$(function () {
    $("#rateYo").rateYo({
        rating: 3.8
    });
});

$(function() {
    $('.shop-picture').slick({
        dots: true,
        infinite: true,
        arrows: true,
        autoplay:true,
        autoplaySpeed:5000,
        slidesToShow: 1,
        slidesToScroll: 1
    });
});

$(function() {
$('.slider').on('init',function(){
    $('.slide__content').addClass('on');
});
$('.slider').slick({
    autoplay:true,
    infinite: true,
    autoplaySpeed:4000,
    dots:true,
    slidesToShow: 1,
    slidesToScroll: 1

});
$('.slider').on('beforeChange',function(){
    $('.slide__content').removeClass('on');
});
$('.slider').on('afterChange',function(){
    $('.slide__content').addClass('on');
});
});

//なんだけよくわからないけれど$(function() {});を入れておかないと動作しない。これを入れていないサイトもあるので注意する！
