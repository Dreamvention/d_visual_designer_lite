<vd-block-column>
    <virtual data-is="wrapper-blocks" block={opts.block}></virtual>
    <script>
        this.top = this.parent ? this.parent.top : this
        this.level = this.parent.level
        this.mixin({store:d_visual_designer})
    </script>
</vd-block-column>