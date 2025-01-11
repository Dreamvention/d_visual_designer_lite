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
