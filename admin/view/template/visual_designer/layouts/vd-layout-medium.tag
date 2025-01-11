<vd-layout-medium class="block-inner block-container col-md-offset-{block_setting.offset} vd-col-{block_setting.size}" id="{opts.block.id}">
    <div class="control control-{block_config.setting.control_position} {block_config.setting.button_drag?'drag':''}">
        <virtual data-is="control-buttons" block={opts.block}/>
    </div>
    <div class="block-content clearfix {block_config.setting.child? 'child' : ''}" data-is="vd-block-{opts.block.type}" block={opts.block}></div>
    <script>
        this.top = this.parent ? this.parent.top : this
        this.level = this.parent.level
        this.block_setting = this.opts.block.setting.global
        this.mixin({store:d_visual_designer})
        this.block_config = _.find(this.store.getState().config.blocks, function(block){
            return block.type == opts.block.type
        })
       
        this.initChildBlocks = function(){
            this.childBlocks = this.store.getBlocks(this.parent.top.opts.id, this.opts.block.id)

            for (var key in this.childBlocks) {
                var childItems = this.store.getBlocks(this.parent.top.opts.id, key)
            }
        }
        this.initChildBlocks()

        this.on('update', function(){
            this.block_config = _.find(this.store.getState().config.blocks, function(block){
                return block.type == opts.block.type
            })
            this.block_setting = this.opts.block.setting.global
            this.initChildBlocks()
            
        })
    </script>
</vd-layout-medium>