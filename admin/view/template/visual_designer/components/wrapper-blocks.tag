<wrapper-blocks><div data-is="placeholder" if={drag && !_.isEmpty(blocks)} show="{placeholder}" placeholder_type="{placeholder_type}" sort_order="0" block_id="{parent_id}"/><virtual each="{block in blocks}"><div data-is="vd-layout-{block.layout}" block="{block}"></div>
<div data-is="placeholder" placeholder_type="{placeholder_type}" sort_order="{block.sort_order+1}" block_id="{parent_id}" if={drag} show="{placeholder}"/></virtual><div data-is="placeholder" if={drag && _.isEmpty(blocks)} show="{placeholder}" placeholder_type="{placeholder_type}" sort_order="0" block_id="{parent_id}"/><div class="vd-new-child-block" onClick="{addBlock}" if="{block_config && !drag}"><i class="fal fa-plus-square"></i> {newChildBlockTitle}</div>
<script>
    this.top = this.parent ? this.parent.top : this
    this.level = _.isUndefined(this.parent.level)? 0 : this.parent.level + 1
    this.parent_id = this.opts.block? this.opts.block.id : ''
    this.drag = null
    this.sortable = null
    this.placeholder = false
    this.placeholder_type ='row'
    this.mixin({store:d_visual_designer})

    addBlock(e) {
        if(!this.block_config.setting.child) {
            this.store.dispatch('popup/addBlock', {parent_id: this.parent_id, designer_id: this.top.opts.id, level: this.level});
        } else {
            this.store.dispatch('block/new', {type: this.block_config.setting.child, designer_id:this.top.opts.id, target: this.parent_id, level: this.level})
        }
    }.bind(this)

    this.store.subscribe('sortable/end', function(data){
        this.placeholder = false;
        this.update()
    }.bind(this))

    this.store.subscribe('block/placeholder/show', function(data) {
        var designer_id = this.top.opts.id
        var block_id = this.parent_id
        if(data.designer_id == designer_id) {
            if(data.block_id == block_id){
                this.placeholder = true;
                this.update()

            }
        }
    }.bind(this))

    this.store.subscribe('block/placeholder/hide', function(data) {
        var designer_id = this.top.opts.id
        var block_id = this.parent_id
        if(data.designer_id == designer_id) {
            if(data.block_id == block_id){
                this.placeholder = false;
                this.update()
            }
        }
    }.bind(this))

    this.initSortable = function (){
        var parent_root = this.opts.selector ? this.opts.selector : this.parent.root
        var that = this;
        this.store.dispatch('sortable/init', {designer_id: this.top.opts.id, block_id: this.parent_id})
    }

    this.initBlocks = function () {
        this.blocks = this.store.getBlocks(this.top.opts.id, this.parent_id)

        if(this.parent_id != '') {
            var block_info = this.store.getState().blocks[this.top.opts.id][this.parent_id]
            this.block_config = _.find(this.store.getState().config.blocks, function(block){
                return block.type == block_info.type
            }.bind(this))
        }

        this.blocks = _.mapObject(this.blocks, function(value, key){
            var block_info = _.find(this.store.getState().config.blocks, function(block){
                return block.type == value.type
            })
            if(!_.isUndefined(value.setting.global.size) && block_info.setting.child_blocks){
                this.placeholder_type = 'column'
            }
            if(block_info.setting.custom_layout) {
                value.layout = block_info.setting.custom_layout
            } else if(block_info.setting.child_blocks && block_info.type == 'row') {
                value.layout = 'main'
            } else if(block_info.setting.child_blocks && this.level == 0){
                value.layout = 'main-wrapper'
            } else if(block_info.setting.child_blocks) {
                value.layout = 'medium'
            } else {
                value.layout = 'children'
            }
            return value
        }.bind(this))
    }

    this.initName = function(){
        if(this.parent_id != '') {

            if(this.block_config.setting.child) {
                var child_block_config = _.find(this.store.getState().config.blocks, function(block){
                    return block.type == this.block_config.setting.child
                }.bind(this))
                this.newChildBlockTitle = this.store.getLocal('designer.text_add') + ' ' + child_block_config.title
            } else {
                this.newChildBlockTitle = this.store.getLocal('designer.text_add_child_block')
            }
        }
    }

    this.initBlocks()
    this.initSortable()
    this.initName()

    this.on('update', function(){
        this.parent_id = this.opts.block? this.opts.block.id : ''
        this.drag = this.store.getState().drag[this.top.opts.id]
        this.initBlocks()
        this.initSortable()
        this.initName()
    }.bind(this))

</script>
</wrapper-blocks>