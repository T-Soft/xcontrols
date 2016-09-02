var iBaseHeaderOffsetLeft = 0;

function UpdateTableHeaders() {
       $(".xc_floating_this_header").each(function() {

		var
			el             = $(this),
			offset         = el.offset(),
			scrollTop      = $(window).scrollTop(),
			floatingHeader = $(".floating_header", this)

		if ((scrollTop > offset.top) && (scrollTop < offset.top + el.height())) {
			floatingHeader.css({
				"visibility": "visible"
			});
		} else {
			floatingHeader.css({
				"visibility": "hidden"
			});
		};

		var scrollLeft = $(window).scrollLeft();

		floatingHeader.css("left",-1*scrollLeft + iBaseHeaderOffsetLeft);

       });
}


function DrawHeader(){



       var clonedHeaderRow;

       $(".xc_floating_this_header").each(function() {

           clonedHeaderRow = $("thead", this);
           clonedHeaderRow
             .before(clonedHeaderRow.clone())
             .css("width", clonedHeaderRow.width())
             .addClass("floating_header");

		iBaseHeaderOffsetLeft = parseInt(clonedHeaderRow.css('left'));


var 	originalHeaderRow = $("thead:not(.floating_header)", this),
	originalHeaderColls = originalHeaderRow.children("tr").children("td");

var floatingHeaderColls = clonedHeaderRow.children("tr").children("td"),
	i = 0;

		originalHeaderColls.each(function(){
			var	w = $(this).width();

			floatingHeaderColls.get(i).width = w;
			i++;
		});

       });


	$(window).scroll(UpdateTableHeaders).trigger("scroll");
}

// DOM Ready
$(function() {
	DrawHeader();
});


