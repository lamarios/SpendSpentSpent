app.directive('animationCreate', function() {
	return {
		restrict : 'A',
		link : function(scope, elm, attrs) {

			var animation = attrs.animationCreate;

			elm = angular.element(elm);
			elm.removeClass(animation);
			elm.addClass('animated');
			elm.addClass(animation);
		}
	};
});