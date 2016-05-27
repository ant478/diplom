'use strict';

angular.module('salesFront').factory('Users', ['$resource', '$rootScope', function Users($resource, $rootScope) {
  var resource = $resource('/api/apiusers/:id', {}, {
    index: {
      method: 'GET',
      params: {
        isArray: true
      }
    },
    show: {
      method: 'GET',
      params: {
        id: '@id'
      }
    },
    create: {
      method: 'POST'
    },
    update: {
      method: 'PUT'
    },
    destroy: {
      method: 'DELETE',
      params: {
        id: '@id'
      }
    }
  });

  return {
    getUsers: function(params) {
      return resource.index(params).$promise;
    },

    getUser: function(params) {
      return resource.show(params).$promise;
    },

    createUser: function(params) {
      return resource.create(params).$promise;
    },

    updateUser: function(params) {
      return resource.update(params).$promise;
    },

    destroyUser: function(params) {
      return resource.destroy(params).$promise;
    }
  };
}]);
