'use strict';

angular.module('salesFront').factory('Sessions', ['$resource', '$rootScope', function Sessions($resource, $rootScope) {
  var resource = $resource('/api/sessions/:id', {}, {
    create: {
      method: 'POST'
    },
    destroy: {
      method: 'DELETE',
      params: {
        id: '@id'
      }
    },
  });

  return {
    createSession: function(params) {
      return resource.create(params).$promise;
    },

    destroySession: function(params) {
      return resource.destroy(params).$promise;
    }
  };
}]);
