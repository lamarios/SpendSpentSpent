app.directive('recurringExpense', function() {
	return {
		restrict : 'E',
		scope : {
			expense : '=',
		},
		controller : function($scope) {
			$scope.getTypeString = function(type) {
				switch (type) {
				case 0:
					return 'Daily';
				case 1:
					return 'Weekly';
				case 2:
					return 'Monthly';
				case 3:
					return 'Yearly';
				}
			};

			$scope.showOptions = false;
			$scope.showDelete = false;
			
		},
		templateUrl : '/javascripts/directives/RecurringExpense.html'
	};

});