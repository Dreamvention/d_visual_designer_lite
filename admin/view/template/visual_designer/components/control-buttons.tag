<control-buttons>
    <a id="button_edit" class="vd-btn vd-btn-small vd-btn-edit" if={block_config.setting.button_edit} onClick={editBlock} onmousedown="{diableDrag}"></a>
    <a id="button_copy" class="vd-btn vd-btn-small vd-btn-copy" if={block_config.setting.button_copy} onclick={cloneBlock} onmousedown="{diableDrag}"></a>
    <a id="button_layout" class="vd-btn vd-btn-small vd-btn-layout" if={block_config.setting.button_layout} onClick={layoutBlock} onmousedown="{diableDrag}"></a>
    <a id="button_remove" class="vd-btn vd-btn-small vd-btn-remove" if={block_config.setting.button_remove} onClick={removeBlock} onmousedown="{diableDrag}"></a>
<script>
    this.top = this.parent ? this.parent.top : this
    this.mixin({store:d_visual_designer})
    this.block_config = _.find(this.store.getState().config.blocks, function(block){
        return block.type == opts.block.type
    })
    this.on('update', function(){
        this.block_config = _.find(this.store.getState().config.blocks, function(block){
            return block.type == opts.block.type
        })
    })

    this.on('mount', function(){
        $(this.parent.root).children('.control').on('mousedown', function(e){
            if(e.button === 0) {
                this.store.dispatch('block/drag/start', {
                    designer_id: this.top.opts.id,
                    type: this.opts.block.type,
                    block_id: this.opts.block.id
                })
            }
        }.bind(this))

        $(this.parent.root).children('.control').on('mouseup', function(e){
            if (e.button === 0) {
                this.store.dispatch('block/drag/end', {
                    designer_id: this.top.opts.id,
                    type: this.opts.block.type,
                    block_id: this.opts.block.id
                })
            }
        }.bind(this))
    })
    diableDrag(e){
        e.preventDefault()
        e.stopPropagation()
    }
    editBlock (e) {
        this.store.dispatch('block/setting/begin', {block_id: this.opts.block.id, type: this.opts.block.type, designer_id: this.top.opts.id})
    }
    cloneBlock(e) {
        this.store.dispatch('block/clone', { designer_id:this.parent.top.opts.id, target: this.opts.block.id})
    }
    layoutBlock (e) {
        this.store.dispatch('block/layout/begin', {block_id: this.opts.block.id, type: this.opts.block.type, designer_id: this.top.opts.id})
    }
    removeBlock (e) {
        this.store.dispatch('block/remove', {designer_id: this.top.opts.id, block_id: this.opts.block.id, type: this.opts.block.type})
    }
</script>
</control-buttons>