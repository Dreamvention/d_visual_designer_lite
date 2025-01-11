<vd-block-row>
    <virtual data-is="wrapper-blocks" block={opts.block}></virtual>
    <script>
        this.setting = this.opts.block.setting
        this.top = this.parent ? this.parent.top : this
        this.level = this.parent.level
        this.mixin({store:d_visual_designer})
        this.on('update', function(){
            this.setting = this.opts.block.setting
        })
    </script>
</vd-block-row>