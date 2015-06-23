app.directive('categoryGrid', function(){
	return {
  	restrict: 'E',
    scope: {
    	cat: '='
    },
    templateUrl: '/assets/javascripts/directives/CategoryGrid.html'
  };

});