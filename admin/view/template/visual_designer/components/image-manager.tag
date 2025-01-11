<image-manager>
    <script>
        this.mixin({
            store: d_visual_designer
        })
        window.addSingleImage = function(imageName, field, thumb) {
            $.ajax({
                url: that.store.getState().config.new_image_url+'&image=' + encodeURIComponent(imageName),
                dataType: 'text',
                context: this,
                success: function(imageCacheName) {
                    $('#' + thumb).find('img').attr('src', imageCacheName);
                    $('#' + field).val(imageName);
                    var event = new Event('change');[]
                     $('#' + field)[0].dispatchEvent(event);
                }
            });
        };

        window.selectImage = function(){
            that.store.dispatch('popup/image-manager/hide', {designer_id: that.opts.designer_id})
        }

        var that =this
        $(document).off('click', 'a[data-toggle=\'vd-image\']');
        $(document).on('click', 'a[data-toggle=\'vd-image\']', function (e) {
            e.preventDefault();

            $('.popover').popover('hide', function () {
                $('.popover').remove();
            });

            var element = this;

            $(element).popover({
                html: true,
                placement: 'right',
                trigger: 'manual',
				sanitize: false,
                content: function () {
                    return '<button type="button" id="vd-button-image" class="btn btn-primary"><i class="fas fa-pencil"></i></button><button type="button" id="vd-button-clear" class="btn btn-danger"><i class="far fa-trash-alt"></i></button>';
                }
            });

            $(element).popover('show');

            $('#vd-button-image').on('click', function () {
                that.store.dispatch('popup/image-manager/show', {designer_id: that.opts.designer_id, input_id: $(element)
                        .parent().find('input').attr('id'), element_id:$(element).attr('id') })

                $(element).popover('hide', function () {
                    $('.popover').remove();
                });
            });

            $('#vd-button-clear').on('click', function () {
                $(this).closest('.fg-setting').find('img').attr('src', $(this).closest('.fg-setting').find(
                    'img').attr('data-placeholder'));

                $(this).closest('.fg-setting').find('input').attr('value', '');

                $(this).popover('hide', function () {
                    $('.popover').remove();
                });
                var event = new Event('change');
                $(this).closest('.fg-setting').find('input')[0].dispatchEvent(event);

            });

        });
    </script>
</image-manager>
