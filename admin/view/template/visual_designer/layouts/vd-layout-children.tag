<vd-layout-children class="block-child block-container" id="{opts.block.id}">
    <div class="control control-{block_config.setting.control_position} {block_config.setting.button_drag?'drag':''}">
        <virtual data-is="control-buttons" block={opts.block}/>
        <div class="title" if={riot.util.tags.selectTags().search('"vd-block-'+opts.block.type+'"') != -1} data-is='vd-block-{opts.block.type}' block={opts.block}></div>
        <div class="title" if={riot.util.tags.selectTags().search('"vd-block-'+opts.block.type+'"') == -1}>{block_config.title}</div>
    </div>
    <script>
        this.top = this.parent ? this.parent.top : this
        this.level = this.parent.level
        this.block_setting = this.opts.block.setting.global

        this.mixin({store:d_visual_designer})
        this.block_config = _.find(this.store.getState().config.blocks, function(block){
            return block.type == opts.block.type
        })

        this.on('update', function(){
            this.block_config = _.find(this.store.getState().config.blocks, function(block){
                return block.type == opts.block.type
            })
            this.block_setting = this.opts.block.setting.global
        })
    </script>
</vd-layout-children>