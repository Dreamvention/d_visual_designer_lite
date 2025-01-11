<vd-popup-layout-block>
<div class="vd vd-popup-overlay" if={this.status}></div>
<div class="vd vd-popup edit-layout {classPopup}" if={this.status} style="max-height:75vh;">
    <div class="popup-header">
        <h2 class="title">{store.getLocal('designer.text_layout')}</h2>
        <a class="close" onClick={close}><i class="fal fa-times"></i></a>
    </div>
        <div data-is='vd-layout-block-{block_type}' block={block_info} designer_id={this.parent.opts.id} class="popup-content"></div>
     <div class="popup-footer">
        <a id="save" class="vd-btn save" onClick={save}>{store.getLocal('designer.button_save')}</a>
    </div>
    <image-manager/>
</div>
<script>
    this.mixin({store:d_visual_designer})
    this.status = false
    this.block_id = ''
    this.classPopup = ''
    this.block_type = ''
    this.width = ''
    this.height = ''
    this.left = ''
    this.top = ''
    this.block_config = _.find(this.store.getState().config.blocks, function(block){
        return block.type == this.block_type
    }.bind(this))
    this.block_info = ''
    this.previewColorChange = 0
    this.layoutSetting = {}

    save(e){
        this.store.dispatch('block/layout/update', _.extend({block_id: this.block_id, designer_id: this.parent.opts.id, type: this.block_config.type}, this.layoutSetting))
    }.bind(this)

    this.store.subscribe('block/layout/setting/update', function(data){

        this.layoutSetting = data
    }.bind(this))

    this.store.subscribe('block/layout/update/success', function(){
        this.status = false
        this.block_id = ''
        this.block_type = ''
        this.update()
    }.bind(this))

    this.store.subscribe('block/layout/begin', function(data){
        if(data.designer_id == this.parent.opts.id) {
            this.status = true
            this.block_id = data.block_id
            this.block_type = data.type
            this.update()
            this.initPopup()
        }
    }.bind(this))

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

    this.on('update', function(){
        if(this.block_type && this.block_id) {
            this.block_config = _.find(this.store.getState().config.blocks, function(block){
                return block.type == this.block_type
            }.bind(this))
            this.block_info = this.store.getState().blocks[this.parent.opts.id][this.block_id]
            this.block_info.id = this.block_id
            if( this.block_info.parent == ''){
                this.classPopup = 'main'
            } else if (this.block_config.setting.child_blocks) {
                this.classPopup = 'inner'
            } else {
                this.classPopup = 'child'
            }
            this.setting = this.store.getState().blocks[this.parent.opts.id][this.block_id].setting
        }
    })

    close() {
        this.status = false
        this.block_id = ''
        this.block_type = ''
    }
</script>
</vd-popup-layout-block>