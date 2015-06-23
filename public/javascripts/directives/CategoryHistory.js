app.directive('categoryHistory', function(){
	var directive = {
		  	restrict: 'E',
		    scope: {
		    	data: '=',
		    	index: '='
		    	
		    },
		    templateUrl: '/assets/javascripts/directives/CategoryHistory.html'
		  }
	
	
	
	return directive ;

});