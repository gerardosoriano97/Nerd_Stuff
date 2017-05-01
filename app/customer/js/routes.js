var customerApp = angular.module('app', ['ngRoute']);
customerApp.config(['$routeProvider','$locationProvider', function($routeProvider,$locationProvider) {
    $locationProvider.hashPrefix('');
    $routeProvider.
    when('/',{
        templateUrl: 'customer/templates/main.html',
        controller: "mainCtrl"
    }).
    when('/about',{
        templateUrl: 'customer/templates/about.html'
    }).
    when('/blog',{
        templateUrl: 'customer/templates/blog.html'
    }).
    when('/contact',{
        templateUrl: 'customer/templates/contact.html'
    }).
    otherwise({
        redirectTo: '/'             
    });
}]);

customerApp.controller('mainCtrl', ['$scope', function($scope) {
    $scope.heading = 'Add / Edit Customer';
}]);