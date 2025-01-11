var d_custom_field = {

    init: function() {
        console.log('start d_custom_field');
        this.render();
    },

    changeCustomerGroup: function(customer_group){

        $.ajax({
            url: 'index.php?route=account/register/customfield&customer_group_id=' + customer_group.value,
            dataType: 'json',
            success: function(json) {
                $('.custom-field').hide();
                $('.custom-field').removeClass('required');

                for (i = 0; i < json.length; i++) {
                    custom_field = json[i];

                    $('#custom-field' + custom_field['custom_field_id']).show();

                    if (custom_field['required']) {
                        $('#custom-field' + custom_field['custom_field_id']).addClass('required');
                    }
                }


            },
            error: function(xhr, ajaxOptions, thrownError) {
                alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
            }
        });
    },

    upload: function(node){

        $('#form-upload').remove();

        $('body').prepend('<form enctype="multipart/form-data" id="form-upload" style="display: none;"><input type="file" name="file" /></form>');

        $('#form-upload input[name=\'file\']').trigger('click');

        if (typeof timer != 'undefined') {
          clearInterval(timer);
        }

        timer = setInterval(function() {
            if ($('#form-upload input[name=\'file\']').val() != '') {
              clearInterval(timer);

              $.ajax({
                url: 'index.php?route=tool/upload',
                type: 'post',
                dataType: 'json',
                data: new FormData($('#form-upload')[0]),
                cache: false,
                contentType: false,
                processData: false,
                beforeSend: function() {
                  $(node).button('loading');
                },
                complete: function() {
                  $(node).button('reset');
                },
                success: function(json) {
                  $(node).parent().find('.text-danger').remove();

                  if (json['error']) {
                    $(node).parent().find('input').after('<div class="text-danger">' + json['error'] + '</div>');
                  }

                  if (json['success']) {
                    alert(json['success']);

                    $(node).parent().find('input').attr('value', json['code']);
                  }
                },
                error: function(xhr, ajaxOptions, thrownError) {
                  alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
                }
              });
            }
        }, 500);
    },

    sort: function(){
        $('fieldset').each(function(){
            $this = $(this);
            $this.find('.form-group[data-sort]').detach().each(function() {
              if ($(this).attr('data-sort') >= 0 && $(this).attr('data-sort') <= $('.form-group').length) {
                $this.find('.form-group').eq($(this).attr('data-sort')).before(this);
              }

              if ($(this).attr('data-sort') > $('.form-group').length) {
                $this.find('.form-group:last').after(this);
              }

              if ($(this).attr('data-sort') < -$('.form-group').length) {
                $this.find('.form-group:first').before(this);
              }
            });

        })
    },


    render: function() {
        var that = this;

        that.sort();

        $(document).on('change', 'input[name=\'customer_group_id\']', function() {
            that.changeCustomerGroup(this);
        });

        $('input[name=\'customer_group_id\']:checked').trigger('change');

        $(document).on('click', 'button[id^=\'button-custom-field\']', function() {
            that.upload(this);
        });

        $('.date').datetimepicker({
          pickTime: false
        });

        $('.datetime').datetimepicker({
          pickDate: true,
          pickTime: true
        });

        $('.time').datetimepicker({
          pickDate: false
        });
    }
}