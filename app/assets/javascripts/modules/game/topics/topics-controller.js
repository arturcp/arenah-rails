define('topics-controller', [], function() {
  function TopicsController(container) {
    this.container = $(container);

    this._bindEvents();
  };

  var fn = TopicsController.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_delete');

    this._allowGroupSorting();
    this._allowTopicSorting();

    this.container.on('click', '.fm-nav .fa-trash', this._delete);

    // $('.topics-groups .fa-trash').on('click', function () {
    //   var topicGroupId = $(this).parents('li[data-topic-group-id]').attr('data-topic-group-id'),
    //       self = this;
    //
    //   bootbox.confirm('Tem certeza que deseja excluir a categoria? Todos os tópicos e posts serão apagados e esta operação não poderá ser desfeita.', function (result) {
    //     if (result) {
    //       $(self).parents('li').remove();
    //
    //       $.ajax({
    //         url: gameRoomUrl() + 'grupo-de-topicos/' + topicGroupId + '/apagar',
    //         type: 'POST',
    //         success: function (data) {
    //           if (data.Status != 'OK') {
    //             NotyMessage.show('Não foi possível excluir a categoria');
    //           } else {
    //             $('.topics-groups li:first').trigger('click');
    //           }
    //         }
    //       });
    //     }
    //   });
    // });
  };

  fn._allowGroupSorting = function() {
    $('.topics-groups').sortable({
      stop: function(event, ui) {
        self._reorderTopicsGroups();
      }
    });
  };

  fn._allowTopicSorting = function() {
    $('.topic-info').sortable({
      start: function(event, ui) {
        $(ui.helper).addClass('notransition');
      },

      stop: function(event, ui) {
        $(ui.helper).removeClass('notransition');
        self._reorderTopics();
      }
    });
  };

  fn._delete = function(e) {
    var element = $(e.target),
        topicId = element.parents('[data-topic-id]').data('topic-id'),
        url = element.parent().data('delete-url'),
        self = this,
        message = 'Tem certeza que deseja excluir o tópico? ' +
          'Todos os posts serão apagados e esta operação não poderá ser desfeita.';

    bootbox.confirm(message, function(result) {
      if (result) {
        $(self).parents('.fm-nav').remove();

        $.ajax({
          url: url,
          type: 'DELETE',
          success: function (data) {
            if (data.status !== 200) {
              NotyMessage.show('Não foi possível excluir o tópico');
            } else {
              element.parents('[data-topic-id]').remove();
            }
          }
        });
      }
    });
  };

  fn._reorderTopics = function() {
    var changes = {};

    $.each($('.subgroup-visible .fm-nav'), function (index) {
      changes[$(this).attr('data-topic-id')] = index + 1;
    });

    $.ajax({
      url: gameRoomUrl() + 'topicos/reordenar',
      traditional: true,
      data: {
        'changes': JSON.stringify(changes)
      },
      type: 'POST',
      success: function (data) {
        if (data.status !== 200) {
          NotyMessage.show('Não foi possível reordenar os tópicos');
        }
      }
    });
  };

  return TopicsController;
});