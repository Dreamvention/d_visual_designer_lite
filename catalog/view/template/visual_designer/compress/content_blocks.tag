<vd-block-column>
    <virtual data-is="wrapper-blocks" block={opts.block}></virtual>
    <script>
        this.mixin(new vd_block(this, false))

    </script>
</vd-block-column>
<vd-block-column_inner>
    <virtual data-is="wrapper-blocks" block={opts.block}></virtual>
    <script>
        this.mixin(new vd_block(this, false))
    </script>
</vd-block-column_inner>
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
<vd-block-row>
    <virtual data-is="wrapper-blocks" block={opts.block}></virtual>

    <div class="video-background" if={getLink() && getState().setting.global.background_video}>
        <iframe src="{getLink()}" frameborder="0" allowfullscreen="1" width="100%" height="100%" volume="0" onload={loadIframe}></iframe>
    </div>
    <script>
        this.mixin(new vd_block(this, false))
        
        this.on('updated', function(){
            this.reCalculate()
        })
        this.on('mount', function(){
            this.reCalculate()
        })
        this.loadIframe = function(e) {
            this.reCalculate()
        }.bind(this)

        this.getLink = function(){
            var link = ''
            var setting = this.getState().setting
            if(setting.global.link.indexOf('youtube') != -1){
                var matches = setting.global.link.match(/(v=)([a-zA-Z0-9]+)/)
                if(matches != null){
                    var youtube_id = matches[2]
                    link = setting.global.link.replace('watch?v=', 'embed/') + "?playlist="+youtube_id+"&autoplay=1&controls=0&showinfo=0&disablekb=1&loop=1&rel=0&modestbranding"
                }
            } else if (setting.global.link.indexOf('vimeo') != -1){
                link = setting.global.link.replace('vimeo.com', 'player.vimeo.com/video') + '?autoplay=1&background=1&loop=1'
            }
            return link
        }.bind(this)
        
        this.reCalculate = function(){
            var content = $(this.root).closest('.block-container')
            content.css('position','');
            content.css('z-index','');
            content.css('left','');
            content.css('width','');

            if(this.getState('setting').global.design_padding_left == ''){
                content.css('padding-left','');
            }
            if(this.getState('setting').global.design_padding_right == ''){
                content.css('padding-right','');
            }
            var width_content = content.outerWidth();
            if(this.getState('setting').global.row_stretch !== '') {
                var left = content.offset().left - $('body').offset().left;
                var width_window = $('body').width();
                var right = width_window - left - content.width();
                content.css('position','relative');
                content.css('z-index','2');
                var direction = $('body').css('direction');
                if(direction == 'rtl'){
                    content.css('right','-'+right+'px');
                } else {
                    content.css('left','-'+left+'px');
                }
                content.css('width',width_window+'px');
                width_content = width_window;
                if(this.getState('setting').global.row_stretch === 'stretch_row'){
                    content.css('padding-left',left+'px');
                    content.css('padding-right',right+'px');
                }
                if(this.getState('setting').global.row_stretch === 'stretch_row_content_left'){
                    content.css('padding-right',right+'px');
                }
                if(this.getState('setting').global.row_stretch === 'stretch_row_content_right'){
                    content.css('padding-left',left+'px');
                }
            }
            if(this.getLink() && this.getState('setting').global.background_video){
                var video = $('.video-background', this.root);
                var height_content = content.outerHeight();
                var width = height_content/9*16;
                var height = height_content;

                if(width < width_content){
                    width = width_content;
                    height = width/16*9;
                    var margintop = (height-height_content)/2;
                }
                else{
                    var margintop = 0;
                }
                var marginleft =(width - width_content)/2;
                video.find('iframe').css('height',height+'px');
                video.find('iframe').css('width',width+'px');
                video.find('iframe').css('max-width','1000%');
                video.find('iframe').css('margin-left','-'+marginleft+'px');
                video.find('iframe').css('margin-top','-'+margintop+'px');
            }
        }.bind(this)
        $(window).on('resize', function(){
            this.reCalculate()
        }.bind(this))
    </script>
</vd-block-row>
<vd-block-row_inner>
    <virtual data-is="wrapper-blocks" block={opts.block}></virtual>

    <div class="video-background" if={getLink() && setting.global.background_video}>
        <iframe src="{getLink()}" frameborder="0" allowfullscreen="1" width="100%" height="100%" volume="0" onload={loadIframe}></iframe>
    </div>
    <script>
        this.mixin(new vd_block(this, false))
        this.on('updated', function(){
            this.reCalculate()
        })
        this.on('mount', function(){
            this.reCalculate()
        })
        loadIframe(e) {
            this.reCalculate()
        }.bind(this)

        this.getLink = function(){
            var link = ''
            if(this.getState('setting').global.link.indexOf('youtube') != -1){
                var matches = this.getState('setting').global.link.match(/(v=)([a-zA-Z0-9]+)/)
                if(matches != null){
                    var youtube_id = matches[2]
                    link = this.getState('setting').global.link.replace('watch?v=', 'embed/') + "?playlist="+youtube_id+"&autoplay=1&controls=0&showinfo=0&disablekb=1&loop=1&rel=0&modestbranding"
                }
            } else if (this.getState('setting').global.link.indexOf('vimeo') != -1){
                link = this.getState('setting').global.link.replace('vimeo.com', 'player.vimeo.com/video') + '?autoplay=1&background=1&loop=1'
            }
            return link
        }.bind(this)
        
        this.reCalculate = function(){
            var content = $(this.root).closest('.block-container')
            content.css('position','');
            content.css('z-index','');
            content.css('left','');
            content.css('width','');
            if(this.getState('setting').global.design_padding_left == ''){
                content.css('padding-left','');
            }
            if(this.getState('setting').global.design_padding_right == ''){
                content.css('padding-right','');
            }
            var width_content = content.outerWidth();
            if(this.getLink() && this.getState('setting').global.background_video){
                var video = $('.video-background', this.root);
                var height_content = content.outerHeight();
                var width = height_content/9*16;
                var height = height_content;

                if(width < width_content){
                    width = width_content;
                    height = width/16*9;
                    var margintop = (height-height_content)/2;
                }
                else{
                    var margintop = 0;
                }
                var marginleft =(width - width_content)/2;
                video.find('iframe').css('height',height+'px');
                video.find('iframe').css('width',width+'px');
                video.find('iframe').css('max-width','1000%');
                video.find('iframe').css('margin-left','-'+marginleft+'px');
                video.find('iframe').css('margin-top','-'+margintop+'px');
            }
        }.bind(this)
        $(window).on('resize', function(){
            this.reCalculate()
        }.bind(this))
    </script>
</vd-block-row_inner>
<vd-block-section_wrapper>
    <virtual data-is="wrapper-blocks" block={opts.block}></virtual>

    <div class="video-background" if={getLink() && getState().setting.global.background_video}>
        <iframe src="{getLink()}" frameborder="0" allowfullscreen="1" width="100%" height="100%" volume="0" onload={loadIframe}></iframe>
    </div>
    <script>
        this.mixin(new vd_block(this, false))
        
        this.on('updated', function(){
            this.reCalculate()
        })
        this.on('mount', function(){
            this.reCalculate()
        })
        this.loadIframe = function(e) {
            this.reCalculate()
        }.bind(this)

        this.getLink = function(){
            var link = ''
            var setting = this.getState().setting
            if(setting.global.link.indexOf('youtube') != -1){
                var matches = setting.global.link.match(/(v=)([a-zA-Z0-9]+)/)
                if(matches != null){
                    var youtube_id = matches[2]
                    link = setting.global.link.replace('watch?v=', 'embed/') + "?playlist="+youtube_id+"&autoplay=1&controls=0&showinfo=0&disablekb=1&loop=1&rel=0&modestbranding"
                }
            } else if (setting.global.link.indexOf('vimeo') != -1){
                link = setting.global.link.replace('vimeo.com', 'player.vimeo.com/video') + '?autoplay=1&background=1&loop=1'
            }
            return link
        }.bind(this)
        
        this.reCalculate = function(){
            var content = $(this.root).closest('.block-container')
            content.css('position','');
            content.css('z-index','');
            content.css('left','');
            content.css('width','');

            if(this.getState('setting').global.design_padding_left == ''){
                content.css('padding-left','');
            }
            if(this.getState('setting').global.design_padding_right == ''){
                content.css('padding-right','');
            }
            var width_content = content.outerWidth();
            if(this.getState('setting').global.row_stretch !== '') {
                var left = content.offset().left - $('body').offset().left;
                var width_window = $('body').width();
                var right = width_window - left - content.width();
                content.css('position','relative');
                content.css('z-index','2');
                var direction = $('body').css('direction');
                if(direction == 'rtl'){
                    content.css('right','-'+right+'px');
                } else {
                    content.css('left','-'+left+'px');
                }
                content.css('width',width_window+'px');
                width_content = width_window;
                if(this.getState('setting').global.row_stretch === 'stretch_row'){
                    content.css('padding-left',left+'px');
                    content.css('padding-right',right+'px');
                }
                if(this.getState('setting').global.row_stretch === 'stretch_row_content_left'){
                    content.css('padding-right',right+'px');
                }
                if(this.getState('setting').global.row_stretch === 'stretch_row_content_right'){
                    content.css('padding-left',left+'px');
                }
            }
            if(this.getLink() && this.getState('setting').global.background_video){
                var video = $('.video-background', this.root);
                var height_content = content.outerHeight();
                var width = height_content/9*16;
                var height = height_content;

                if(width < width_content){
                    width = width_content;
                    height = width/16*9;
                    var margintop = (height-height_content)/2;
                }
                else{
                    var margintop = 0;
                }
                var marginleft =(width - width_content)/2;
                video.find('iframe').css('height',height+'px');
                video.find('iframe').css('width',width+'px');
                video.find('iframe').css('max-width','1000%');
                video.find('iframe').css('margin-left','-'+marginleft+'px');
                video.find('iframe').css('margin-top','-'+margintop+'px');
            }
        }.bind(this)
        $(window).on('resize', function(){
            this.reCalculate()
        }.bind(this))
    </script>
</vd-block-section_wrapper>
<vd-block-text>
    <raw html={getState().setting.user.text}/>
    <script>
        this.mixin(new vd_block(this))
    </script>
</vd-block-text>
