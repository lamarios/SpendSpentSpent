app.directive('categoryGrid', function() {
	return {
		restrict : 'E',
		scope : {
			cat : '='
		},
		templateUrl : '/javascripts/directives/CategoryGrid.html'
	};

});