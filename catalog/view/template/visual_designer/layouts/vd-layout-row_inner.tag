<vd-layout-row_inner class="block-inner block-container {getState().className}" data-id="{opts.block.id}" id="{getState().setting.id? getState().setting.id:null}">
    <div class="block-mouse-toggle" if={getState().permission}></div>
    <div class="control control-{getState().block_config.setting.control_position} {getState().downControl?'control-down':null}" if={getState().permission && !getState().drag}>
        <virtual data-is="control-buttons" block={opts.block}/>
    </div>
    <div class="vd-border vd-border-left" if={getState().permission}></div>
    <div class="vd-border vd-border-top" if={getState().permission}></div>
    <div class="vd-border vd-border-right" if={getState().permission}></div>
    <div class="vd-border vd-border-bottom" if={getState().permission}></div>
    <layout-style block={opts.block}/>
    <div class="block-content {getState().contentClassName} {opts.block.id}" data-is="vd-block-{opts.block.type}" block={opts.block} ref="content"></div>
    <script>
        this.mixin(new vd_component(this, false))
        this.initState({
            setting: this.opts.block.setting.global,
            activeControl: false,
            downControl: false,
            permission: false,
            className: '',
            contentClassName: '',
            block_config: _.find(this.store.getState().config.blocks, function(block){
                return block.type == opts.block.type
            }),
            drag: false,
            hoverDrag: false
        })

        this.store.subscribe('block/control/up', function(data){
            if(data.id == this.opts.block.id) {
                this.store.dispatch('block/control/up', {id: parent})
                this.setState({downControl: true})
                this.update()
            }
        }.bind(this))

        this.store.subscribe('block/control/normal', function(data){
            if(data.id == this.opts.block.id) {
                this.store.dispatch('block/control/normal', {id: parent})
                this.setState({downControl: false})
                this.update()
            }
        }.bind(this))

        this.checkPermission = function(){
            var top = this.getState().top
            var block_config = this.getState().block_config
            if(this.store.getState().config.permission[top.opts.id] && block_config.setting.display_control){
                this.setState('permission', true)
            }
        }

        this.store.subscribe('block/control/up', function(data){
            if(data.id == this.opts.block.id) {
                var parent = this.opts.block.parent
                this.store.dispatch('block/control/up', {id: parent})
                this.setState('upControl', true)
                this.update()
            }
        }.bind(this))

        this.store.subscribe('block/control/normal', function(data){
            if(data.id == this.opts.block.id) {
                var parent = this.opts.block.parent
                this.store.dispatch('block/control/normal', {id: parent})
                this.setState('upControl', false)
                this.update()
            }
        }.bind(this))

        this.initClassNames = function(){
            var className = []
            var contentClassName = []

            var setting = this.getState().setting
            var block_config = this.getState().block_config


            if(setting.background_video){
                className.push('video')
            }
            if(block_config.setting.child) {
                contentClassName.push('child')
            }
            if(setting.align){
                if(setting.align == 'left'){
                    contentClassName.push('justify-content-start')
                }
                if(setting.align == 'center'){
                    contentClassName.push('justify-content-center')
                }
                if(setting.align == 'right'){
                    contentClassName.push('justify-content-end')
                }
            }
            if(setting.align_items){
                contentClassName.push('align-items-'+setting.align_items)
            }
            if(setting.design_show_on){
                className.push(_.map(setting.design_show_on, function(value){ return value }).join(' '))
            }
            if(setting.design_animate){
                className.push('animated '+setting.design_animate)
            }
            if(setting.additional_css_class){
                className.push(setting.additional_css_class)
            }
            this.setState({
                className: className.join(' '),
                contentClassName: contentClassName.join(' ')
            })
        }

        this.checkPermission()
        this.initClassNames()


        this.on('update', function(){
            this.setState({
                block_config: _.find(this.store.getState().config.blocks, function(block){
                    return block.type == opts.block.type
                }),
                setting: this.opts.block.setting.global,
                drag: this.store.getState().drag[this.getState().top.opts.id]
            })
            this.checkPermission()
            this.initClassNames()
        })
    </script>
</vd-layout-row_inner>