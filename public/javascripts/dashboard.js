$(document).ready(function() {
  $('.property_selector span').click(function(){ 
    $(this).parent('div.property_selector').toggleClass('hover');
  });
  $('.container, .navbar').mouseup(function(){ 
    $('.top .property_selector').removeClass('hover');
  });
});
