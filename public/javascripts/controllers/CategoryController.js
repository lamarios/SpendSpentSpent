app.controller('CategoryController', [
		'$scope',
		'ExpTracker',
		'$http',
		function($scope, ExpTracker, $http) {

			$scope.categories = function(){
				return ExpTracker.categories.list;
			}
			$scope.availableIcons = ExpTracker.categories.availableIcons;
			$scope.selectedCategory = '';
			$scope.newExpenseAmount = '';
			$scope.showCategoryDialog = false;
			$scope.chosenColor = '#E91E63';
			$scope.chosenIcon = $scope.availableIcons[0];
			
			

			
			$scope.showAddDialog = function() {
				// Getting available categories
				$http.get('/API/Category/Available').success(
						function(availableCategories) {
							$scope.addCategory();
						});
			}

			$scope.addCategory = function(icon, color) {
				
				var newCategory = {
					icon : icon,
					order : $scope.categories().length,
					color : color.replace('#', '')
				};
				ExpTracker.categories.add(newCategory, function(category) {
					$scope.closeDialogs();
					ExpTracker.history.refresh();
				});

			}

			$scope.addExpense = function(categoryId, amount, income, date) {
				if(income == undefined){
					income = false;
				}
				
				var patt = new RegExp('^[0-9]{4}-[0-9]{2}-[0-9]{2}$');

				
				if(date == undefined || !patt.test(date)){
					var date = new Date();
					
					date = date.getFullYear() + '-' + (date.getMonth() + 1)
					+ '-' + date.getDate();
				}
				
				console.log('Adding expense for cat ' + categoryId);
				var newExpense = {
					category : categoryId,
					amount : amount,
					income : income,
					type : 1,
					date:date
				}
				
				

				ExpTracker.expenses.add(newExpense, function(expense) {
					console.log('Expense added:');
					console.log(expense);
					$scope.closeDialogs();
					ExpTracker.history.refresh();
				})
			}
			
			$scope.showAddExpense = function(index){
				$scope.selectedCategory = $scope.categories()[index];
				console.log($scope.selectedCategory);
			}
			
			$scope.addNewExpenseDigit = function(digit){
				
				var newAmount = $scope.newExpenseAmount+digit;
				
				var patt = new RegExp('^[0-9]+(\\\.[0-9]{0,2})?$');
				
				if(patt.test(newAmount)){
					$scope.newExpenseAmount = newAmount;
				}
				// $scope.newExpenseAmount+=digit;
			}
			
			$scope.removeNewExpenseDigit = function(){
				$scope.newExpenseAmount = $scope.newExpenseAmount.substring(0, $scope.newExpenseAmount.length - 1);
			}
			
			$scope.closeDialogs = function(){
				$scope.selectedCategory = '';
				$scope.newExpenseAmount = '';
				$scope.showCategoryDialog = false;
			}
			

		} ]);
