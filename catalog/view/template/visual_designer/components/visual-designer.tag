<visual-designer>
    <div class="content vd">
        <div class="vd {getState().drag?'dragging': ''}" data-vd_id="{getState().top.opts.id}" id="sortable" data-id=""><virtual data-is="wrapper-blocks" selector={"#"+getState().top.opts.id+" #sortable"}/></div>
        <virtual if={store.getState().config.permission[getState().top.opts.id]}>
            <div class="vd-helper">
                <a id="vd-add-button" class="vd-button vd-add-block vd-btn-add" onClick={addBlock}><i class="far fa-plus"></i></a>
            </div>
            <div class="vd-welcome">
                <div class="vd-welcome-header"><formatted-message path='designer.text_welcome_header'/></div>
                <div class="vd-button-group">
                    <a id="vd-add-button" class="vd-button vd-add-block" title="Add Element" onClick={addBlock}><formatted-message path='designer.text_add_block'/></a>
                    <a id="vd-add-text-block" class="vd-button vd-add-text-block" title="Add text block" onClick={addTextBlock}>
                        <i class="fa fa-pencil-square-o"></i>
                        <formatted-message path='designer.text_add_text_block'/>
                    </a>
                    <a id="vd-add-template" class="vd-button vd-add-template" onClick={addTemplate}><formatted-message path='designer.text_add_template'/></a>
                </div>
                <div class="vc_welcome-visible-ne">
                    <a id="vc_not-empty-add-element" class="vc_add-element-not-empty-button" title="Add Element" data-vc-element="add-element-action" onClick={addBlock}></a>
                </div>
            </div>
        </virtual>
    </div>
    <script>
        this.mixin(new vd_component(this, false))
        this.initState({
            level: -1,
            drag: false,
            sortable: null
        })
        addBlock() {
            this.store.dispatch('popup/addBlock', {level: 0, parent_id: '', designer_id: this.getState().top.opts.id});
        }.bind(this)
        addTextBlock() {
            this.store.dispatch('block/new', {type: 'text', designer_id:this.getState().top.opts.id, target: '', level: 0})
        }.bind(this)
        addTemplate() {
            this.store.dispatch('template/list', {designer_id: this.getState().top.opts.id, empty: true});
        }.bind(this)
        $('body').on('designerSave', function(e, data){
            if(this.getState().top.opts.id == data.designer_id) {
                this.store.dispatch('content/save', {designer_id: data.designer_id});
            }
        }.bind(this));
        $('body').on('designerTemplate', function(e, data){
            if(this.getState().top.opts.id == data.designer_id) {
                this.store.dispatch('template/list', {designer_id: data.designer_id});
            }
        }.bind(this));
        $('body').on('designerSaveTemplate', function(e, data){
            this.store.dispatch('template/save/popup', {designer_id: data.designer_id});
        }.bind(this));
        $('body').on('designerAddBlock',function(e, data){
            if(this.getState().top.opts.id == data.designer_id) {
                this.store.dispatch('popup/addBlock', {level: 0, target: '', designer_id: data.designer_id});
            }
        }.bind(this))
        this.on('mount', function(){
            if(!this.store.getState().config.permission[this.getState().top.opts.id]){
                $('.vd-frontent-text').hide();
            } else {
                this.setState({sortable: new vd_sortable({designer_id: this.getState().top.opts.id})});
            }
            
        })

        this.on('update', function(){
            this.setState({drag: this.store.getState().drag[this.getState().top.opts.id]})
        })
    </script>
</visual-designer>