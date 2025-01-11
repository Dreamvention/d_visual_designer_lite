<control-buttons>
    <a each={button in getState('buttons')} class="vd-btn vd-btn-small {button.className}"  onClick={button.handleClick} onmousedown={button.handleDown} onmouseup={button.handleUp}></a>
    <div class="block-button" if={!getState().block_config.setting.child}>
        <a id="button_add_block" class="vd-btn vd-btn-add button-add-bottom}" onClick={addBottomBlock}></a>
    </div>
<script>
    this.mixin(new vd_component(this))
    this.initState({
        active: false,
        block_config: _.find(this.store.getState().config.blocks, function(block){
            return block.type == opts.block.type
        })
    })
    this.on('update', function(){
        this.setState('block_config', _.find(this.store.getState().config.blocks, function(block){
            return block.type == opts.block.type
        }))
    })
    this.initButton = function(){
        var buttons = []
        var setting = this.getState().block_config.setting
        if(setting.button_drag) {
            buttons.push({
                className: 'drag vd-btn-drag',
                handleClick: null,
                handleUp: function(){
                   this.store.dispatch('block/drag/end',  { designer_id: this.parent.getState().top.opts.id, type: this.opts.block.type, block_id: this.opts.block.id})
                }.bind(this),
                handleDown: function(){
                    this.store.dispatch('block/drag/start',  { designer_id: this.parent.getState().top.opts.id, type: this.opts.block.type, block_id: this.opts.block.id})
                }.bind(this)
            })
        }
        if(setting.button_edit) {
            buttons.push({
                className: 'vd-btn-edit',
                handleClick: function(){
                    this.store.dispatch('block/setting/begin', {block_id: this.opts.block.id, type: this.opts.block.type, designer_id: this.getState().top.opts.id})
                }.bind(this),
                handleUp: null,
                handleDown: null
            })
        }
        if(setting.button_copy) {
            buttons.push({
                className: 'vd-btn-copy',
                handleClick: function(){
                    this.store.dispatch('block/clone', { designer_id: this.parent.getState().top.opts.id, target: this.opts.block.id})
                }.bind(this),
                handleUp: null,
                handleDown: null
            })
        }
        if(setting.button_layout) {
            buttons.push({
                className: 'vd-btn-layout',
                handleClick: function(){
                    this.store.dispatch('block/layout/begin', {block_id: this.opts.block.id, type: this.opts.block.type, designer_id: this.getState().top.opts.id})
                }.bind(this),
                handleUp: null,
                handleDown: null
            })
        }
        if(setting.child) {
            buttons.push({
                className: 'vd-btn-add-child',
                handleClick: function(){
                    this.store.dispatch('block/new', {type: setting.child, designer_id:this.parent.getState().top.opts.id, target: this.opts.block.id, level: this.getState().level})
                }.bind(this),
                handleUp: null,
                handleDown: null
            })
        }
        if(setting.button_remove) {
            buttons.push({
                className: 'vd-btn-remove',
                handleClick: function(){
                    this.store.dispatch('block/remove', {designer_id: this.getState().top.opts.id, block_id: this.opts.block.id, type: this.opts.block.type})
                }.bind(this),
                handleUp: null,
                handleDown: null
            })
        }
        this.setState('buttons', buttons)
    }

    cloneBlock(e) {
        this.store.dispatch('block/clone', { designer_id:this.parent.top.opts.id, target: this.opts.block.id})
    }
    addChildBlock(e) {
         this.store.dispatch('block/new', {type: this.getState().block_config.setting.child, designer_id:this.parent.top.opts.id, target: this.opts.block.id, level: this.getState().level})
    }
    addBottomBlock(e) {
        this.store.dispatch('popup/addBlock', {parent_id: this.opts.block.parent, designer_id: this.getState().top.opts.id, level: this.parent.getState().level});
    }
    layoutBlock (e) {
        this.store.dispatch('block/layout/begin', {block_id: this.opts.block.id, type: this.opts.block.type, designer_id: this.getState().top.opts.id})
    }
    removeBlock (e) {
        this.store.dispatch('block/remove', {designer_id: this.getState().top.opts.id, block_id: this.opts.block.id, type: this.opts.block.type})
    }
    this.initButton()
</script>
</control-buttons>