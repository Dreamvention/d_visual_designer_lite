<vd-layout-children class="block-child block-container {getState().className}" data-id="{opts.block.id}" id="{getState().setting.id? getState().setting.id:null}">
    <div class="control control-{getState().block_config.setting.control_position}" if="{getState().permission && !getState().drag}" style="{getState().controlStyle}">
        <virtual data-is="control-buttons" block={opts.block}/>
    </div>
    <layout-style block={opts.block}/>
    <div class="block-content {getState().block_config.setting.child? 'child' : ''} {getState().contentClassName} {opts.block.id}" data-is="vd-block-{opts.block.type}" block={opts.block}></div>
    <script>
        this.mixin(new vd_component(this, false))
        this.initState({
            setting: this.opts.block.setting.global,
            controlStyle: '',
            permission: false,
            className: '',
            contentClassName: '',
            block_config: _.find(this.store.getState().config.blocks, function(block){
                return block.type == opts.block.type
            }),
            drag: false
        })

        this.checkControl = function () {
            var parent = this.opts.block.parent
            if($(this.root).height() < 100) {
                this.store.dispatch('block/control/up', {id: parent})
            } else {
                this.store.dispatch('block/control/normal', {id: parent})
            }
        }

        $(this.root).on('mouseenter', function () {
            if(!this.getState().drag){
                this.checkControl()
            }
        }.bind(this))

        this.initClassNames = function(){
            var className = []
            var contentClassName = []
            var setting = this.getState().setting
            
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
        this.on('mount', function(){
            var margin_left = (-1)*($(this.root).children('.control').width()/2);
            var margin_top = (-1)*($(this.root).children('.control').height()/2);
            this.setState({
                controlStyle: 'margin:'+margin_top+'px 0 0 '+margin_left+'px;'
            })
        })
        this.on('update', function(){
            var margin_left = (-1)*($(this.root).children('.control').width()/2);
            var margin_top = (-1)*($(this.root).children('.control').height()/2)
            this.setState({
                block_config: _.find(this.store.getState().config.blocks, function(block){
                    return block.type == opts.block.type
                }),
                setting: this.opts.block.setting.global,
                drag: this.store.getState().drag[this.getState().top.opts.id],
                controlStyle: 'margin:'+margin_top+'px 0 0 '+margin_left+'px;'
            })
            this.initClassNames()
            this.checkPermission()
        })
    </script>
</vd-layout-children>
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
<vd-layout-main-wrapper class="block-parent-wrapper block-container {getState().className}" data-id="{opts.block.id}" id="{getState().setting.id? getState().setting.id:null}">
    <div class="block-mouse-toggle" if={getState().permission}></div>
    <div class="control control-{getState().block_config.setting.control_position} {getState().upControl?'control-up':null}"  if={getState().permission && !getState().drag}>
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
            upControl: false,
            permission: false,
            className: '',
            contentClassName: '',
            block_config: _.find(this.store.getState().config.blocks, function(block){
                return block.type == opts.block.type
            }),
            drag: false
        })

        this.store.subscribe('block/control/up', function(data){
            if(data.id == this.opts.block.id) {
                this.setState('upControl', true)
                this.update()
            }
        }.bind(this))

        this.store.subscribe('block/control/normal', function(data){
            if(data.id == this.opts.block.id) {
                this.setState('upControl', false)
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

        this.initClassNames = function(){
            var className = []
            var contentClassName = []

            var setting = this.getState().setting

            if(this.getState().setting.background_video){
                className.push('video')
            }
            if(this.getState().block_config.setting.child) {
                contentClassName.push('child')
            }
            if(this.getState().block_config.setting.child_blocks) {
                contentClassName.push('child-blocks')
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
</vd-layout-main-wrapper>
<vd-layout-main class="block-parent block-container {getState().className}" data-id="{opts.block.id}" id="{getState().setting.id? getState().setting.id:null}">
    <div class="block-mouse-toggle" if={getState().permission}></div>
    <div class="control control-{getState().block_config.setting.control_position} {getState().upControl?'control-up':null}"  if={getState().permission && !getState().drag}>
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
            upControl: false,
            permission: false,
            className: '',
            contentClassName: '',
            block_config: _.find(this.store.getState().config.blocks, function(block){
                return block.type == opts.block.type
            }),
            drag: false
        })

        this.store.subscribe('block/control/up', function(data){
            if(data.id == this.opts.block.id) {
                this.setState('upControl', true)
                this.update()
            }
        }.bind(this))

        this.store.subscribe('block/control/normal', function(data){
            if(data.id == this.opts.block.id) {
                this.setState('upControl', false)
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

        this.initClassNames = function(){
            var className = []
            var contentClassName = []

            var setting = this.getState().setting

            if(this.getState().setting.background_video){
                className.push('video')
            }
            if(this.getState().block_config.setting.child) {
                contentClassName.push('child')
            }
            if(this.getState().block_config.setting.child_blocks) {
                contentClassName.push('child-blocks')
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
</vd-layout-main>
<vd-layout-medium class="block-inner block-container {getState().className}" data-id="{opts.block.id}" id={getState().setting.id? getState().setting.id:null}>
    <div class="block-mouse-toggle" if={getState().permission}></div>
    <div class="control control-{getState().block_config.setting.control_position} {getState().upControl? 'control-up': ''}" if={getState().permission && !getState().drag}>
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
            upControl: false,
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
</vd-layout-medium>
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
