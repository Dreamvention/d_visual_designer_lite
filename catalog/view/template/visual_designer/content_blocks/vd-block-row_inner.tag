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