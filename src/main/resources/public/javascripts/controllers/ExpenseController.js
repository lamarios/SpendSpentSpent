app.controller('ExpenseController', [ '$scope', 'ExpTracker', function($scope, ExpTracker) {

	$scope.expenses = function() {
		return ExpTracker.expenses.list;
	};

	$scope.months = function() {
		return ExpTracker.expenses.months;
	};

	$scope.selectedMonth = function(){
		return ExpTracker.expenses.selectedMonth;
	};
	
	

	$scope.totalIncome = function() {
		var total = 0;
		angular.forEach($scope.expenses, function(day) {
			total += day.income;
		});

		return total;
	};

	$scope.totalOutcome = function() {
		var total = 0;
		angular.forEach($scope.expenses(), function(day) {
			total += day.outcome;
		});

		return total;
	};

	$scope.changeMonth = function(month) {
		ExpTracker.expenses.selectedMonth = month;
		ExpTracker.expenses.refresh();
	};
	
	$scope.delete = function(expense){
		ExpTracker.expenses.delete(expense, function(){
			ExpTracker.history.refresh();
		});
	};
	
	
	$scope.loadMap = function(expense, showOptions){

		if(!showOptions || (expense.latitude === 0 && expense.longitude === 0)){
			if($scope.maps[expense.id] !== null){
				$scope.maps[expense.id] = null;
			}
			return;
		}
		var mapDiv = $('.map[data-id="'+expense.id+'"');
		

		var map = new google.maps.Map(mapDiv[0], {
			center: {lat: expense.latitude, lng: expense.longitude},
			zoom: 16,
			disableDefaultUI: true
		});
		
		var marker = new google.maps.Marker({
			position: {lat: expense.latitude, lng: expense.longitude},
			map: map
		});
		
		map.setCenter(map.getCenter());
		
		setTimeout(function(){
			google.maps.event.trigger(map, 'resize');
			map.setCenter(marker.getPosition());				
		}, 500);
	};
	
	
	
} ]);
