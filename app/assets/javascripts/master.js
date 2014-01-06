angular.module("Clss", ['ui', 'ui.filters'])

.directive("jobtitle", function() {
  return {
    restrict: "A",
    template: "<td><a href='{{job.url}}'>{{job.title}}</a></td>"
  }
})

.directive("jobdate", function() {
  return {
    restrict: "A",
    template: "<td>{{job.date}}</td>"
  }
})

.directive("joblocation", function() {
  return {
    restrict: "A",
    template: "<td>{{job.location}}</td>"
  }
})

.directive("jobdelete", function() {
    return {
      restrict: "A",
      template: "<button class='btn btn-danger'>Delete</button>",
      link: function(scope, element) {
        element.bind("click", function() {
          element.parent("tr").remove();
        })

      }
    }

  })

.controller('JobsCtrl', function($scope, $http) {
  $scope.jobs = {};

  $scope.working = "";

  $scope.alert ="";

  $scope.showJobFiler = false;

  $scope.searched = false;

  $scope.getJobs = function(search_term) {
    if (typeof search_term !== 'undefined') {
      $http.get('/jobs/' + encodeURIComponent(search_term)).
      success(function(data, status) {

        console.log("started");
        $scope.jobs = data
        console.log("hello");

        $scope.showJobFiler = false;

        $scope.searched = true;

      }).
      error(function(data, status) {
        console.log("Something went wrong " + data);
        console.log("Something went wrong " + status);

      });
    }
  }
});
