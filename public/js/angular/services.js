angular.module('thumbService',[] )
    .factory('ThumbGenerator',function($http) {
        return {
            get : function() {
                return $http.get('/300/300');
            }
        }
    });