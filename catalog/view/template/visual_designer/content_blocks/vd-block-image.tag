<vd-block-image>
    <div class="vd-image-container vd-image-align-{getState().setting.global.align} {getState().classContainer}">
        <div class="vd-image-title" if={getState().setting.global.title}>
            <h2>{getState().setting.global.title}</h2>
        </div>
        <div class="vd-image-wrapper vd-image-size-{getState().setting.global.size} {getState().classWrapper}">
            <div class="vd-image {getState().setting.global.style ? 'vd-image-style-' + getState().setting.global.style : ''}">
                <a>
                    <virtual if={getState().setting.global.parallax == '1'}>
                        <div class="parallax-window" style="{getState().parallaxStyles}"></div>
                    </virtual>
                    <virtual if={getState().setting.global.parallax == '0'}>
                        <img src="{getState().setting.user.thumb}" alt="{getState().setting.global.image_alt}" title="{getState().setting.global.image_title}"/>
                    </virtual>
                </a>
            </div>
        </div>
    </div>
    <script>
        this.mixin(new vd_block(this))
        this.initState({
            parallaxStyles: '',
            classContainer: '',
            classWrapper: '',
        })
        this.initImage = function (){
            var parallaxStyles = []
            var setting = this.getState().setting
            if(setting.global.parallax == '1'){
                parallaxStyles.push('background-image: url(\''+setting.user.thumb+'\');');
                parallaxStyles.push('height:'+setting.global.parallax_height+';');
                if(setting.global.size != 'responsive') {
                    $('.parallax-window', this.root).css({
                        'width': setting.user.desktop_size.width,
                        'height': setting.user.desktop_size.height,
                    })
                }
            }
            this.setState({parallaxStyles: parallaxStyles.join(' ')})
            if(setting.global.onclick == 'popup'){
                $('.vd-image', this.root).magnificPopup({
                    type:'image',
                    delegate: 'a',
                    gallery: {
                        enabled:true
                    }
                });
                $('.vd-image > a', this.root).attr('class', 'image-popup')
                $('.vd-image > a', this.root).attr('href', setting.user.popup)
            }
            if(setting.global.onclick == 'link'){
                if(setting.global.link_target == 'new'){
                    $('.vd-image > a', this.root).attr('target', '_blank')
                }
                $('.vd-image > a', this.root).attr('href', setting.global.link)
            }
            $('.vd-image img', this.root).css({width: '', height: ''})
            var styles = {
                'phone': {
                    '.vd-image-size-phone-custom img': {
                        'width': setting.global.width_phone,
                        'height': setting.global.height_phone,
                    }
                },
                'tablet': {
                    '.vd-image-size-tablet-custom img': {
                        'width': setting.global.width_tablet,
                        'height': setting.global.height_tablet,
                    }
                },
                'desktop': {
                    '.vd-image-size-custom img': {
                        'width': setting.global.width,
                        'height': setting.global.height,
                    }
                },
            }
            this.store.dispatch('block/style/media/update', {designer_id: this.getState().top.opts.id, block_id: this.opts.block.id, styles: styles})
        }
        this.initClassContainer = function(){
            var classContainer = []
            var setting = this.getState().setting

            if(setting.global.align_phone){
                classContainer.push('vd-image-align-phone-' + setting.global.align_phone)
            }
            if(setting.global.align_tablet){
                classContainer.push('vd-image-align-tablet-' + setting.global.align_tablet)
            }
            this.setState({classContainer: classContainer.join(' ')})
        }.bind(this)
        this.initClassWrapper = function(){
            var classWrapper = []
            var setting = this.getState().setting

            if(setting.global.size_phone){
                classWrapper.push('vd-image-size-phone-'+setting.global.size_phone)
            } else if(setting.global.size_tablet) {
                classWrapper.push('vd-image-size-phone-'+setting.global.size_tablet)
            } else {
                classWrapper.push('vd-image-size-phone-'+setting.global.size)
            }
            if(setting.global.size_tablet){
                classWrapper.push('vd-image-size-tablet-'+setting.global.size_tablet)
            } else {
                classWrapper.push('vd-image-size-tablet-'+setting.global.size)
            }
            this.setState({classWrapper: classWrapper.join(' ')})
        }.bind(this)

        this.initClassContainer()
        this.initClassWrapper()
        this.on('mount', function(){
            this.initImage()
        })

        this.on('update', function(){
            this.initClassContainer()
            this.initClassWrapper()
            this.initImage()
        })

        $(window).on('resize', function(){
            this.initImage()
            this.update()
        }.bind(this))
    </script>
</vd-block-image>