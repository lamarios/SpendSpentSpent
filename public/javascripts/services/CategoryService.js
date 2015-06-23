
function CategoryService($http) {
	var categoryService = {};

	categoryService.list = [];
	categoryService.availableIcons = [];
	
	categoryService.add = function(category, callback) {
		console.log('Calling /API/Category');
		// Adding the category
		$http.post('/API/Category', category, HTTP_HEADERS).success(function(category) {
			categoryService.list.push(category);
			
			categoryService.refreshAvailableIcons();
			if (callback != undefined) {
				callback(category);
			}
		});
		
	};
	
	categoryService.refreshAvailableIcons = function(callback){
		
		while (categoryService.availableIcons.length > 0) {
			categoryService.availableIcons.pop();
		}
		
		console.log('Calling /API/Category/Available');
		$http.get('/API/Category/Available').success(function(data) {
			angular.forEach(data, function(value){
				categoryService.availableIcons.push(value);
				
			});
			

			if (callback != undefined) {
				callback(category);
			}
		});
	}
	
	categoryService.refresh = function(callback){
		console.log('Calling /API/Category');
		$http.get('/API/Category').success(function(data) {
			console.log(data);
			angular.forEach(data, function(value, index) {
				categoryService.list.push(value);
			});

			if (callback != undefined) {
				callback(category);
			}
			// categoryService.list = data;
		}).error(function(err) {
			return err;
		});
	}

	return categoryService;
}
