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
<vd-layout-column_inner class="block-inner block-container col-md-offset-{block_setting.offset} vd-col-{block_setting.size} level{level%2}" id="{opts.block.id}">
    <div class="control control-top {block_config.setting.button_drag?'drag':''}">
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
</vd-layout-column_inner>
<vd-layout-main-wrapper class="block-parent-wrapper block-container {opts.block.id}" id="{opts.block.id}">
    <div class="control control-{block_config.setting.control_position} {block_config.setting.button_drag?'drag':''}">
        <virtual data-is="control-buttons" block={opts.block}/>
    </div>
    <div class="block-content clearfix {block_config.setting.child? 'child' : ''}" data-is="vd-block-{opts.block.type}" block={opts.block} ref="content"></div>
    <script>
        this.top = this.parent ? this.parent.top : this
        this.level = this.parent.level
        this.mixin({store:d_visual_designer})
        this.setting = this.opts.block.setting.global
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
            this.setting = this.opts.block.setting.global
            this.initChildBlocks()
        })
    </script>
</vd-layout-main-wrapper>
<vd-layout-main class="block-parent block-container {opts.block.id}" id="{opts.block.id}">
    <div class="control control-{block_config.setting.control_position} {block_config.setting.button_drag?'drag':''}">
        <virtual data-is="control-buttons" block={opts.block}/>
    </div>
    <div class="block-content clearfix {block_config.setting.child? 'child' : ''}" data-is="vd-block-{opts.block.type}" block={opts.block} ref="content"></div>
    <script>
        this.top = this.parent ? this.parent.top : this
        this.level = this.parent.level
        this.mixin({store:d_visual_designer})
        this.setting = this.opts.block.setting.global
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
            this.setting = this.opts.block.setting.global
            this.initChildBlocks()
        })
    </script>
</vd-layout-main>
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
<vd-layout-row_inner class="block-inner block-container {opts.block.id} level{level%2}" id="{opts.block.id}">
    <div class="control control-advanced {block_config.setting.button_drag?'drag':''}">
        <virtual data-is="control-buttons" block={opts.block}/>
    </div>
    <div class="block-content clearfix {block_config.setting.child? 'child' : ''}" data-is="vd-block-{opts.block.type}" block={opts.block} ref="content"></div>
    <script>
        this.top = this.parent ? this.parent.top : this
        this.level = this.parent.level
        this.mixin({store:d_visual_designer})
        this.setting = this.opts.block.setting.global
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
            this.setting = this.opts.block.setting.global
            this.initChildBlocks()
        })
    </script>
</vd-layout-row_inner>
