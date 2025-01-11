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
<image-manager>
    <script>
        this.mixin({
            store: d_visual_designer
        })
        window.addSingleImage = function(imageName, field, thumb) {
            $.ajax({
                url: that.store.getState().config.new_image_url+'&image=' + encodeURIComponent(imageName),
                dataType: 'text',
                context: this,
                success: function(imageCacheName) {
                    $('#' + thumb).find('img').attr('src', imageCacheName);
                    $('#' + field).val(imageName);
                    var event = new Event('change');[]
                     $('#' + field)[0].dispatchEvent(event);
                }
            });
        };

        window.selectImage = function(){
            that.store.dispatch('popup/image-manager/hide', {designer_id: that.opts.designer_id})
        }

        var that =this
        $(document).off('click', 'a[data-toggle=\'vd-image\']');
        $(document).on('click', 'a[data-toggle=\'vd-image\']', function (e) {
            e.preventDefault();

            $('.popover').popover('hide', function () {
                $('.popover').remove();
            });

            var element = this;

            $(element).popover({
                html: true,
                placement: 'right',
                trigger: 'manual',
				sanitize: false,
                content: function () {
                    return '<button type="button" id="vd-button-image" class="btn btn-primary"><i class="fas fa-pencil"></i></button><button type="button" id="vd-button-clear" class="btn btn-danger"><i class="far fa-trash-alt"></i></button>';
                }
            });

            $(element).popover('show');

            $('#vd-button-image').on('click', function () {
                that.store.dispatch('popup/image-manager/show', {designer_id: that.opts.designer_id, input_id: $(element)
                        .parent().find('input').attr('id'), element_id:$(element).attr('id') })

                $(element).popover('hide', function () {
                    $('.popover').remove();
                });
            });

            $('#vd-button-clear').on('click', function () {
                $(this).closest('.fg-setting').find('img').attr('src', $(this).closest('.fg-setting').find(
                    'img').attr('data-placeholder'));

                $(this).closest('.fg-setting').find('input').attr('value', '');

                $(this).popover('hide', function () {
                    $('.popover').remove();
                });
                var event = new Event('change');
                $(this).closest('.fg-setting').find('input')[0].dispatchEvent(event);

            });

        });
    </script>
</image-manager>

<placeholder class="element-placeholder type-{opts.placeholder_type}">
    <script>
        this.top = this.parent ? this.parent.top : this
        this.mixin({store:d_visual_designer})
        this.on('mount', function(){
            $(this.root).on('mouseup', function(){
                this.store.dispatch('sortable/end', {designer_id: this.top.opts.id, block_id: this.opts.block_id, sort_order: this.opts.sort_order})
            }.bind(this))
        })
    </script>
</placeholder>
<raw>
<div></div>
<script>
    this.mixin({store:d_visual_designer})
    this.set = function(){
        this.root.childNodes[0].innerHTML = opts.html;
    }
    this.on('update', this.set)
    this.on('mount', this.set)
</script>
</raw>
<vd-navbar-container>
    <div class="vd-navbar-container">
        <span class="notify"></span>
        <div class="vd-navbar left-bar">
            <a id="button-add" class="vd-btn vd-btn-add-block" data-toggle="tooltip" data-placement="bottom" title="{store.getLocal('designer.button_add_block')}" onclick={addBlock}></a>
            <a id="button-add-template" class="vd-btn vd-btn-add-template" data-toggle="tooltip" data-placement="bottom" title="{store.getLocal('designer.button_add_template')}" onclick={addTemplate}></a>
            <a id="button-save-template" class=" vd-btn vd-btn-save-template" data-toggle="tooltip" data-placement="bottom" title="{store.getLocal('designer.button_save_template')}" onclick={saveTemplate}></a>
            <a id="desctop-size" class="vd-btn vd-btn-desktop" data-mode="desktop" data-toggle="tooltip" data-placement="bottom" title="{store.getLocal('designer.button_desktop')}" onclick={desktopClick}></a>
            <a id="tablet-size" class="vd-btn vd-btn-tablet" data-mode="tablet" data-toggle="tooltip" data-placement="bottom" title="{store.getLocal('designer.button_tablet')}" onclick={tabletClick}></a>
            <a id="mobile-size" class="vd-btn vd-btn-mobile" data-mode="mobile" data-toggle="tooltip" data-placement="bottom" title="{store.getLocal('designer.button_mobile')}" onclick={mobileClick}></a>
        </div>
        <div class="vd-navbar right-bar">
            <div class="vd-switcher" if={!_.isEmpty(designers) && _.size(designers) > 1}>{designers[active].title} #{designers[active].id}
                <div class="vd-switcher-content" style="left: {left}px;">
                    <div class="vd-switcher-element {active == designer_id?'active' : ''}" each={designer, designer_id in designers} onClick={designerChange}>{designer.title} #{designer.id}</div>
                </div>
            </div>
            <a id="button-backend" href="{store.getState().config.backend_url}">{store.getLocal('designer.button_backend_editor')}</a>
            <a id="button-save" data-bs-loading-text="Loading..." onclick={saveContent}>{store.getLocal('designer.button_publish')}</a>
            <a id="button-close" href={store.getState().config.frontend_url}>{store.getLocal('designer.button_cancel')}</a>
        </div>
    </div>
    <virtual each={designer, designer_id in designers}>
        <visual-designer-frontend id="{designer_id}" class="{designer_id}"></visual-designer-frontend>
    </virtual>
    <iframe src="{store.getState().config.frontend_url}&edit" onload="{iframeLoad}" frameborder="0" border="0" style="height: {iframeHeight}px;"/>
    <div if={loadingIframe}>
        <div id="visual-designer-preloader"></div>
        <div id="visual-designer-preloader-icon" class="la-ball-scale-ripple-multiple la-2x"><div></div><div></div><div></div></div>
    </div>
    <script>
        this.mixin({store:d_visual_designer})
        this.active = ''
        this.loadingIframe = true
        this.iframeWidth = $(window).width()
        this.iframeHeight = ''
        this.notify = ''


        iframeLoad(e) {
            this.iframeWindow = $('iframe', this.root)[0].contentWindow
            this.resize_iframe()
            if(!_.isUndefined(this.iframeWindow.d_visual_designer)) {
                that = this;
                external_state_init = () => {
                    if (!_.isUndefined($('iframe')[0].contentWindow.d_visual_designer.state)) {
                        that.store.dispatch('designer/external/init', {external_vd: $('iframe')[0].contentWindow.d_visual_designer});
                    } else {
                        setTimeout(external_state_init, 250);
                    }
                };
                external_state_init();
            }
            this.loadingIframe = false;
        }.bind(this)
        designerChange(e) {
            this.active = e.item.designer_id
        }.bind(this)

        desktopClick(e) {
            $('iframe', this.root).animate({width: $(window).width()})
        }.bind(this)

        tabletClick(e) {
            $('iframe', this.root).animate({width: '770px'})
        }.bind(this)

        mobileClick(e) {
            $('iframe', this.root).animate({width: '320px'})
        }.bind(this)

        saveContent(e) {
            this.iframeWindow.$('body').trigger('designerSave', {designer_id: this.active});
            $(e.currentTarget).button('loading');
        }.bind(this)


        this.store.subscribe('save_content_success', function() {
            $('#button-save', this.root).button('reset');
        })
        this.store.subscribe('save_content_permission', function() {
            $('#button-save', this.root).button('reset');
        })

        addBlock(e) {
            this.store.dispatch('popup/addBlock', {designer_id: this.active, level: 0, parent_id: ''})
        }
        addTemplate() {
            this.store.dispatch('template/list', {designer_id: this.active});
        }
        saveTemplate() {
            this.store.dispatch('template/save/popup', {designer_id: this.active});
        }
        this.initDesigners = function() {
            this.designers = {}
            var external_state = this.store.getStateExternal()
            if(external_state) {
                for (var designer_id in external_state.blocks) {
                    if(external_state.config.permission[designer_id]) {
                        this.designers[designer_id] = {
                            title: external_state.config.route[designer_id],
                            id: external_state.config.id[designer_id],
                            designer_id: designer_id
                        }
                    }
                }
                if(this.active == '') {
                    this.active = _.first(_.keys(this.designers))
                }
            }
        }

        this.resize_iframe = function(){
            var $w_height = $( window ).height(),
            $b_height = $( '.vd-navbar-container' ).height(),
            $i_height = $w_height - $b_height;
            this.iframeHeight = $i_height
            this.update()
        }.bind(this)

        this.initDesigners()

        $(window).on('resize', function(){
            this.resize_iframe();
        }.bind(this));

        this.on('mount', function(){
            $('[data-toggle="tooltip"]', this.root).tooltip();
            this.resize_iframe();
        })

        this.on('update', function(){
            this.initDesigners()
        })

        this.on('updated', function () {
            var oldLeft = this.left

            width_popup = $('.vd-switcher', this.root).length ? $('.vd-switcher', this.root).outerWidth() : 0;
            width_popup_content = $('.vd-switcher-content', this.root).length ? $('.vd-switcher-content', this.root).outerWidth() : 0;

            this.left = Math.floor((width_popup - width_popup_content) / 2)
            if (this.left != oldLeft) {
                this.update()
            }
        })
    </script>
</vd-navbar-container>

<visual-designer-frontend>
    <vd-popup-new-block/>
    <vd-popup-setting-block/>
    <vd-popup-layout-block/>
    <vd-popup-save-template/>
    <vd-popup-load-template/>
    <vd-popup-image-manager/>
    <script>
        this.mixin({store:d_visual_designer})
        
        this.top = this
    </script>
</visual-designer-frontend>
<visual-designer>
    <div class="vd mode_switch" if={!store.getState().config.independent[opts.id]}>
        <a id="button_classic" class="btn btn-secondary" hide={store.getState().config.mode[opts.id] == 'classic'} onClick={modeClassic}><formatted-message path='designer.text_classic_mode'/></a>
        <a id="button_vd" class="btn btn-secondary" hide={!store.getState().config.mode[opts.id] || store.getState().config.mode[opts.id] == 'designer'} onClick={modeDesigner}><formatted-message path='designer.text_backend_editor'/></a>
    </div>
    <div class="content vd" hide={store.getState().config.mode[opts.id] == 'classic'}>
        <div class="row" style="justify-content: space-between" id="d_visual_designer_nav">
            <div style="width: auto" class="float-start">
                <a class="btn btn-add btn-default" onClick={addBlock}></a>
                <a class="btn btn-template btn-default" onClick={addTemplate}></a>
                <a class="btn btn-save-template btn-default" onClick={saveTemplate}></a>
            </div>
            <div style="width: auto" class="float-end">
                <a class="btn btn-default vd-btn-text"
                    onClick={frontend}
                    if={store.getState().config.route_info.frontend_status && store.getState().config.id}
                >
                    <formatted-message path='designer.text_frontend_editor'/>
                </a>
                <a class="btn btn-code-view btn-default" onClick={codeView}></a>
                <a class="btn btn-full-screen btn-default" onclick={fullscreen}></a>
            </div>
        </div>
        <div class="vd-designer" id="sortable"><virtual data-is="wrapper-blocks" selector={"#"+top.opts.id+" #sortable"}/></div>
        <div class="vd-welcome" if={emptyDesigner}>
            <div class="vd-welcome-header"><formatted-message path='designer.text_welcome_header'/></div>
            <div class="vd-button-group">
                <a class="vd-button vd-add-block" title="Add Element" onClick={addBlock}><formatted-message path='designer.text_add_block'/></a>
                <a class="vd-button vd-add-text-block" title="Add text block" onClick={addTextBlock}>
                    <i class="fal fa-pen-square"></i>
                    <formatted-message path='designer.text_add_text_block'/>
                </a>
                <a id="vd-add-template" class="vd-button vd-add-template" onClick={addTemplate}><formatted-message path='designer.text_add_template'/></a>
            </div>
            <div class="vc_welcome-visible-ne">
                <a id="vc_not-empty-add-element" class="vc_add-element-not-empty-button" title="Add Element" data-vc-element="add-element-action" onClick={addBlock}></a>
            </div>
        </div>
    </div>
    <vd-popup-new-block/>
    <vd-popup-setting-block/>
    <vd-popup-layout-block/>
    <vd-popup-save-template/>
    <vd-popup-load-template/>
    <vd-popup-image-manager/>
    <vd-popup-codeview/>
    <textarea style="display:none;" name="{fieldName}">{content}</textarea>
    <script>
        this.mixin({store:d_visual_designer})
        this.top = this.parent ? this.parent.top : this
        this.emptyDesigner = _.isEmpty(this.store.getState().blocks[this.top.opts.id])
        this.loading = true
        this.initName = function(){
            if(!this.store.getState().config.independent[this.top.opts.id]) {
                this.fieldName = $(this.root).closest('.row.mb-3').find('.d_visual_designer').attr('name')
            } else {
                this.fieldName = $(this.root).closest('.row.mb-3').find('.d_visual_designer_backend').data('name')
            }

            this.fieldName = 'vd_content[' + escape(this.fieldName) + ']'
        }
        this.initName()
        addBlock() {
            this.store.dispatch('popup/addBlock', {level: 0, parent_id: '', designer_id: this.top.opts.id});
        }
        addTemplate() {
            this.store.dispatch('template/list', {designer_id: this.top.opts.id});
        }
        saveTemplate() {
            this.store.dispatch('template/save/popup', {designer_id: this.top.opts.id});
        }
        codeView() {
            this.store.dispatch('content/codeview', {designer_id: this.top.opts.id});
        }
        addTextBlock() {
            this.store.dispatch('block/new', {type: 'text', designer_id:this.top.opts.id, target: '', level: 0})
        }
        this.store.subscribe('block/setting/update/end', function(data){
            if(this.top.opts.id == data.designer_id) {
                this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
                $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
            }
        }.bind(this))
        this.store.subscribe('template/load/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('block/clone/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('block/move/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('block/remove/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('designer/update/blocks/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('block/create/success', function(data){
            if(this.top.opts.id == data.designer_id) {
                this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
                $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
            }
        }.bind(this))
        this.store.subscribe('block/layout/update/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
           $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        fullscreen() {
            if ($('.vd.content', this.root).hasClass('fullscreen')) {
                $('.vd.content', this.root).removeClass('fullscreen');
                $(this.root).find('#d_visual_designer_nav').find('.btn-full-screen').removeClass('active');
                $('body').removeAttr('style');
            } else {
                $('.vd.content', this.root).addClass('fullscreen');
                $(this.root).find('#d_visual_designer_nav').find('.btn-full-screen').addClass('active');
                $('body').attr('style', 'overflow:hidden');
            }
        }
        modeClassic(){
            this.store.dispatch('designer/update/content', {designer_id: this.top.opts.id})
            this.store.dispatch('content/mode/update', {designer_id: this.top.opts.id, mode: 'classic'});
        }
        modeDesigner(){
            this.store.dispatch('content/mode/update', {designer_id: this.top.opts.id, mode: 'designer'});
        }

        frontend() {

            if(!this.store.getState().config.independent[this.top.opts.id]) {
                var fieldName = $(this.root).closest('.row.mb-3').find('.d_visual_designer').attr('name')
            } else {
                var fieldName = $(this.root).closest('.row.mb-3').find('.d_visual_designer_backend').data('name')
            }

            this.store.dispatch('designer/frontend', {designer_id: this.top.opts.id, fieldName: fieldName, form: $(this.root).closest('form')})
        }
        this.on('update', function(){
            this.emptyDesigner = _.isEmpty(this.store.getState().blocks[this.top.opts.id])
        })

        this.initMode = function(){
            var mode = this.store.getState().config.mode[this.opts.id]
            if(mode == 'designer') {
                $(this.root).closest('.row.mb-3').find('.note-editor').hide()
                $(this.root).closest('.row.mb-3').find('.cke').hide()
            }
            if(mode == 'classic') {
                $(this.root).closest('.row.mb-3').find('.note-editor').show()
                $(this.root).closest('.row.mb-3').find('.cke').show()
            }
        }

        this.store.subscribe('content/update/text', function(data) {
            var element =  $(this.root).closest('.row.mb-3').find('.d_visual_designer')

            $(element).get(0).innerText = data.text;

            if ($(element).hasClass('summernote')) {
                $(element).summernote('code', data.text)
            }
        }.bind(this))

        this.store.subscribe('content/mode/update/success', function(){
            this.initMode();
        }.bind(this))

        this.on('mount', function(){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            new vd_sortable({designer_id: this.top.opts.id})
        })

        $('body').on('designerSave', function(){
            this.store.dispatch('content/save', {designer_id: this.top.opts.id});
        }.bind(this));
    </script>
</visual-designer>

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
