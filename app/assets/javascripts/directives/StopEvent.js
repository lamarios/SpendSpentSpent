app.directive('stopEvent', function() {
	return {
		restrict : 'A',
		link : function(scope, element, attr) {
			element.bind('click', function($event) {
				if ($event.stopPropagation) {
					$event.stopPropagation();
				}
				
				if ($event.preventDefault) {
					$event.preventDefault();
				}
				
			});
		}
	};
});