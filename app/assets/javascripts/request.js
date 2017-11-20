App.Request = () => {};

App.Request.updateRequests = (requests) => {
  $('.js-requests').replaceWith(requests);
}
