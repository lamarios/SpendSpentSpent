app.directive('categoryHistory', function() {
	var directive = {
		restrict : 'E',
		scope : {
			data : '=',
			index : '='

		},
		templateUrl : '/javascripts/directives/CategoryHistory.html'
	};

	return directive;

});