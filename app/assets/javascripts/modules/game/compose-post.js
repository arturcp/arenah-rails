define('compose-post', [], function() {
  var ComposePostUI = require('compose-post-ui');

  function ComposePost(recipients, characters) {
    this.composePostUI = new ComposePostUI();

    this.recipients = recipients;
    this.characters = characters;
    this.saveButton = $('#save-post');
    this.recipientsWidth = '627px';

    this._bindEvents();
  };

  var fn = ComposePost.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, 'autoComplete', 'selectRecipient', 'onSave');

    this.characters.load(this.autoComplete);
    this.recipients.onSelect(this.selectRecipient);
    this.saveButton.on('click', this.onSave);
  };

  fn.autoComplete = function() {
    var panels = this.composePostUI;

    this.recipients.container.select2({
      data: this.characters.pcs,
      width: this.recipientsWidth,
      multiple: true
    })
    .on('change', function(e) {
      if (e.val.length == 1 && panels.isInDicePanel()) {
        panels.closeAllPanels();
        panels.openGroupPanel();
      } else if (e.val.length == 0 && !panels.isInDicePanel()) {
        panels.openDicePanel();
      }
    })
    .on('select2-selecting', function(e) {
      panels.showOnGroup(e.choice.id);
    })
    .on('select2-removing', function(e) {
      panels.showOnOthers(e.choice.id);
    });
  };

  fn.selectRecipient = function(id) {
    this.composePostUI.showOnGroup(id);
  };

  fn.onSave = function(event) {
    event.preventDefault();

    var message = $('#bbcode-editor').val();

    if (message.length == 0) {
      NotyMessage.show('O post não pode ficar em branco');
    } else {
      $(event.target).parents('form').submit();
    }
  };

  return ComposePost;
});
