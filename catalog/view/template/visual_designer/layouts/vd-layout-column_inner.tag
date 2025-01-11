<vd-layout-column_inner class="block-inner block-container {getState().className}" data-id="{opts.block.id}" id="{getState().setting.id? getState().setting.id:null}">
    <div class="block-mouse-toggle" if={getState().permission}></div>
    <div class="control control-{getState().block_config.setting.control_position} {getState().downControl? 'control-down': ''}" if={getState().permission && ! getState().drag}>
        <virtual data-is="control-buttons" block={opts.block}/>
    </div>
    <div class="vd-border vd-border-left" if={getState().permission}></div>
    <div class="vd-border vd-border-top" if={getState().permission}></div>
    <div class="vd-border vd-border-right" if={getState().permission}></div>
    <div class="vd-border vd-border-bottom" if={getState().permission}></div>
    <layout-style block={opts.block}/>
    <div class="block-content {getState().contentClassName} {opts.block.id}" data-is="vd-block-{opts.block.type}" block={opts.block}></div>
    <script>
        this.mixin(new vd_component(this, false))
        this.initState({
            setting: this.opts.block.setting.global,
            activeControl: false,
            downControl: false,
            permission: false,
            className: '',
            block_config: _.find(this.store.getState().config.blocks, function(block){
                return block.type == opts.block.type
            }),
            drag: false,
            hoverDrag: false
        })

        this.store.subscribe('block/control/up', function(data){
            if(data.id == this.opts.block.id) {
                var parent = this.opts.block.parent
                this.store.dispatch('block/control/up', {id: parent})
                this.setState('downControl', true)
                this.update()
            }
        }.bind(this))

        this.store.subscribe('block/control/normal', function(data){
            if(data.id == this.opts.block.id) {
                var parent = this.opts.block.parent
                this.store.dispatch('block/control/normal', {id: parent})
                this.setState('downControl', false)
                this.update()
            }
        }.bind(this))

        this.initClassNames = function(){
            var className = []
            var contentClassName = []
            var setting = this.getState().setting

            if(this.getState().block_config.setting.child) {
                contentClassName.push('child')
            }
            if(this.getState().block_config.setting.child_blocks) {
                contentClassName.push('child-blocks')
            }

            if(setting.offset){
                className.push('offset-lg-'+setting.offset)
            }
            if(setting.offset_phone){
                className.push('offset-'+setting.offset_phone)
            }
            if(setting.offset_tablet){
                className.push('offset-md-'+setting.offset_tablet)
            } else if (setting.offset){
                className.push('offset-md-'+setting.offset)
            }

           if(setting.order){
                className.push('order-lg-'+setting.order)
            }
            if(setting.order_phone){
                className.push('order-'+setting.order_phone)
            }
            if(setting.order_tablet){
                className.push('order-md-'+setting.order_tablet)
            } else if (setting.order){
                className.push('order-md-'+setting.order)
            }

            if(!_.isUndefined(setting.size)){
                if(setting.size == 'fill') {
                    className.push('col-lg')
                } else {
                    className.push('col-lg-'+setting.size)
                }
            }
            if(setting.size_phone){
                if(setting.size_phone == 'fill') {
                    className.push('col')
                } else {
                    className.push('col-'+setting.size_phone)
                }
            }
            if(setting.size_tablet){
                if(setting.size_tablet == 'fill') {
                    className.push('col-md')
                } else {
                    className.push('col-md-'+setting.size_tablet)
                }
            } else if(setting.size){
                if(setting.size == 'fill') {
                    className.push('col-md')
                } else {
                    className.push('col-md-'+setting.size)
                }
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

        this.checkPermission = function(){
            var top = this.getState().top
            var block_config = this.getState().block_config
            if(this.store.getState().config.permission[top.opts.id] && block_config.setting.display_control){
                this.setState('permission', true)
            }
        }
        this.initClassNames()
        this.checkPermission()

        this.on('update', function(){
            this.setState({
                block_config: _.find(this.store.getState().config.blocks, function(block){
                    return block.type == opts.block.type
                }),
                setting: this.opts.block.setting.global,
                drag: this.store.getState().drag[this.getState().top.opts.id]
            })
            this.initClassNames()
            this.checkPermission()
            
        })
    </script>
</vd-layout-column_inner>