/*!
 Author: Stephen Korecky
 Website: http://stephenkorecky.com
 Plugin Website: http://github.com/skorecky/Add-Clear
 Version: 2.0.5
*/

;(function($, window, document, undefined) {

	// Create the defaults once
	var pluginName = "addClear",
		defaults = {
			closeSymbol: "&times;",
//			closeSymbol: "&#10006;",
//			color: "#CCC",
			
			top: -2,
			right: 0,
			returnFocus: false,
			showOnLoad: false,
			onClear: null,
			hideOnBlur: false,
			tabbable: false
		};

	// The actual plugin constructor
	function Plugin(element, options) {
		this.element = element;

		this.options = $.extend({}, defaults, options);

		this._defaults = defaults;
		this._name = pluginName;

		this.init();
	}

	Plugin.prototype = {

		init: function() {
			var $this = $(this.element),
					$clearButton,
					me = this,
					options = this.options;
			
			// background:#fff; - for IE* compatible
			$this.wrap("<span style='background:#fff;position:relative;' class='add-clear-span'></span>");
			
			var tabIndex = options.tabbable ? "" : " tabindex='-1'";
			$clearButton = $("<a href='#clear' class='ui-corner-right' style='display: none;'" + tabIndex + ">" + options.closeSymbol + "</a>");
			$this.after($clearButton);
			$this.next().css({
				color: options.color,
				'text-decoration': 'none',
				display: 'block',
				'line-height': 1,
				overflow: 'hidden',
				position: 'absolute',
				right: options.right,
				top: options.top
			}, this);

			if ($this.val().length >= 1 && options.showOnLoad === true) {
				$clearButton.css({display: 'block'});
			}

			$this.focus(function() {
				if ($(this).val().length >= 1) {
					$clearButton.css({display: 'block'});
				}
			});

			$this.blur(function(e) {
				if (options.hideOnBlur) {
					setTimeout(function() {
						var relatedTarget = e.relatedTarget || e.explicitOriginalTarget || document.activeElement;
						if (relatedTarget !== $clearButton[0]) {
							$clearButton.css({display: 'none'});
						}
					}, 0);
				}
			});

			$this.keyup(function() {
				if ($(this).val().length >= 1) {
					$clearButton.css({display: 'block'});
				} else {
					//$clearButton.css({display: 'none'});
				}
			});

			if (options.hideOnBlur) {
				$clearButton.blur(function () {
					//$clearButton.css({display: 'none'});
				});
			}

			$clearButton.click(function(e) {
				var $input = $(me.element);
				$input.val("");
				//$(this).css({display: 'none'});
				if (options.returnFocus === true) {
					$input.focus();
				}
				if (options.onClear) {
					options.onClear($input);
				}
				e.preventDefault();
			});
		}

	};

	$.fn[pluginName] = function(options) {
		return this.each(function() {
			if (!$.data(this, "plugin_" + pluginName)) {
				$.data(this, "plugin_" + pluginName,
					new Plugin(this, options));
			}
		});
	};

})(jQuery, window, document);
 