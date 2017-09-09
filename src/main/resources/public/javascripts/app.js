var HTTP_HEADERS = {
	transformRequest : function(obj) {
		var str = [];
		for ( var p in obj) {
			str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
		}
		return str.join("&");
	},
	headers : {
		'Content-Type' : 'application/x-www-form-urlencoded'
	}
};

var app = angular.module('ExpTrackerApp', [ 'angular-chartist', 'ngTouch' ]).run(function($rootScope, $http) {
	$rootScope.showSettings = false;
	$rootScope.animating = false;

	$rootScope.columnWidth = function(){
		return $('.column').width() + $(".column").css("padding-left").replace("px", "")*2;
	};
	
	
	$(document).ready(function(){
		if($('#columns').width()/$('body').width() >= 3){
				$('body').scrollLeft($rootScope.columnWidth());
		}
	});


	
	$rootScope.logout = function(callback) {
		if (typeof (Storage) !== "undefined") {
			localStorage.removeItem("token");
		}
		$http.defaults.headers.common.Authorization = '';

		$('login').show();
	};

	$rootScope.swipeLeft = function() {
		var body = $('body');
		if(!$rootScope.animating){
			$rootScope.animating = true;
			body.animate({scrollLeft:$('body').scrollLeft()+$rootScope.columnWidth()}, '500', 'swing', function(){
				$rootScope.animating = false;
			});
		}
	};

	$rootScope.swipeRight = function() {
		var body = $('body');

		if(!$rootScope.animating){
			$rootScope.animating = true;
			body.animate({scrollLeft:body.scrollLeft()-$rootScope.columnWidth()}, '500', 'swing', function(){
				$rootScope.animating = false;
			});
		}
	};

});

app.config([ '$httpProvider', function($httpProvider) {
	// initialize get if not there
	if (!$httpProvider.defaults.headers.get) {
		$httpProvider.defaults.headers.get = {};
	}

	// Answer edited to include suggestions from comments
	// because previous version of code introduced browser-related errors

	// disable IE ajax request caching
	$httpProvider.defaults.headers.get['If-Modified-Since'] = 'Mon, 26 Jul 1997 05:00:00 GMT';
	// extra
	$httpProvider.defaults.headers.get['Cache-Control'] = 'no-cache';
	$httpProvider.defaults.headers.get.Pragma = 'no-cache';

	// showing loading when there's a request
	$httpProvider.interceptors.push(function($q) {
		var interceptor = {};
		interceptor.count = 0;

		interceptor.request = function(config) {
			if (interceptor.count === 0) {
				$("#http-activity").fadeIn('fast');
			}
			interceptor.count++;

			return config;
		};

		interceptor.response = function(response) {
			interceptor.count--;
			if (interceptor.count === 0) {
				$("#http-activity").fadeOut('fast');
			}

			return response;
		};

		interceptor.responseError = function(rejection) {
			interceptor.count--;
			if (interceptor.count === 0) {
				$("#http-activity").fadeOut('fast');
			}

			if (rejection.status === 401) {
				$('login').show();
			}
			return null;
		};

		return interceptor;
	});

} ]);
