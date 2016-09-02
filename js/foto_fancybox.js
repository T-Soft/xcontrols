function foto_fancybox_init() {

			$(".fancybox-corp").fancybox({

				wrapCSS		: 'fancybox-custom',

				closeClick	: true,

				loop		: false,

				openEffect	: 'none',
				closeEffect	: 'none',
				prevEffect	: 'none',
				nextEffect	: 'none',

				helpers 	: {
					title : {
						type : 'inside'
					},
					overlay : {
						css : {
							'background' : 'rgba(238,238,238,0.85)'
						}
					}
				},

				mouseWheel	: true,

				keys		: {
					next : {
						32 : 'space', // enter
//						13 : 'left', // enter
						34 : 'up',   // page down
						39 : 'left', // right arrow
						40 : 'up'    // down arrow
					},
					prev : {
						8  : 'right',  // backspace
						33 : 'down',   // page up
						37 : 'right',  // left arrow
						38 : 'down'    // up arrow
					},
					close  : [27], // escape key
//					play   : [32], // space - start/stop slideshow
					toggle : [13]  // enter - toggle fullscreen
				}
			});

}