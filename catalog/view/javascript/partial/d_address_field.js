var d_address_field = {

    setting: {
      zone_id: 0,
      text_none: '',
      text_select: '',
    },

    init: function(setting) {
        this.setting = $.extend({}, this.setting, setting);
        this.render();
    },

    changeCountry: function(country){
      var setting = this.setting;
      $.ajax({
        url: 'index.php?route=account/account/country&country_id=' + country.value,
        dataType: 'json',
        beforeSend: function() {
          $('select[name=\'country_id\']').after(' <i class="fa fa-circle-o-notch fa-spin"></i>');
        },
        complete: function() {
          $('.fa-spin').remove();
        },
        success: function(json) {
          if (json['postcode_required'] == '1') {
            $('input[name=\'postcode\']').parent().parent().addClass('required');
          } else {
            $('input[name=\'postcode\']').parent().parent().removeClass('required');
          }

          html = '<option value="">'+setting.text_select+'</option>';

          if (json['zone'] && json['zone'] != '') {
            for (i = 0; i < json['zone'].length; i++) {
              html += '<option value="' + json['zone'][i]['zone_id'] + '"';

              if (json['zone'][i]['zone_id'] == setting.zone_id) {
                html += ' selected="selected"';
                }

                html += '>' + json['zone'][i]['name'] + '</option>';
            }
          } else {
            html += '<option value="0" selected="selected">'+setting.text_none+'</option>';
          }

          $('select[name=\'zone_id\']').html(html);
        },
        error: function(xhr, ajaxOptions, thrownError) {
          alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
        }
      });
    },

    render: function() {
      var that = this;
      $('select[name=\'country_id\']').on('change', function() {
        that.changeCountry(this);
      });

      $('select[name=\'country_id\']').trigger('change');
    }
}