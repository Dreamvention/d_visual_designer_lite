<vd-popup-image-manager>
<div class="vd vd-popup image-manager" if={this.status} style="max-height:75vh;">
    <div class="popup-header">
        <h2 class="title">{store.getLocal('designer.text_file_manager')}</h2>
        <a class="close" onClick={close}><i class="fal fa-times"></i></a>
    </div>
    <div class="popup-content">
        <div class="popup-image-manager">
            <iframe src="{store.getState().config.filemanager_url}&field={input_id}&thumb={element_id}" frameborder="no" scrolling="no"></iframe>
        </div>
    </div>
</div>
<script>
    this.mixin({store:d_visual_designer})
    this.status = false
    this.designer_id = this.parent.opts.id
    this.input_id = ''
    this.element_id = ''
    this.left = ''
    this.top = ''

    this.store.subscribe('popup/image-manager/show', function(data){
        if(this.designer_id == data.designer_id) {
            this.status = true
            this.input_id = data.input_id
            this.element_id = data.element_id
            this.update()
        }
    }.bind(this))
    this.store.subscribe('popup/image-manager/hide', function(data){
        if(this.designer_id == data.designer_id) {
            this.status = false
            this.input_id = ''
            this.element_id = ''
            this.update()
        }
    }.bind(this))

    this.initPopup = function() {
        $('.vd-popup', this.root).draggable({
            handle: '.popup-header',
            drag: function(event, ui) {
                if (!ui.helper.hasClass('drag')) {
                    ui.helper.addClass('drag');
                }
            },
            stop: function(event, ui) {
                if (ui.position.top < 0) {
                    ui.helper.css({ 'top': '10px' });
                }
                var height = $(window).height();
                if ((ui.position.top + 100) > height) {
                    ui.helper.css({ 'top': (height - 100) + 'px' });
                }
                this.left = ui.position.left
                this.top = ui.position.top
            }.bind(this)
        });
        if (this.left != '' && this.top != '') {
            $('.vd-popup', this.root).addClass('drag');
            $('.vd-popup', this.root).css({ 'left': this.left, 'top': this.top });
        }
        $('.vd-popup', this.root).css({ visibility: 'visible', opacity: 1 });
    }.bind(this)

    this.on('updated', function(){
        if(this.status) {
            this.initPopup()
        }
    })

    close() {
        this.status = false
    }
</script>
</vd-popup-image-manager>