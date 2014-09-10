var thumbController = angular.module('thumbController',[]);

thumbController.controller('mainController', ['$scope','$http','ThumbGenerator',
  function( $scope, $http, ThumbGenerator ) {
    console.log("121");
}]);


var thumbGenerator = angular.module('thumbGenerator',['thumbController','thumbService']);

thumbGenerator.config(['$routeProvider',
    function($routeProvider) {
        $routeProvider.
            when('/', {
                controller: 'mainController'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);