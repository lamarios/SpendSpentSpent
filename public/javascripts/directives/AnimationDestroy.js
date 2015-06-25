app.directive('animationDestroy', function() {
	return {
		restrict : 'A',
		link : function(scope, elm, attrs) {
			var animation = attrs.animationDestroy;
			elm = angular.element(elm);

			scope.$on("$destroy", function handleDestroyEvent(complete, args) {
			    //var deferred = complete.defer();
				elm.addClass('animated');
				elm.removeClass(animation);
				elm.addClass(animation);
				setTimeout(function() {
					//complete.promise();
				}, 500);
			});
		}
	};
});