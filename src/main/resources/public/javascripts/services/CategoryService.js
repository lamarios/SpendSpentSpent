function CategoryService($http) {
	var categoryService = {};

	categoryService.list = [];
	categoryService.availableIcons = [];

	categoryService.add = function(category, callback) {
		console.log('Calling /API/Category');
		// Adding the category
		$http.post('/API/Category', category, HTTP_HEADERS).success(
				function(category) {
					categoryService.list.push(category);

					categoryService.refreshAvailableIcons();
					if (callback !== undefined) {
						callback(category);
					}
				});

	};

	categoryService.refreshAvailableIcons = function(callback) {

		console.log('Calling /API/Category/Available');
		$http.get('/API/Category/Available').success(function(data) {
			categoryService.availableIcons = data;

			if (callback !== undefined) {
				callback(category);
			}
		});
	};

	categoryService.refresh = function(callback) {
		console.log('Calling /API/Category');
		$http.get('/API/Category').success(function(data) {
			console.log(data);

			categoryService.list = data;

			if (callback !== undefined) {
				callback(category);
			}
			// categoryService.list = data;
		}).error(function(err) {
			return err;
		});
	};
	
	categoryService.delete = function(category, callback){
		console.log('Calling /API/Category/'+category.id);
		$http.delete('/API/Category/'+category.id).success(function(data){
			var index = categoryService.list.indexOf(category);
			categoryService.list.splice(index, 1);
			if (callback !== undefined) {
				callback(data);
			}
		});
	};

	return categoryService;
}
