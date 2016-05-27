define('new-content', [], function() {
  function NewContent(container) {
    this.container = $(container);
  };

  var fn = NewContent.prototype;

  fn._validForm = function() {
    var option = this.container.find('[data-new-content-option]:checked').val(),
        titleInput = this.container.find('#title'),
        nameInput = this.container.find('#name'),
        valid = false;

    if (titleInput.length > 0 && $.trim(titleInput.val()) === '') {
      NotyMessage.show('O título é obrigatório', 2000);
    } else if (nameInput.length > 0 && $.trim(nameInput.val()) === '') {
      NotyMessage.show('O nome é obrigatório', 2000);
    } else {
      valid = true;
    }

    return valid;
  };

  fn.save = function() {
    if (this._validForm()) {
      var activeGroup = $('[data-topic-group-id].active');
      this.container.find('#topic-group-id').val(activeGroup.data('topic-group-id'));

      this.container.submit();
    }
  };

  return NewContent;
});
