angular.module('salesFront')
    .factory('errorInterceptor', function ($q, $location) {
    return {
        'responseError': function (errorResponse) {
            switch (errorResponse.status) {
                case 401:
                    $location.path('/');
                    break;
                default:
                    break;
            }
            return $q.reject(errorResponse);
        }
    };
});
