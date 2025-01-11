<vd-popup-codeview>
<div class="vd vd-popup-overlay" if={this.status}></div>
<div class="vd vd-popup add_template" if={this.status} style="max-height:75vh;">
    <div class="popup-header">
        <h2 class="title">{store.getLocal('designer.text_codeview')}</h2>
        <a class="close" onClick={close}><i class="fal fa-times"></i></a>
    </div>
    <div class="popup-content">
        <div class="popup-codeview">
            <textarea name="codeview" class="text-codeview form-control" onChange={change}>{content}</textarea>
        </div>
    </div>
    <div class="popup-footer">
        <a id="save-codeview" class="vd-btn save" onClick={save}>{store.getLocal('designer.button_save')}</a>
    </div>
</div>
<script>
    this.mixin({store:d_visual_designer})
    this.status = false
    this.designer_id = this.parent.opts.id
    this.content = this.store.getState().content[this.designer_id]
    this.width = ''
    this.height = ''
    this.left = ''
    this.top = ''

    this.store.subscribe('content/codeview/success', function(data){
        if(this.designer_id == data.designer_id) {
            this.content = this.store.getState().content[this.designer_id]
            this.status = true
            this.update()
        }
    }.bind(this))

    this.store.subscribe('content/codeview/update/success', function(data){
        if(this.designer_id == data.designer_id) {
            this.status = false
            this.update()
        }
    }.bind(this))

    save(e){
        this.store.dispatch('content/update', {designer_id: this.designer_id, content: this.content, post_action: ['content/codeview/update/success']})
    }.bind(this)

    this.initPopup = function() {
        $('.vd-popup', this.root).resizable({
            start: function(){
                $('body').addClass('vd-resizable')
            },
            resize: function(event, ui) {
                if(!$('.vd-popup', this.root).hasClass('drag')){
                    $('.vd-popup', this.root).addClass('drag')
                }
                
                $('.vd-popup', this.root).css({ 'max-height': '' });
            }.bind(this),
            stop: function( event, ui ) {
                this.width = ui.size.width;
                this.height = ui.size.height;
                $('body').removeClass('vd-resizable')
            }.bind(this)
        });
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
        if (this.width != '' && this.height != '') {
            $('.vd-popup', this.root).css({ 'width': this.width, 'height': this.height });
        }
        $('.vd-popup', this.root).css({ visibility: 'visible', opacity: 1 });
    }.bind(this)

    this.on('updated', function(){
        if(this.status) {
            this.initPopup()
        }
    })

    change(e) {
        this.content = e.target.value
    }

    close() {
        this.status = false
    }
</script>
</vd-popup-codeview>