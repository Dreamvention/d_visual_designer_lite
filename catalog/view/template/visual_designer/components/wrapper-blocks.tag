<wrapper-blocks>
    <div class="vd-new-child-block" onClick={addBlock} if={_.isEmpty(getState().blocks) && !getState().drag && getState().parent_id != ''}></div>
    <div data-is="placeholder" if={!_.isEmpty(getState().blocks) && getState().drag} show={getState().placeholder} placeholder_type={getState().placeholder_type} sort_order="0" block_id={getState().parent_id}/>
    <virtual each={block in getState().blocks}>
        <div class="{block.container} no-padding" if={!_.isUndefined(block.setting.global.container)}>
            <div data-is="vd-layout-{block.layout}" block={block}></div>
        </div>
        <div data-is="vd-layout-{block.layout}" block={block} if={_.isUndefined(block.setting.global.container)}></div>
        <div data-is="placeholder" placeholder_type={getState().placeholder_type} sort_order={block.sort_order+1} block_id={getState().parent_id} if={getState().drag} show={getState().placeholder}/>
    </virtual>
    <div data-is="placeholder" if={_.isEmpty(getState().blocks) && getState().drag} show={getState().placeholder} placeholder_type={getState().placeholder_type} sort_order="0" block_id={getState().parent_id}/>
<script>
    this.mixin(new vd_component(this, false))
    this.initState({
        level: _.isUndefined(this.parent.getState().level)? 0 : this.parent.getState().level + 1,
        parent_id: !_.isUndefined(this.opts.block)? this.opts.block.id : '',
        blocks: {},
        drag: false,
        drag_sort_order: 0,
        drag_type: -1,
        sortable: null,
        placeholder: false,
        placeholder_type: 'row'
    })
    
    addBlock(e) {
        this.store.dispatch('popup/addBlock', {parent_id: this.getState().parent_id, designer_id: this.getState().top.opts.id, level: this.getState().level});
    }.bind(this)

    this.store.subscribe('block/placeholder/show', function(data) {
        var designer_id = this.getState().top.opts.id
        var block_id = this.getState().parent_id
        if(data.designer_id == designer_id) {
            if(data.block_id == block_id){
                this.setState({placeholder: true})
                this.update()
            }
        }
    }.bind(this))

    this.store.subscribe('sortable/end', function(data){
        if(this.getState().placeholder) {
            this.setState({placeholder: false})
            this.update()
        }
    }.bind(this))

    this.store.subscribe('block/placeholder/hide', function(data) {
        var designer_id = this.getState().top.opts.id
        var block_id = this.getState().parent_id
        if(data.designer_id == designer_id) {
            if(data.block_id == block_id){
                this.setState({placeholder: false})
                this.update()
            }
        }
    }.bind(this))
    
    this.initSortable = function (){
        var parent_root = this.opts.selector ? this.opts.selector : this.parent.root
        var that = this;
        this.store.dispatch('sortable/init', {designer_id: this.getState().top.opts.id, block_id: this.getState().parent_id})
    }

    this.initBlocks = function () {
        var blocks = this.store.getBlocks(this.getState().top.opts.id, this.getState().parent_id)

        var placeholder_type = this.getState().placeholder_type

        blocks = _.mapObject(blocks, function(value, key){
            var block_info = _.find(this.store.getState().config.blocks, function(block){
                return block.type == value.type
            })

            if(!_.isUndefined(value.setting.global.size) && block_info.setting.child_blocks){
                placeholder_type = 'column'
            }

            value.container = 'container-fluid';

            if(!_.isUndefined(value.setting.global.container)){
                if(value.setting.global.container == 'responsive'){
                    value.container = 'container'
                }
            }
            if(block_info.setting.custom_layout) {
                value.layout = block_info.setting.custom_layout
            } else if(block_info.setting.child_blocks && block_info.type == 'row') {
                value.layout = 'main'
            } else if(block_info.setting.child_blocks && this.getState().level == 0){
                value.layout = 'main-wrapper'
            } else if(block_info.setting.child_blocks) {
                value.layout = 'medium'
            } else {
                value.layout = 'children'
            }

            return value
        }.bind(this))

        this.setState({
            blocks: blocks,
            placeholder_type: placeholder_type
        })
    }

    this.initBlocks()

    this.on('mount', function(){
        if(this.store.getState().config.permission[this.getState().top.opts.id]){
            this.initSortable()
        }
    })

    this.on('update', function(){
        this.setState({
            parent_id: this.opts.block? this.opts.block.id : '',
            drag: this.store.getState().drag[this.getState().top.opts.id]
        })
        this.initBlocks()
    }.bind(this))
</script>
</wrapper-blocks>