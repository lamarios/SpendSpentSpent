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

			this.getTypeString = function(type) {
				return $scope.getTypeString(type);
			};
		},
		templateUrl : '/assets/javascripts/directives/RecurringExpense.html'
	};

});