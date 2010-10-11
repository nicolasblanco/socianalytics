// begin main menu cufon config 
Cufon.replace('.overallmenu > ul > li.current_page_item > a, .overallmenu > ul > li.current_page_ancestor > a, .overallmenu > ul > li.current-menu-item > a, .overallmenu > ul > li.current-menu-ancestor > a');
Cufon.replace('.overallmenu > ul > li > a', {	hover: true	});
Cufon.refresh('.overallmenu > ul > li.current_page_item > a, .overallmenu > ul > li.current_page_ancestor > a, .overallmenu > ul > li.current-menu-item > a, .overallmenu > ul > li.current-menu-ancestor > a');
// end main menu cufon config

/* begin cufon replacer */
Cufon.replace('h1, h2, h3, h4, h5, h6, .custom_title, .firstLetter span, .slider_text_more');
Cufon.replace('.intro_text, .intro_image', { textShadow: '1px 1px #fff'});
Cufon.replace('.page_top_title, .page_top_desc', { textShadow: '1px 1px #444'});
/* end cufon replacer */


  
jQuery(document).ready(function() {

	
	$(".footer_social_networks ul li").fadeTo('normal', 0.4);
	$(".footer_social_networks ul li").hover(function(){
				$(this).fadeTo('normal', 1);
			}, function() {
					$(this).fadeTo('normal', 0.4);
	});
	
	
	$(".form-input input").focus(function () {
	$(this).css({ "backgroundPosition":"0 -28px"});});
	$(".form-input input").blur(function () {
	$(this).css({ "backgroundPosition":"0 0"});});

	$(".form-textarea textarea").focus(function () {
	$(this).parent().css({ "backgroundPosition":"0 -224px"});});
	$(".form-textarea textarea").blur(function () {
	$(this).parent().css({ "backgroundPosition":"0 0"});});

	$(".small_text").focus(function () {
	$(this).css({ "backgroundPosition":"0 -28px"});});
	$(".small_text").blur(function () {
	$(this).css({ "backgroundPosition":"0 0"});});

    jQuery(".picloader img").hide();
	jQuery(".image_holder img").hide();
	jQuery(".image_holder").hide();
	

	$("a[rel^='prettyPhoto']").prettyPhoto({animationSpeed:'slow',theme:'light_rounded',slideshow:5000});
	
});




jQuery(window).load(function() { 
	jQuery(".picloader").css("background-image", "none");
    jQuery(".picloader img").fadeIn("fast");
	
	jQuery(".image_skin_anime").css("background-image", "none");

	jQuery(".image_holder").show();
	jQuery(".image_holder img").fadeTo('normal', 1, function() {
		
		$get_id = jQuery(this).parent().parent().attr("lang");
		if($get_id != ""){
			jQuery(this).parent().parent().addClass($get_id);
			
			$(this).hover(function(){
				$(this).fadeTo('normal', 0.5);
				
			}, function() {
					$(this).fadeTo('normal', 1);
			});
		}
    });
;

});	










/*
 *
 * Copyright (c) 2006/2007 Sam Collett (http://www.texotela.co.uk)
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Version 2.0
 * Demo: http://www.texotela.co.uk/code/jquery/newsticker/
 *
 * $LastChangedDate: 2007-05-29 11:31:36 +0100 (Tue, 29 May 2007) $
 * $Rev: 2005 $
 *
 */
(function($) {
$.fn.newsTicker = $.fn.newsticker = function(delay)
{
	delay = delay || 4000;
	initTicker = function(el)
	{
		stopTicker(el);
		el.items = $("li", el);
		// hide all items (except first one)
		el.items.not(":eq(0)").hide().end();
		el.currentitem = 0;
		startTicker(el);
	};
	startTicker = function(el)
	{
		el.tickfn = setInterval(function() { doTick(el) }, delay)
	};
	stopTicker = function(el)
	{
		clearInterval(el.tickfn);
	};
	pauseTicker = function(el)
	{
		el.pause = true;
	};
	resumeTicker = function(el)
	{
		el.pause = false;
	};
	doTick = function(el)
	{
		if(el.pause) return;
		el.pause = true;
		$(el.items[el.currentitem]).fadeOut("normal",
			function()
			{
				$(this).hide();
				el.currentitem = ++el.currentitem % (el.items.size());
				$(el.items[el.currentitem]).fadeIn("normal",
					function()
					{
						el.pause = false;
					}
				);
			}
		);
	};
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase()!= "ul") return;
			initTicker(this);
		}
	)
	.addClass("newsticker")
	.hover(
		function()
		{
			pauseTicker(this);
		},
		function()
		{
			resumeTicker(this);
		}
	);
	return this;
};

})(jQuery);
$("#news_ticker").newsTicker($headlines_delay);
$("#tweet_ticker").newsTicker(5000);




/* begin contact form */
$(document).ready(function(){
	var form = $("#commentform");
	var name = $("#name");
	var email = $("#email");
	var subject = $("#subject");
	var message = $("#message");
	
	name.blur(validateName);
	email.blur(validateEmail);
	subject.blur(validateSubject);
	message.blur(validateMessage);
	
	name.focus(function () {
		$(this).css({ "backgroundPosition":"0 -28px"});
	});
	
	subject.focus(function () {
		$(this).css({ "backgroundPosition":"0 -28px"});
	});
	
	message.focus(function () {
		$(this).parent().css({ "backgroundPosition":"0 -224px"});
	});
	
	var inputs = form.find(":input").filter(":not(:submit)").filter(":not(:checkbox)").filter(":not([type=hidden])").filter(":not([validate=false])");

	form.submit(function(){
		if(validateName() & validateEmail() & validateSubject() & validateMessage()){
			
			var $name = name.val();
			var $email = email.val();
			var $subject = subject.val();
			var $message = message.val();
			
			$.ajax({
				type: 'GET',
				url: "get_mail.php",
				data: form.serialize(),
				success: function(ajaxCevap) {
					$('#list').hide();
					$('#list').html(ajaxCevap);
					$('#list').fadeIn("normal");
					name.attr("value", "");
					email.attr("value", "");
					subject.attr("value", "");
					message.attr("value", "");
				}
			});

			return false;
		}else{
			return false;
		}
	});
	
	function validateEmail(){
		var a = $("#email").val();
		var filter = /^[a-zA-Z0-9]+[a-zA-Z0-9_.-]+[a-zA-Z0-9_-]+@[a-zA-Z0-9]+[a-zA-Z0-9.-]+[a-zA-Z0-9]+.[a-z]{2,4}$/;
		if(filter.test(a)){
			email.css({ "backgroundPosition":"0 0"});
			return true;
		}
		else{
			email.css({ "backgroundPosition":"0 -56px"});
			return false;
		}
	}
	function validateName(){
		if(!name.val()){
			name.css({ "backgroundPosition":"0 -56px"});
			return false;
		}
		else{
			name.css({ "backgroundPosition":"0 0"});
			return true;
		}
	}
	
	function validateSubject(){
		if(!subject.val()){
			subject.css({ "backgroundPosition":"0 -56px"});
			return false;
		}
		else{
			subject.css({ "backgroundPosition":"0 0"});
			return true;
		}
	}
	
	function validateMessage(){
		if(!message.val()){
			message.parent().css({ "backgroundPosition":"0 -448px"});
			return false;
		}else{			
			message.parent().css({ "backgroundPosition":"0 0"});
			return true;
		}
	}
		
});
/* end contact form */



/* begin scrolltop control */
$(function(){
   sh = $(window).height() / 2;
   xh = $(document).height() /2 - sh;
});	

var scrolltotop={
	
	setting: {startline:200, scrollto: 0, scrollduration:1000, fadeduration:[200, 50]},
	controlHTML: '<span class="scroll_up"></span>',
	controlattrs: {offsetx:5, offsety:5}, 
	anchorkeyword: '#top',
	state: {isvisible:false, shouldvisible:false},

	scrollup:function(){
		if (!this.cssfixedsupport) 
			this.$control.css({opacity:0}) 
		var dest=isNaN(this.setting.scrollto)? this.setting.scrollto : parseInt(this.setting.scrollto)
		if (typeof dest=="string" && jQuery('#'+dest).length==1) 
			dest=jQuery('#'+dest).offset().top
		else
			dest=0
		this.$body.animate({scrollTop: dest}, this.setting.scrollduration);
	},

	keepfixed:function(){
		var $window=jQuery(window)
		var controlx=$window.scrollLeft() + $window.width() - this.$control.width() - this.controlattrs.offsetx
		var controly=$window.scrollTop() + $window.height() - this.$control.height() - this.controlattrs.offsety
		this.$control.css({left:controlx+'px', top:controly+'px'})
		
	
	},

	togglecontrol:function(){
		var scrolltop=jQuery(window).scrollTop()
		if (!this.cssfixedsupport)
			this.keepfixed()
		this.state.shouldvisible=(scrolltop>=xh)? true : false
		if (this.state.shouldvisible && !this.state.isvisible){
			this.$control.stop().animate({opacity:1}, this.setting.fadeduration[0])
			this.state.isvisible=true
		}
		else if (this.state.shouldvisible==false && this.state.isvisible){
			this.$control.stop().animate({opacity:0}, this.setting.fadeduration[1])
			this.state.isvisible=false
		}
	},
	
	init:function(){
		jQuery(document).ready(function($){
			var mainobj=scrolltotop
			var iebrws=document.all
			mainobj.cssfixedsupport=!iebrws || iebrws && document.compatMode=="CSS1Compat" && window.XMLHttpRequest //not IE or IE7+ browsers in standards mode
			mainobj.$body=(window.opera)? (document.compatMode=="CSS1Compat"? $('html') : $('body')) : $('html,body')
			mainobj.$control=$('<div id="topcontrol"><span class="scroll_up"></span></div>')
				.css({position:mainobj.cssfixedsupport? 'fixed' : 'absolute', bottom:mainobj.controlattrs.offsety, right:mainobj.controlattrs.offsetx, opacity:0, cursor:'pointer'})
				.attr({title:'Scroll Back to Top'})
				.click(function(){mainobj.scrollup(); return false})
				.appendTo('body')
			if (document.all && !window.XMLHttpRequest && mainobj.$control.text()!='') //loose check for IE6 and below, plus whether control contains any text
				mainobj.$control.css({width:mainobj.$control.width()}) //IE6- seems to require an explicit width on a DIV containing text
			mainobj.togglecontrol()
			$('a[href="' + mainobj.anchorkeyword +'"]').click(function(){
				mainobj.scrollup()
				return false
			})
			$(window).bind('scroll resize', function(e){
				mainobj.togglecontrol()
			})
		})
	}
}

scrolltotop.init()
/* end scrolltop control */