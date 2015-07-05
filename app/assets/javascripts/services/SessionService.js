function SessionService($http) {

	var sessionService = {};
	sessionService.login = function(username, password, callback) {
		var creds = {
			username : username,
			password : password
		};
		console.log('POST /Login');
		$http.post('/Login', creds, HTTP_HEADERS).success(function(data) {
			console.log('Login:');
			console.log(data);
			if (callback !== undefined) {
				callback(data);
			}
		});
	};

	sessionService.logout = function(callback) {
		if (typeof (Storage) !== "undefined") {
			localStorage.removeItem("token");
		}
		$http.defaults.headers.common.Authorization = '';

		$('login').show();
	};

	return sessionService;

}