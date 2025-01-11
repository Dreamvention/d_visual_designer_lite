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
<formatted-message>
<div></div>
<script>
    this.mixin({store:d_visual_designer})
    this.set = function(){
        this.root.childNodes[0].innerHTML = this.store.getLocal(opts.path);
    }

    this.on('update', this.set)
    this.on('mount', this.set)
</script>
</formatted-message>
<layout-style>
    <script>
        this.mixin(new vd_component(this))
        this.initState({
            block_parent: {},
        })
        this.initParentSetting = function(){
            var top = this.getState().top
            if(this.opts.block.parent != ''){
                this.setState('block_parent', this.store.getState().blocks[top.opts.id][this.opts.block.parent])
            }
        }
        this.initStyle = function(){
            var element = this.parent.root
            var setting = this.opts.block.setting.global
            var block_parent = this.getState().block_parent


            if(this.opts.block.parent !== '' && !_.isUndefined(block_parent.setting.global.float) && block_parent.setting.global.float){
                $(element).css({'float': 'left', 'width': 'auto'});
                if(block_parent.setting.global.align) {
                    if(block_parent.setting.global.align == 'left') {
                        $(element).css({'float': 'left'})
                    }
                    if(block_parent.setting.global.align == 'right') {
                        $(element).css({'float': 'right'})
                    }
                }
            } else {
                $(element).css({'float': '', 'width': ''});
            }

            if(setting.align && setting.float) {
                if(setting.align == 'center') {
                    $(element).children('.block-content').css({'display': 'flex', 'justify-content': 'center'})
                } else {
                    $(element).children('.block-content').css({'display': '', 'justify-content': ''})
                }
            } else {
                $(element).children('.block-content').css({'display': '', 'justify-content': ''})
            }

            var responsiveMargin = setting.design_margin_responsive

            if(!responsiveMargin && setting.design_margin_top){
                $(element).css({'margin-top': setting.design_margin_top})
            } else {
                $(element).css({'margin-top': ''})
            }
            if(!responsiveMargin && setting.design_margin_left){
                $(element).css({'margin-left': setting.design_margin_left})
            }
            if(!responsiveMargin && setting.design_margin_right){
                $(element).css({'margin-right': setting.design_margin_right})
            } else {
                $(element).css({'margin-right': ''})
            }
            if(!responsiveMargin && setting.design_margin_bottom){
                $(element).css({'margin-bottom': setting.design_margin_bottom})
            } else {
                $(element).css({'margin-bottom': ''})
            }

            var responsivePadding = setting.design_padding_responsive

            if(!responsivePadding && setting.design_padding_top){
                $(element).css({'padding-top': setting.design_padding_top})
            } else {
                $(element).css({'padding-top': ''})
            }
            if(!responsivePadding && setting.design_padding_left){
                $(element).css({'padding-left': setting.design_padding_left})
            } else {
                $(element).css({'padding-left': ''})
            }
            if(!responsivePadding && setting.design_padding_right){
                $(element).css({'padding-right': setting.design_padding_right})
            } else {
                $(element).css({'padding-right': ''})
            }
            if(!responsivePadding && setting.design_padding_bottom){
                $(element).css({'padding-bottom': setting.design_padding_bottom})
            } else {
                $(element).css({'padding-bottom': ''})
            }
            if( setting.design_border_top){
                $(element).css({'border-top': setting.design_border_top+' '+setting.design_border_style+' '+setting.design_border_color})
            } else {
                $(element).css({'border-top': ''})
            }
            if( setting.design_border_left){
                $(element).css({'border-left': setting.design_border_left+' '+setting.design_border_style+' '+setting.design_border_color})
            } else {
                $(element).css({'border-left': ''})
            }
            if( setting.design_border_right){
                $(element).css({'border-right': setting.design_border_right+' '+setting.design_border_style+' '+setting.design_border_color})
            } else {
                $(element).css({'border-right': ''})
            }
            if( setting.design_border_bottom){
                $(element).css({'border-bottom': setting.design_border_bottom+' '+setting.design_border_style+' '+setting.design_border_color})
            } else {
                $(element).css({'border-bottom': ''})
            }
            if( setting.design_border_radius){
                $(element).css({'border-radius': setting.design_border_radius})
            } else {
                $(element).css({'border-radius': ''})
            }
            if( setting.design_background){
                $(element).css({'background-color': setting.design_background})
            } else {
                $(element).css({'background-color': ''})
            }
            if(setting.design_background_image){
                $(element).css({'background-image': 'url('+this.opts.block.setting.user.design_background_image+')'})
                if(setting.design_background_image_position_vertical && setting.design_background_image_position_horizontal){
                    $(element).css({'background-position': setting.design_background_image_position_vertical+' '+setting.design_background_image_position_horizontal})
                }
                if(setting.design_background_image_style == 'cover'){
                     $(element).css({'background-size': 'cover', 'background-repeat': 'no-repeat'})
                }
                if(setting.design_background_image_style == 'contain'){
                     $(element).css({'background-size': 'contain', 'background-repeat': 'no-repeat'})
                }
                if(setting.design_background_image_style == 'repeat'){
                     $(element).css({'background-repeat': 'repeat'})
                }
                if(setting.design_background_image_style == 'no-repeat'){
                     $(element).css({'background-repeat': 'no-repeat'})
                }
                if(setting.design_background_image_style == 'parallax'){
                     $(element).css({
                        'display': 'block',
                        'background-attachment': 'fixed',
                        'background-position': 'center',
                        'background-repeat': 'no-repeat',
                        'background-size': 'cover'
                     })
                }
            } else {
                $(element).css({
                    'display': '',
                    'background-attachment': '',
                    'background-position': '',
                    'background-repeat': '',
                    'background-size': '',
                    'background-image': ''
                })
            }
        }

        this.renderStyle = function() {
            var setting = this.opts.block.setting.global

            $('body').find('style#layout-'+this.opts.block.id).remove();

            var styleTag = '<style id="layout-'+this.opts.block.id+'">';
            var responsiveMargin = setting.design_margin_responsive
            var responsivePadding = setting.design_padding_responsive
            styleTag += '@media only screen and (min-width: 1024px) {';
            styleTag += '.content.vd .block-container[data-id="'+this.opts.block.id+'"] {';
            if(responsiveMargin) {
                if(setting.design_margin_desktop_top){
                    styleTag += 'margin-top:'+setting.design_margin_desktop_top+';';
                }
                if(setting.design_margin_desktop_left){
                    styleTag += 'margin-left:'+setting.design_margin_desktop_left+';';
                }
                if(setting.design_margin_desktop_right){
                    styleTag += 'margin-right:'+setting.design_margin_desktop_right+';';
                }
                if(setting.design_margin_desktop_bottom){
                    styleTag += 'margin-bottom:'+setting.design_margin_desktop_bottom+';';
                }
            }
            if(responsivePadding) {
                if(setting.design_padding_desktop_top){
                    styleTag += 'padding-top:'+setting.design_padding_desktop_top+';';
                }
                if(setting.design_padding_desktop_left){
                    styleTag += 'padding-left:'+setting.design_padding_desktop_left+';';
                }
                if(setting.design_padding_desktop_right){
                    styleTag += 'padding-right:'+setting.design_padding_desktop_right+';';
                }
                if(setting.design_padding_desktop_bottom){
                    styleTag += 'padding-bottom:'+setting.design_padding_desktop_bottom+';';
                }
            }
            styleTag += '}';
            styleTag += '}';
            styleTag += '@media only screen and (min-width: 768px) and (max-width: 1023px) {';
            styleTag += '.content.vd .block-container[data-id="'+this.opts.block.id+'"] {';
            if(responsiveMargin) {
                if(setting.design_margin_tablet_top){
                    styleTag += 'margin-top:'+setting.design_margin_tablet_top+';';
                }
                if(setting.design_margin_tablet_left){
                    styleTag += 'margin-left:'+setting.design_margin_tablet_left+';';
                }
                if(setting.design_margin_tablet_right){
                    styleTag += 'margin-right:'+setting.design_margin_tablet_right+';';
                }
                if(setting.design_margin_tablet_bottom){
                    styleTag += 'margin-bottom:'+setting.design_margin_tablet_bottom+';';
                }
            }
            if(responsivePadding) {
                if(setting.design_padding_tablet_top){
                    styleTag += 'padding-top:'+setting.design_padding_tablet_top+';';
                }
                if(setting.design_padding_tablet_left){
                    styleTag += 'padding-left:'+setting.design_padding_tablet_left+';';
                }
                if(setting.design_padding_tablet_right){
                    styleTag += 'padding-right:'+setting.design_padding_tablet_right+';';
                }
                if(setting.design_padding_tablet_bottom){
                    styleTag += 'padding-bottom:'+setting.design_padding_tablet_bottom+';';
                }
            }
            styleTag += '}';
            styleTag += '}';
            styleTag += '@media only screen and (max-width: 767px) {';
            styleTag += '.content.vd .block-container[data-id="'+this.opts.block.id+'"] {';
            if(responsiveMargin) {
                if(setting.design_margin_phone_top){
                    styleTag += 'margin-top:'+setting.design_margin_phone_top+';';
                }
                if(setting.design_margin_phone_left){
                    styleTag += 'margin-left:'+setting.design_margin_phone_left+';';
                }
                if(setting.design_margin_phone_right){
                    styleTag += 'margin-right:'+setting.design_margin_phone_right+';';
                }
                if(setting.design_margin_phone_bottom){
                    styleTag += 'margin-bottom:'+setting.design_margin_phone_bottom+';';
                }
            }
            if(responsivePadding) {
                if(setting.design_padding_phone_top){
                    styleTag += 'padding-top:'+setting.design_padding_phone_top+';';
                }
                if(setting.design_padding_phone_left){
                    styleTag += 'padding-left:'+setting.design_padding_phone_left+';';
                }
                if(setting.design_padding_phone_right){
                    styleTag += 'padding-right:'+setting.design_padding_phone_right+';';
                }
                if(setting.design_padding_phone_bottom){
                    styleTag += 'padding-bottom:'+setting.design_padding_phone_bottom+';';
                }
            }
            styleTag += '}';
            styleTag += '}';
            styleTag += '.'+this.opts.block.id+':before{'+this.opts.block.setting.global.additional_css_before+'}';
            styleTag += '.'+this.opts.block.id+'{'+this.opts.block.setting.global.additional_css_content+'}';
            styleTag += '.'+this.opts.block.id+':after{'+this.opts.block.setting.global.additional_css_after+'}';
            styleTag += '<style>'
            $('body').append(styleTag);
        }

        this.initParentSetting();
        this.initStyle();
        this.renderStyle()

        this.on('mount', function(){
            this.initParentSetting();
            this.initStyle();
            this.renderStyle()
        })

        this.on('update', function(){
            this.initParentSetting()
            this.initStyle()
            this.renderStyle()
        })
    </script>
</layout-style>
<placeholder class="element-placeholder type-{opts.placeholder_type}">
    <script>
        this.mixin(new vd_component(this, false))
        this.on('mount', function(){
            $(this.root).on('mouseup', function(){
                this.store.dispatch('sortable/end', {designer_id: this.getState().top.opts.id, block_id: this.opts.block_id, sort_order: this.opts.sort_order})
            }.bind(this))
        })
    </script>
</placeholder>
<raw>
    <div></div>
    <script>
        this.mixin({store:d_visual_designer})
        this.set = function(){
            $(this.root).html(opts.html)
        }
        this.on('update', this.set)
        this.on('mount', this.set)
    </script>
</raw>
<vd-content>
    <vd-layout-main each={block in this.blocks}></vd-layout-main>
<script>
    this.top = this.parent ? this.parent.top : this
    this.mixin({store:d_visual_designer})
    this.blocks = this.store.getBlocks(opts.designer_id, '')

    this.on('update', function(){
        this.blocks = this.store.getBlocks(opts.designer_id, '')
    }.bind(this))

</script>
</vd-content>
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
