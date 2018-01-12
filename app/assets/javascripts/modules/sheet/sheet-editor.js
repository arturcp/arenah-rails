// SheetEditor is responsible to deal with changes on the character sheets.
//
// It knows which class to call when the user edits a specific attributes group,
// and is also responsible to change between view and edit mode. All classes to
// deal with groups can be found at ./editable-types/*.js
define('sheet-editor', ['editable-based', 'editable-bullet', 'editable-character-card',
  'editable-equipments', 'editable-mixed', 'editable-name-value', 'editable-rich-text',
  'editable-text'], function(EditableBased, EditableBullet, EditableCharacterCard,
  EditableEquipments, EditableMixed, EditableNameValue, EditableRichText, EditableText) {

  function SheetEditor(options = {}) {
    this.isMaster = options.isMaster || false;
    this.isSheetOwner = options.isSheetOwner || false;
    this.freeMode = options.freeMode || false;
    this.equipmentsUrl = options.equipmentsUrl || '';

    this.currentEditable = null;
    this._backupData = null;
    this.editableTypes = {
      based: EditableBased,
      bullet: EditableBullet,
      character_card: EditableCharacterCard,
      equipments: EditableEquipments,
      mixed: EditableMixed,
      name_value: EditableNameValue,
      rich_text: EditableRichText,
      text: EditableText
    };

    this.editButtons = $('.editable-edit');
    this.saveButtons = $('.editable-submit');
    this.cancelButtons = $('.editable-cancel');

    this.attributesGroups = $('.attributes-group');

    this._authorize();
    this._bindEvents();
  };

  var fn = SheetEditor.prototype;

  fn._bindEvents = function() {
    $.proxyAll(
      this,
      '_changeToEditMode',
      '_edit',
      '_save',
      '_cancel'
    );

    this.editButtons.on('click', this._edit);
    this.saveButtons.on('click', this._save);
    this.cancelButtons.on('click', this._cancel);
  };

  fn._edit = function(event) {
    var element = $(event.currentTarget),
        data = this.currentAttributesGroupData(element),
        groupType = data.attributesGroup.data('type');

    this._focusOnGroup(data.attributesGroup);

    this._backup(data);
    this.editButtons.hide();

    if (groupType) {
      this.currentEditable = null;

      if (this.editableTypes[groupType]) {
        this.currentEditable = new this.editableTypes[groupType](this, data);
      }
    }

    this._changeToEditMode(data);
  };

  fn._save = function(event) {
    var element = $(event.currentTarget);

    // TODO: update screen with js or use ajax and reload page?
    // TODO: on the backend, check if the user is master or character owner
    // before saving.
    // TODO: it would be a nice feature to log modifications to show to the
    // game master
    element.siblings('.editable-cancel:first').trigger('click');

    if (this.currentEditable && this.currentEditable.onSave && typeof this.currentEditable.onSave == "function") {
      this.currentEditable.onSave(data);
    }
  };

  fn._cancel = function(event) {
    this._restoreGroupsOpacity();

    this.editButtons.show();

    var data = this.currentAttributesGroupData($(event.currentTarget));

    data.attributesGroup.find('a[data-editable-attribute]').editable('hide');
    data.attributesGroup.find("[data-accept-edit-mode]").removeClass("edit-mode");
    data.save.hide();
    data.cancel.hide();
    data.edit.show();
    this._rollback();

    if (this.currentEditable && this.currentEditable.onCancel && typeof this.currentEditable.onCancel == "function") {
      this.currentEditable.onCancel(data);
    }
  };

  fn.currentAttributesGroupData = function(element) {
    var attributesGroup = $(element).parents('.attributes-group'),
        manageContainer = attributesGroup.find('.manage-attributes-group'),
        edit = manageContainer.find('.editable-edit'),
        save = manageContainer.find('.editable-submit'),
        cancel = manageContainer.find('.editable-cancel'),
        points = parseInt(attributesGroup.attr('data-points')),
        usedPoints = parseInt(attributesGroup.attr('data-used-points'));

    return {
      'attributesGroup': attributesGroup,
      'edit': edit,
      'save': save,
      'cancel': cancel,
      'points': points,
      'usedPoints': usedPoints
    };
  };

  fn._changeToEditMode = function(data) {
    var self = this;

    data.attributesGroup.find('a[data-editable-attribute]').editable('destroy');
    data.attributesGroup.find('a[data-editable-attribute]').editable({
      toggle: 'manual',
      showbuttons: false,
      onblur: 'ignore',
      mode: 'inline',
      emptytext: '',
    }).on('shown', function(e, editable) {
      if (self.currentEditable && self.currentEditable.transform && typeof self.currentEditable.transform === 'function') {
        self.currentEditable.transform(editable);
      }
    });

    data.attributesGroup.find('a[data-editable-attribute]').editable('show');
    data.attributesGroup.find("[data-accept-edit-mode]").addClass("edit-mode");
    data.attributesGroup.find("input:first").focus();
    data.save.show();
    data.cancel.show();
    data.edit.hide();
  };

  fn._authorize = function() {
    var manageGroupContainer = $('.manage-group-container');

    if (this.isMaster || this.isSheetOwner) {
      manageGroupContainer.show();
    } else {
      manageGroupContainer.remove();
    }

    if (!this.isMaster && !this.freeMode) {
      this._removeNotEditableFields();
    }

    if (!this.isMaster) {
      $('[data-master-only=true]').removeAttr('data-editable-attribute');
    }
  };

  fn._removeNotEditableFields = function() {
    $('[data-editable-attribute=text]').removeAttr('data-editable-attribute');
    $('.attributes-group[data-editable-only-on-free-mode]').find('.manage-group-container').remove();
  };

  fn._backup = function(data) {
    this._backupData = $.extend({}, data);
  };

  fn._rollback = function() {
    if (this._backupData) {
      this.changeAttributePoints(this._backupData);
      this._clearStash();
    }
  };

  fn._clearStash = function() {
    this._backupData = null;
  },

  fn.changeAttributePoints = function(data) {
    data.attributesGroup.attr('data-used-points', data.usedPoints);
    var pointsCounter = data.attributesGroup.find('.points-counter');

    if (pointsCounter) {
      pointsCounter.html(data.usedPoints);
      pointsCounter.removeClass('exceeded-points').removeClass('available-points');

      if (data.usedPoints < data.points) {
        pointsCounter.addClass('available-points');
      }
      else if (data.usedPoints > data.points) {
        pointsCounter.addClass('exceeded-points');
      }
    }
  };

  fn._focusOnGroup = function(group) {
    this.attributesGroups.css({ opacity: 0.2 });
    group.css({ opacity: 1 });
  };

  fn._restoreGroupsOpacity = function() {
    this.attributesGroups.css({ opacity: 1 });
  };

  return SheetEditor;
});