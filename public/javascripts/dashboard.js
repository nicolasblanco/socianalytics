jQuery.noConflict();
jQuery(document).ready(function() {
   jQuery('.property_selector span').click(function(){ 
	     jQuery(this).parent('div.property_selector').toggleClass('hover');
   });
   jQuery('.container, .navbar').mouseup(function(){ 
	     jQuery('.top .property_selector').removeClass('hover');
   });
});
