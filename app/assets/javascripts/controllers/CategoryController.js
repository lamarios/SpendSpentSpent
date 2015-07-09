app.controller('CategoryController', [ '$scope', 'ExpTracker', '$http', '$rootScope', function($scope, ExpTracker, $http, $rootScope) {

	$scope.categories = function() {
		return ExpTracker.categories.list;
	};
	$scope.availableIcons = function() {
		return ExpTracker.categories.availableIcons;
	};
	$scope.selectedCategory = '';
	$scope.newExpenseAmount = '';
	$scope.showCategoryDialog = false;
	$scope.chosenColor = '#E91E63';
	$scope.chosenIcon = $scope.availableIcons[0];

	$scope.showOverlay = false;
	
	
	
	$scope.showAddDialog = function() {
		// Getting available categories
		$http.get('/API/Category/Available').success(function() {
			$scope.addCategory();
		});
	};

	$scope.years = [];
	$scope.months = [];
	var today = new Date();
	
	$scope.selectedYear = today.getFullYear();
	$scope.selectedMonth = today.getMonth();
	$scope.selectedDate = today.getDate();

	$scope.months.push({
		number : 0,
		name : 'January'
	});
	$scope.months.push({
		number : 1,
		name : 'February'
	});
	$scope.months.push({
		number : 2,
		name : 'March'
	});
	$scope.months.push({
		number : 3,
		name : 'April'
	});
	$scope.months.push({
		number : 4,
		name : 'May'
	});
	$scope.months.push({
		number : 5,
		name : 'June'
	});
	$scope.months.push({
		number : 6,
		name : 'July'
	});
	$scope.months.push({
		number : 7,
		name : 'August'
	});
	$scope.months.push({
		number : 8,
		name : 'September'
	});
	$scope.months.push({
		number : 9,
		name : 'October'
	});
	$scope.months.push({
		number : 10,
		name : 'November'
	});
	$scope.months.push({
		number : 11,
		name : 'December'
	});

	for (var i = today.getFullYear() - 50; i <= today.getFullYear() + 50; i++) {
		$scope.years.push(i);
	}

	$scope.days = function(year, month) {
		var date = new Date();
		date.setFullYear(year);
		date.setMonth(month + 1);
		date.setDate(0);

		var array = [];
		for (var i = 1; i <= date.getDate(); i++) {
			array.push(i);
		}

		return array;
	};

	$scope.addCategory = function(icon, color) {

		var newCategory = {
			icon : icon,
			order : $scope.categories().length,
			color : color.replace('#', '')
		};
		ExpTracker.categories.add(newCategory, function() {
			$scope.closeDialogs();
			ExpTracker.history.refresh();
		});

	};

	$scope.addExpense = function(categoryId, amount, income, year, month, date) {
		if (income === undefined) {
			income = false;
		}


		month = $scope.pad(month+1, 2);
		date = $scope.pad(date, 2);
		
		var selectedDate = year +'-'+month+'-'+date;

		//alert(year +'-'+month+'-'+date);
		
		console.log('Adding expense for cat ' + categoryId);
		var newExpense = {
			category : categoryId,
			amount : amount,
			income : income,
			type : 1,
			date : selectedDate
		};

		ExpTracker.expenses.add(newExpense, function(expense) {
			console.log('Expense added:');
			console.log(expense);
			$scope.closeDialogs();
			ExpTracker.history.refresh();
		});
	};

	$scope.showAddExpense = function(index) {
		$scope.selectedCategory = $scope.categories()[index];
		console.log($scope.selectedCategory);
	};

	$scope.addNewExpenseDigit = function(digit) {

		var newAmount = $scope.newExpenseAmount + digit;

		var patt = new RegExp(/^[0-9]+(\.[0-9]{0,2})?$/);

		if (patt.test(newAmount)) {
			$scope.newExpenseAmount = newAmount;
		}
		// $scope.newExpenseAmount+=digit;
	};

	$scope.removeNewExpenseDigit = function() {
		$scope.newExpenseAmount = $scope.newExpenseAmount.substring(0, $scope.newExpenseAmount.length - 1);
	};

	$scope.closeDialogs = function() {
		$scope.selectedCategory = '';
		$scope.newExpenseAmount = '';
		$scope.showCategoryDialog = false;
	};
	
	$scope.pad = function (num, size) {
		var s = num+"";
		while (s.length < size) s = "0" + s;
		return s;
	};
	
	$scope.delete = function(category){
		if(confirm('Delete category ? This will delete all the related expenses.')){
			ExpTracker.categories.delete(category, function(){
				ExpTracker.refresh();
			});
		}
	};

} ]);
