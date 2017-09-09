function SettingsService($http) {
	var settingService = {};
	settingService.list = [];
	
	
	// Add expense
	settingService.update = function(setting, callBack) {
		console.log('PUT /API/Setting/'+setting.name);
		console.log('data:');
		console.log(setting);

		$http.put('/API/Setting/'+setting.name, setting, HTTP_HEADERS).success(function(setting) {
			
			if (callBack !== undefined) {
				callBack(setting);
			}
		});
	};
	
	settingService.refresh = function(callBack){
		console.log('GET /API/Setting');
		$http.get('/API/Setting').success(function(data){
			settingService.list = data;
			console.log('Settings:');
			console.log(data);
			if (callBack !== undefined) {
				callBack(data);
			}
		});
	};
	
	return settingService;
}